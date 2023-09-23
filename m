From: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v5 18/18] selftests/sgx: Add scripts for EPC cgroup testing
Date: Fri, 22 Sep 2023 20:06:57 -0700
Message-ID: <20230923030657.16148-19-haitao.huang@linux.intel.com>
References: <20230923030657.16148-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695438434; x=1726974434;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dZ4dr09FZCb8PLkHgNm+LEZeNQ2boJ7dLsvuHqxpIsY=;
  b=m0yMOlB/eV24uty8sh2g+qB/nyeDiDeJdkwLRFqUw0uvwLH2QOf+fsnh
   jaiFFfrpz4Gk3ZA9IX4AgVF3HMhPR33Pz6oGdqugzO8LZruHnsd3nGyxg
   fU9KkVbDW6alVgIx6J7Na+Q7IUUHhTESaiksasagIoSwX0MPCelEywxcT
   qcyZ4xhJgNgBO36vBQ3Fgh4PfHCZwAk8pJtz4679vzGRjp2pMIueFm408
   /9/3IAhIYAHXlTOdMlvrpYN5lXx7dgXFmsO1lHDh1RGOnQKuCv22NYvvJ
   T9Op0P0IkPdMbC6WWV80yUn93aB4Co9Qemxx3nZ+Qi7uF0l0u/HhWbpM0
   w==;
In-Reply-To: <20230923030657.16148-1-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, sohil.mehta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yangjie-0li6OtcxBFHby3iVrkZq2A@public.gmane.org

The scripts rely on cgroup-tools package from libcgroup [1].

To run selftests for epc cgroup:

sudo ./run_epc_cg_selftests.sh

With different cgroups, the script starts one or multiple concurrent SGX
selftests, each to run one unclobbered_vdso_oversubscribed test.
Each of such test tries to load an enclave of size equal to the EPC
capacity available on the platform. The script checks results against
the expectation set for each cgroup and report success or failure.

The script creates 3 different cgroups at the beginning with following
expectations:

1) SMALL - intentionally small enough to fail the test loading an
enclave of size equal to the capacity.
2) LARGE - large enough to run up to 4 concurrent tests but fail some if
more than 4 concurrent tests are run. The script start 4 expecting at
least one test to pass, and then starts 5 expecting at least one test
to fail.
3) LARGER - limit is the same as capacity, large enough to run lots of
concurrent tests. The script starts 10 of them and expects all pass.

To watch misc cgroup 'current' changes during testing, run this in a
separate terminal:

./watch_misc_for_tests.sh current

[1] https://github.com/libcgroup/libcgroup/blob/main/README

Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
V5:

- Added script with automatic results checking, remove the interactive
script.
- The script can run independent from the series below.

V4:

Note: Need to apply on top of this series previously reviewed:
https://lore.kernel.org/linux-sgx/20220905020411.17290-1-jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org/
---
 .../selftests/sgx/run_epc_cg_selftests.sh     | 147 ++++++++++++++++++
 .../selftests/sgx/watch_misc_for_tests.sh     |  13 ++
 2 files changed, 160 insertions(+)
 create mode 100755 tools/testing/selftests/sgx/run_epc_cg_selftests.sh
 create mode 100755 tools/testing/selftests/sgx/watch_misc_for_tests.sh

diff --git a/tools/testing/selftests/sgx/run_epc_cg_selftests.sh b/tools/testing/selftests/sgx/run_epc_cg_selftests.sh
new file mode 100755
index 000000000000..410c97ee6e18
--- /dev/null
+++ b/tools/testing/selftests/sgx/run_epc_cg_selftests.sh
@@ -0,0 +1,147 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2023 Intel Corporation.
+
+TEST_ROOT_CG=selftest
+cgcreate -g misc:$TEST_ROOT_CG
+if [ $? -ne 0 ]; then
+    echo "# Please make sure cgroup-tools is installed, and misc cgroup is mounted."
+    exit 1
+fi
+TEST_CG_SUB1=$TEST_ROOT_CG/test1
+TEST_CG_SUB2=$TEST_ROOT_CG/test2
+TEST_CG_SUB3=$TEST_ROOT_CG/test1/test3
+TEST_CG_SUB4=$TEST_ROOT_CG/test4
+
+cgcreate -g misc:$TEST_CG_SUB1
+cgcreate -g misc:$TEST_CG_SUB2
+cgcreate -g misc:$TEST_CG_SUB3
+cgcreate -g misc:$TEST_CG_SUB4
+
+# Default to V2
+CG_ROOT=/sys/fs/cgroup
+if [ ! -d "/sys/fs/cgroup/misc" ]; then
+    echo "# cgroup V2 is in use."
+else
+    echo "# cgroup V1 is in use."
+    CG_ROOT=/sys/fs/cgroup/misc
+fi
+
+CAPACITY=$(grep "sgx_epc" "$CG_ROOT/misc.capacity" | awk '{print $2}')
+# This is below number of VA pages needed for enclave of capacity size. So
+# should fail oversubscribed cases
+SMALL=$(( CAPACITY / 512 ))
+
+# At least load one enclave of capacity size successfully, maybe up to 4.
+# But some may fail if we run more than 4 concurrent enclaves of capacity size.
+LARGE=$(( SMALL * 4 ))
+
+# Load lots of enclaves
+LARGER=$CAPACITY
+echo "# Setting up limits."
+echo "sgx_epc $SMALL" | tee $CG_ROOT/$TEST_CG_SUB1/misc.max
+echo "sgx_epc $LARGE" | tee $CG_ROOT/$TEST_CG_SUB2/misc.max
+echo "sgx_epc $LARGER" | tee $CG_ROOT/$TEST_CG_SUB4/misc.max
+
+timestamp=$(date +%Y%m%d_%H%M%S)
+
+test_cmd="./test_sgx -t unclobbered_vdso_oversubscribed"
+
+echo "# Start unclobbered_vdso_oversubscribed with SMALL limit, expecting failure..."
+# Always use leaf node of misc cgroups so it works for both v1 and v2
+# these may fail on OOM
+cgexec -g misc:$TEST_CG_SUB3 $test_cmd >cgtest_small_$timestamp.log 2>&1 
+if [[ $? -eq 0 ]]; then
+    echo "# Fail on SMALL limit, not expecting any test passes."
+    cgdelete -r -g misc:$TEST_ROOT_CG
+    exit 1
+else
+    echo "# Test failed as expected."
+fi
+
+echo "# PASSED SMALL limit."
+
+echo "# Start 4 concurrent unclobbered_vdso_oversubscribed tests with LARGE limit, expecting at least one success...."
+pids=()
+for i in {1..4}; do
+    (
+        cgexec -g misc:$TEST_CG_SUB2 $test_cmd >cgtest_large_positive_$timestamp.$i.log 2>&1
+    ) &
+    pids+=($!)
+done
+
+any_success=0
+for pid in "${pids[@]}"; do
+    wait "$pid"
+    status=$?
+    if [[ $status -eq 0 ]]; then
+        any_success=1
+	echo "# Process $pid returned successfully."
+    fi
+done
+
+if [[ $any_success -eq 0 ]]; then
+    echo "# Failed on LARGE limit positive testing, no test passes."
+    cgdelete -r -g misc:$TEST_ROOT_CG
+    exit 1
+fi
+
+echo "# PASSED LARGE limit positive testing."
+
+echo "# Start 5 concurrent unclobbered_vdso_oversubscribed tests with LARGE limit, expecting at least one failure...."
+pids=()
+for i in {1..5}; do
+    (
+        cgexec -g misc:$TEST_CG_SUB2 $test_cmd >cgtest_large_negative_$timestamp.$i.log 2>&1
+    ) &
+    pids+=($!)
+done
+
+any_failure=0
+for pid in "${pids[@]}"; do
+    wait "$pid"
+    status=$?
+    if [[ $status -ne 0 ]]; then
+	echo "# Process $pid returned failure."
+        any_failure=1
+    fi
+done
+
+if [[ $any_failure -eq 0 ]]; then
+    echo "# Failed on LARGE limit negative testing, no test fails."
+    cgdelete -r -g misc:$TEST_ROOT_CG
+    exit 1
+fi
+
+echo "# PASSED LARGE limit negative testing."
+
+echo "# Start 10 concurrent unclobbered_vdso_oversubscribed tests with LARGER limit, expecting no failure...."
+pids=()
+for i in {1..10}; do
+    (
+        cgexec -g misc:$TEST_CG_SUB4 $test_cmd >cgtest_larger_$timestamp.$i.log 2>&1
+    ) &
+    pids+=($!)
+done
+
+any_failure=0
+for pid in "${pids[@]}"; do
+    wait "$pid"
+    status=$?
+    if [[ $status -ne 0 ]]; then
+	echo "# Process $pid returned failure."
+        any_failure=1
+    fi
+done
+
+if [[ $any_failure -ne 0 ]]; then
+    echo "# Failed on LARGER limit, at least one test fails."
+    cgdelete -r -g misc:$TEST_ROOT_CG
+    exit 1
+fi
+
+echo "# PASSED LARGER limit tests."
+
+echo "# PASSED ALL cgroup limit tests, cleanup cgroups..."
+cgdelete -r -g misc:$TEST_ROOT_CG
+echo "# done."
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

