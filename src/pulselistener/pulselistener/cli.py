# -*- coding: utf-8 -*-
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

import os
import tempfile

import click

from cli_common.cli import taskcluster_options
from cli_common.log import init_logger
from cli_common.phabricator import PhabricatorAPI
from cli_common.taskcluster import get_secrets
from pulselistener import config
from pulselistener import task_monitoring
from pulselistener.listener import PulseListener


@click.command()
@click.option(
    '--cache-root',
    required=False,
    help='Cache root, used to pull changesets',
    default=os.path.join(tempfile.gettempdir(), 'pulselistener'),
)
@click.option(
    '--phab-revision',
    type=int,
    required=False,
    help='A Phabricator revision ID to test'
)
@taskcluster_options
def main(taskcluster_secret,
         taskcluster_client_id,
         taskcluster_access_token,
         cache_root,
         phab_revision,
         ):

    secrets = get_secrets(taskcluster_secret,
                          config.PROJECT_NAME,
                          required=(
                              'PULSE_USER',
                              'PULSE_PASSWORD',
                              'HOOKS',
                              'ADMINS',
                              'PHABRICATOR',
                              'MERCURIAL_REMOTE',
                          ),
                          existing=dict(
                              HOOKS=[],
                              ADMINS=['babadie@mozilla.com', 'mcastelluccio@mozilla.com']
                          ),
                          taskcluster_client_id=taskcluster_client_id,
                          taskcluster_access_token=taskcluster_access_token,
                          )

    init_logger(config.PROJECT_NAME,
                PAPERTRAIL_HOST=secrets.get('PAPERTRAIL_HOST'),
                PAPERTRAIL_PORT=secrets.get('PAPERTRAIL_PORT'),
                SENTRY_DSN=secrets.get('SENTRY_DSN'),
                MOZDEF=secrets.get('MOZDEF'),
                )

    task_monitoring.emails = secrets['ADMINS']

    phabricator = PhabricatorAPI(
        api_key=secrets['PHABRICATOR']['token'],
        url=secrets['PHABRICATOR']['url'],
    )

    pl = PulseListener(secrets['PULSE_USER'],
                       secrets['PULSE_PASSWORD'],
                       secrets['HOOKS'],
                       secrets['MERCURIAL_REMOTE'],
                       phabricator,
                       cache_root,
                       taskcluster_client_id,
                       taskcluster_access_token,
                       )
    click.echo('Listening to pulse messages...')

    if phab_revision:
        pl.add_revision(phab_revision)

    pl.run()


if __name__ == '__main__':
    main()
