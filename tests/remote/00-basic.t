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
# Test remote host settings.
. $(dirname $0)/test_header
#-------------------------------------------------------------------------------
set_test_number 4
#-------------------------------------------------------------------------------
install_suite $TEST_NAME_BASE basic
#-------------------------------------------------------------------------------
TEST_NAME=$TEST_NAME_BASE-validate
run_ok $TEST_NAME cylc validate $SUITE_NAME
#-------------------------------------------------------------------------------
TEST_NAME=$TEST_NAME_BASE-run
suite_run_ok $TEST_NAME cylc run --reference-test --debug $SUITE_NAME
#-------------------------------------------------------------------------------
TEST_NAME=$TEST_NAME_BASE-userathost
SUITE_RUN_DIR=$(cylc get-global-config --print-run-dir)/$SUITE_NAME
echo $CYLC_TEST_TASK_OWNER@$CYLC_TEST_TASK_HOST > userathost
cmp_ok userathost - <<__OUT__
$(sqlite3 $SUITE_RUN_DIR/cylc-suite.db "select host from task_states where name=='foo'")
__OUT__
#-------------------------------------------------------------------------------
TEST_NAME=$TEST_NAME_BASE-hostonly
echo $CYLC_TEST_TASK_HOST > hostonly
cmp_ok hostonly - <<__OUT__
$(sqlite3 $SUITE_RUN_DIR/cylc-suite.db "select host from task_states where name=='bar'")
__OUT__
#-------------------------------------------------------------------------------
purge_suite $SUITE_NAME
