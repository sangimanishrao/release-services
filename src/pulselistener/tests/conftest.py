# -*- coding: utf-8 -*-
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

import json
import os.path
import urllib.parse
from contextlib import contextmanager
from datetime import datetime
from datetime import timedelta
from unittest.mock import MagicMock

import hglib
import pytest
import responses
from taskcluster.utils import stringDate

from cli_common.phabricator import PhabricatorAPI

MOCK_DIR = os.path.join(os.path.dirname(__file__), 'mocks')


@pytest.fixture
def QueueMock():
    class Mock():
        def __init__(self):
            self.created_tasks = []

        def status(self, task_id):
            for status in ['failed', 'completed', 'exception', 'pending']:
                if status in task_id:
                    return {
                        'status': {
                            'state': status,
                        }
                    }
            assert False

        def task(self, task_id):
            now = datetime.utcnow()

            if 'retry:' in task_id:
                retry = int(task_id[task_id.index('retry:')+6])
            else:
                retry = 3

            return {
                'created': stringDate(now),
                'deadline': stringDate(now + timedelta(hours=2)),
                'dependencies': [],
                'expires': stringDate(now + timedelta(hours=24)),
                'payload': {
                    'command': ['/bin/command'],
                    'env': {},
                    'image': 'alpine',
                    'maxRunTime': 3600,
                },
                'priority': 'lowest',
                'provisionerId': 'aws-provisioner-v1',
                'requires': 'all-completed',
                'retries': retry,
                'scopes': [],
                'taskGroupId': 'group-{}'.format(task_id),
                'workerType': 'niceWorker'
            }

        def createTask(self, task_id, payload):
            self.created_tasks.append((task_id, payload))

    return Mock()


@pytest.fixture
def NotifyMock():
    class Mock():
        def __init__(self):
            self.email_obj = {}

        def email(self, obj):
            self.email_obj.update(obj)

    return Mock()


@pytest.fixture
def HooksMock():
    class Mock():
        def __init__(self):
            self.obj = {}

        def triggerHook(self, group_id, hook_id, payload):
            self.obj = {
              'group_id': group_id,
              'hook_id': hook_id,
              'payload': payload,
            }
            return {
                'status': {
                    'taskId': 'fake_task_id',
                },
            }

    return Mock()


@pytest.fixture
@contextmanager
def PhabricatorMock():
    '''
    Mock phabricator authentication process
    '''
    json_headers = {
        'Content-Type': 'application/json',
    }

    def _response(name):
        path = os.path.join(MOCK_DIR, 'phabricator', '{}.json'.format(name))
        assert os.path.exists(path)
        return open(path).read()

    def _phab_params(request):
        # What a weird way to send parameters
        return json.loads(urllib.parse.parse_qs(request.body)['params'][0])

    def _diff_search(request):
        params = _phab_params(request)
        assert 'constraints' in params
        rev = params['constraints']['revisionPHIDs'][0]
        return (200, json_headers, _response('search-{}'.format(rev)))

    def _diff_raw(request):
        params = _phab_params(request)
        assert 'diffID' in params
        return (200, json_headers, _response('raw-{}'.format(params['diffID'])))

    def _edges(request):
        params = _phab_params(request)
        assert 'sourcePHIDs' in params
        return (200, json_headers, _response('edges-{}'.format(params['sourcePHIDs'][0])))

    with responses.RequestsMock(assert_all_requests_are_fired=False) as resp:

        resp.add(
            responses.POST,
            'http://phabricator.test/api/user.whoami',
            body=_response('auth'),
            content_type='application/json',
        )

        resp.add_callback(
            responses.POST,
            'http://phabricator.test/api/edge.search',
            callback=_edges,
        )

        resp.add_callback(
            responses.POST,
            'http://phabricator.test/api/differential.diff.search',
            callback=_diff_search,
        )

        resp.add_callback(
            responses.POST,
            'http://phabricator.test/api/differential.getrawdiff',
            callback=_diff_raw,
        )

        yield PhabricatorAPI(
            url='http://phabricator.test/api/',
            api_key='deadbeef',
        )


@pytest.fixture
def RepoMock(tmpdir):
    '''
    Mock a local mercurial repo
    '''
    # Init empty repo
    repo_dir = str(tmpdir.realpath())
    hglib.init(repo_dir)

    # Add default pull in Mercurial config
    hgrc = tmpdir.join('.hg').join('hgrc')
    hgrc.write('[paths]\ndefault = {}'.format(repo_dir))

    # Open repo with config
    repo = hglib.open(repo_dir)

    # Commit a file on central
    readme = tmpdir.join('README.md')
    readme.write('Hello World')
    repo.add(str(readme.realpath()).encode('utf-8'))
    repo.branch(name=b'central', force=True)
    repo.commit(message=b'Readme', user='test')

    # Mock push to avoid reaching try server
    repo.push = MagicMock(return_value=True)

    return repo
