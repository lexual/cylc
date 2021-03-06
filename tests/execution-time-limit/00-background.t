#!/bin/bash
# THIS FILE IS PART OF THE CYLC SUITE ENGINE.
# Copyright (C) 2008-2016 NIWA
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#-------------------------------------------------------------------------------
# Test execution time limit, background/at job
. "$(dirname "$0")/test_header"

set_test_number 5
install_suite "${TEST_NAME_BASE}" "${TEST_NAME_BASE}"

CYLC_TEST_BATCH_SYS=${TEST_NAME_BASE##??-}

run_ok "${TEST_NAME_BASE}-validate" \
    cylc validate \
    -s "CYLC_TEST_BATCH_SYS=${CYLC_TEST_BATCH_SYS}" \
    "${SUITE_NAME}"
suite_run_ok "${TEST_NAME_BASE}-run" \
    cylc run --reference-test --debug \
    -s "CYLC_TEST_BATCH_SYS=${CYLC_TEST_BATCH_SYS}" \
    "${SUITE_NAME}"

LOGD="$(cylc get-global-config --print-run-dir)/${SUITE_NAME}/log/job/1/foo"
grep_ok '# Execution time limit: 5.0' "${LOGD}/01/job"
grep_ok 'CYLC_JOB_EXIT=\(ERR\|XCPU\)' "${LOGD}/01/job.status"
grep_ok 'CYLC_JOB_EXIT=SUCCEEDED' "${LOGD}/02/job.status"

purge_suite "${SUITE_NAME}"
exit
