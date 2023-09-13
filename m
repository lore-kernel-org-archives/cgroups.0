From: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v4 18/18] selftests/sgx: Add scripts for epc cgroup testing
Date: Tue, 12 Sep 2023 21:06:35 -0700
Message-ID: <20230913040635.28815-19-haitao.huang@linux.intel.com>
References: <20230913040635.28815-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694578141; x=1726114141;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=deuShLNhhDjtFREz/27mivDy0NewVu2ghIGkXQ/WYEo=;
  b=BGRpBZfbppv+HPdcdDiUGm5ZsH97PhSvaBsw8VcWZcpsB4SUH9rRPcfV
   Nmp8pezs6suwzQuuJhnFzIiQR5lmRF3hvk1kfKY8CkeyVSHrBbTZqsuMZ
   2x6RlryAKoFTAPLCaGU9UbSl+GlI7uEdqeQUT6C4+OvKnUXR9BS6dT+kn
   H1ckmoL9mD9l+iIfzuFZl7sS4xcUbXYJKUqbjgYEFjXUquytISxIpW3VZ
   2MddTacl+TuHDhHCz4cCxamn5mK+KueABxA3ldQ2LkslKwcjw2G6rxdyB
   aM0U4WOXSEJEWReESUcw2Gfs32O8BYGQg4gegAA2IREGS7uVIUXNuTI36
   w==;
In-Reply-To: <20230913040635.28815-1-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, sohil.mehta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yangjie-0li6OtcxBFHby3iVrkZq2A@public.gmane.org

Scripts rely on cgroup-tools package from libcgroup [1].

To test:
1) sudo ./setup_epc_cg.sh (optional one time setup)
2) sudo ./run_tests_in_misc_cg.sh

To watch misc group current:
./watch_misc_for_tests.sh current

[1] https://github.com/libcgroup/libcgroup/blob/main/README

Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
V4:

Note: Need to apply on top of this series previously reviewed:
https://lore.kernel.org/linux-sgx/20220905020411.17290-1-jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org/
---
 .../selftests/sgx/run_tests_in_misc_cg.sh     | 68 +++++++++++++++++++
 tools/testing/selftests/sgx/setup_epc_cg.sh   | 29 ++++++++
 .../selftests/sgx/watch_misc_for_tests.sh     | 13 ++++
 3 files changed, 110 insertions(+)
 create mode 100755 tools/testing/selftests/sgx/run_tests_in_misc_cg.sh
 create mode 100755 tools/testing/selftests/sgx/setup_epc_cg.sh
 create mode 100755 tools/testing/selftests/sgx/watch_misc_for_tests.sh

diff --git a/tools/testing/selftests/sgx/run_tests_in_misc_cg.sh b/tools/testing/selftests/sgx/run_tests_in_misc_cg.sh
new file mode 100755
index 000000000000..63da7b23b74e
--- /dev/null
+++ b/tools/testing/selftests/sgx/run_tests_in_misc_cg.sh
@@ -0,0 +1,68 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2023 Intel Corporation.
+
+if ! lscgroup | grep -q "test/test1/test3$"; then
+  echo "setting up cgroups for testing..."
+  ./setup_epc_cg.sh
+fi
+
+cmd='./test_sgx'
+default_test="augment_via_eaccept_long"
+
+# We use 'tail' to skip header lines and 'sed' to remove 'enclave' from the first non-header line.
+list=$($cmd -l 2>&1 | tail -n +4 | sed '0,/^enclave/ s/^enclave//' | sed 's/^ *//')
+
+IFS=$'\n' read -d '' -r -a lines <<< "$list"
+lines=("all" "${lines[@]}")
+
+echo "Available tests:"
+for i in "${!lines[@]}"; do
+  # Check if the current line is the default test
+  if [[ ${lines[$i]} == *"$default_test"* ]]; then
+    echo "$((i)). ${lines[$i]} (default)"
+  else
+    echo "$((i)). ${lines[$i]}"
+  fi
+done
+
+echo "Please enter the number of the test you want to run (or press enter for the default test):"
+read choice
+
+if [ -z "$choice" ]; then
+  testname="$default_test"
+else
+  testname="${lines[$choice]}"
+fi
+
+if [ "$testname" == "all" ]; then
+  test_cmd="$cmd"
+else
+  test_cmd="$cmd -t $testname"
+fi
+
+timestamp=$(date +%Y%m%d_%H%M%S)
+
+# Always use leaf node of misc cgroups so it works for both v1 and v2
+# these may fail on OOM
+nohup bash -c "cgexec -g misc:test/test1/test3 $test_cmd" >test1_1_$timestamp.log 2>&1 &
+nohup bash -c "cgexec -g misc:test/test1/test3 $test_cmd" >test1_2_$timestamp.log 2>&1 &
+nohup bash -c "cgexec -g misc:test/test1/test3 $test_cmd" >test1_3_$timestamp.log 2>&1 &
+nohup bash -c "cgexec -g misc:test/test1/test3 $test_cmd" >test1_4_$timestamp.log 2>&1 &
+nohup bash -c "cgexec -g misc:test/test1/test3 $test_cmd" >test1_5_$timestamp.log 2>&1 &
+
+# These tests may timeout on oversubscribed tests on 4G EPC
+nohup bash -c "cgexec -g misc:test/test2 $test_cmd" >test2_1_$timestamp.log 2>&1 &
+nohup bash -c "cgexec -g misc:test/test2 $test_cmd" >test2_2_$timestamp.log 2>&1 &
+nohup bash -c "cgexec -g misc:test/test2 $test_cmd" >test2_3_$timestamp.log 2>&1 &
+nohup bash -c "cgexec -g misc:test/test2 $test_cmd" >test2_4_$timestamp.log 2>&1 &
+nohup bash -c "cgexec -g misc:test/test2 $test_cmd" >test2_5_$timestamp.log 2>&1 &
+nohup bash -c "cgexec -g misc:test/test2 $test_cmd" >test2_6_$timestamp.log 2>&1 &
+nohup bash -c "cgexec -g misc:test/test2 $test_cmd" >test2_7_$timestamp.log 2>&1 &
+nohup bash -c "cgexec -g misc:test/test2 $test_cmd" >test2_8_$timestamp.log 2>&1 &
+
+# this should work on 4G EPC
+nohup bash -c "cgexec -g misc:test4 $test_cmd" >test4_1_$timestamp.log 2>&1 &
+nohup bash -c "cgexec -g misc:test4 $test_cmd" >test4_2_$timestamp.log 2>&1 &
+nohup bash -c "cgexec -g misc:test4 $test_cmd" >test4_3_$timestamp.log 2>&1 &
+nohup bash -c "cgexec -g misc:test4 $test_cmd" >test4_4_$timestamp.log 2>&1 &
diff --git a/tools/testing/selftests/sgx/setup_epc_cg.sh b/tools/testing/selftests/sgx/setup_epc_cg.sh
new file mode 100755
index 000000000000..5fd137a66436
--- /dev/null
+++ b/tools/testing/selftests/sgx/setup_epc_cg.sh
@@ -0,0 +1,29 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2023 Intel Corporation.
+
+cgcreate -g misc:test
+if [ $? -ne 0 ]; then
+    echo "Please make sure cgroup-tools is installed, and misc cgroup is mounted."
+    exit 1
+fi
+cgcreate -g misc:test/test1
+cgcreate -g misc:test/test1/test3
+cgcreate -g misc:test/test2
+cgcreate -g misc:test4
+
+# Setup for a platform with 4G EPC
+LARGER=4096000000
+LARGE=409600000
+SMALL=4096000
+if [ ! -d "/sys/fs/cgroup/misc" ]; then
+    echo "cgroups v2 is in use. Only leaf nodes can run a process"
+    echo "sgx_epc $SMALL" | tee /sys/fs/cgroup/test/test1/misc.max
+    echo "sgx_epc $LARGE" | tee /sys/fs/cgroup/test/test2/misc.max
+    echo "sgx_epc $LARGER" | tee /sys/fs/cgroup/test4/misc.max
+else
+    echo "cgroups v1 is in use."
+    echo "sgx_epc $SMALL" | tee /sys/fs/cgroup/misc/test/test1/misc.max
+    echo "sgx_epc $LARGE" | tee /sys/fs/cgroup/misc/test/test2/misc.max
+    echo "sgx_epc $LARGER" | tee /sys/fs/cgroup/misc/test4/misc.max
+fi
diff --git a/tools/testing/selftests/sgx/watch_misc_for_tests.sh b/tools/testing/selftests/sgx/watch_misc_for_tests.sh
new file mode 100755
index 000000000000..dbd38f346e7b
--- /dev/null
+++ b/tools/testing/selftests/sgx/watch_misc_for_tests.sh
@@ -0,0 +1,13 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2023 Intel Corporation.
+
+if [ -z "$1" ]
+  then
+    echo "No argument supplied, please provide 'max', 'current' or 'events'"
+    exit 1
+fi
+
+watch -n 1 "find /sys/fs/cgroup -wholename */test*/misc.$1 -exec sh -c \
+    'echo \"\$1:\"; cat \"\$1\"' _ {} \;"
+
-- 
2.25.1

