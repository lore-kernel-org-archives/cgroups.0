From: Waiman Long <longman@redhat.com>
Subject: [PATCH 5/5] kselftest/cgroup: Add cpuset v2 partition root state test
Date: Thu,  3 Jun 2021 17:24:16 -0400
Message-ID: <20210603212416.25934-6-longman@redhat.com>
References: <20210603212416.25934-1-longman@redhat.com>
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622755506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=AQptwpPftuvlepn0c//rvhF5er61at0BxM0RAxJWfRY=;
        b=GUXXohO57oA9vFuy/PH+2LpUx90eZLZ1HgxS5DvW9Ami7Ga0rYcj/Fw8koMqmC/afSMwxf
        9k8NuVRxGlS4RzWRWGm7cDbF2s5xgRM/8+NTS24jKgv76+yZCYjuDlqrJrGv2CkQ//PPhv
        qwfRJ5bAwKuE4jKQnny6ev2CpvoQg3M=
In-Reply-To: <20210603212416.25934-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Waiman Long <longman@redhat.com>

Add a test script for exercising the cpuset v2 partition root state code.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 tools/testing/selftests/cgroup/Makefile       |   2 +-
 .../selftests/cgroup/test_cpuset_prs.sh       | 141 ++++++++++++++++++
 2 files changed, 142 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/cgroup/test_cpuset_prs.sh

diff --git a/tools/testing/selftests/cgroup/Makefile b/tools/testing/selftests/cgroup/Makefile
index f027d933595b..e8ff3ffc3a43 100644
--- a/tools/testing/selftests/cgroup/Makefile
+++ b/tools/testing/selftests/cgroup/Makefile
@@ -4,7 +4,7 @@ CFLAGS += -Wall -pthread
 all:
 
 TEST_FILES     := with_stress.sh
-TEST_PROGS     := test_stress.sh
+TEST_PROGS     := test_stress.sh test_cpuset_prs.sh
 TEST_GEN_PROGS = test_memcontrol
 TEST_GEN_PROGS += test_kmem
 TEST_GEN_PROGS += test_core
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
new file mode 100755
index 000000000000..6a9c02c301b5
--- /dev/null
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -0,0 +1,141 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test for cpuset v2 partition root state (PRS)
+#
+# The sched verbose flag is set, if available, so that the console log
+# can be examined for the correct setting of scheduling domain.
+#
+
+skip_test() {
+	echo "$1"
+	echo "Test SKIPPED"
+	exit 0
+}
+
+[[ $(id -u) -eq 0 ]] || skip_test "Test must be run as root!"
+
+# Set sched verbose flag, if available
+[[ -d /sys/kernel/debug/sched ]] && echo Y > /sys/kernel/debug/sched/verbose
+
+# Find cgroup v2 mount point
+CGROUP2=$(mount | grep "^cgroup2" | awk -e '{print $3}')
+[[ -n "$CGROUP2" ]] || skip_test "Cgroup v2 mount point not found!"
+
+CPUS=$(lscpu | grep "^CPU(s)" | sed -e "s/.*:[[:space:]]*//")
+[[ $CPUS -lt 4 ]] && skip_test "Test needs at least 4 cpus available!"
+
+cd $CGROUP2
+echo +cpuset > cgroup.subtree_control
+[[ -d test ]] || mkdir test
+cd test
+echo 2-3 > cpuset.cpus
+TYPE=$(cat cpuset.cpus.partition)
+[[ $TYPE = member ]] || echo member > cpuset.cpus.partition
+
+console_msg()
+{
+	MSG=$1
+	echo "$MSG"
+	echo "" > /dev/console
+	echo "$MSG" > /dev/console
+	sleep 1
+}
+
+test_partition()
+{
+	EXPECTED_VAL=$1
+	echo $EXPECTED_VAL > cpuset.cpus.partition
+	[[ $? -eq 0 ]] || exit 1
+	ACTUAL_VAL=$(cat cpuset.cpus.partition)
+	[[ $ACTUAL_VAL != $EXPECTED_VAL ]] && {
+		echo "cpuset.cpus.partition: expect $EXPECTED_VAL, found $EXPECTED_VAL"
+		echo "Test FAILED"
+		exit 1
+	}
+}
+
+test_effective_cpus()
+{
+	EXPECTED_VAL=$1
+	ACTUAL_VAL=$(cat cpuset.cpus.effective)
+	[[ "$ACTUAL_VAL" != "$EXPECTED_VAL" ]] && {
+		echo "cpuset.cpus.effective: expect '$EXPECTED_VAL', found '$EXPECTED_VAL'"
+		echo "Test FAILED"
+		exit 1
+	}
+}
+
+# Adding current process to cgroup.procs as a test
+test_add_proc()
+{
+	OUTSTR="$1"
+	ERRMSG=$((echo $$ > cgroup.procs) |& cat)
+	echo $ERRMSG | grep -q "$OUTSTR"
+	[[ $? -ne 0 ]] && {
+		echo "cgroup.procs: expect '$OUTSTR', got '$ERRMSG'"
+		echo "Test FAILED"
+		exit 1
+	}
+	echo $$ > $CGROUP2/cgroup.procs	# Move out the task
+}
+
+#
+# Testing the new "root-nolb" partition root type
+#
+console_msg "Change from member to root"
+test_partition root
+
+console_msg "Change from root to root-nolb"
+test_partition root-nolb
+
+console_msg "Change from root-nolb to member"
+test_partition member
+
+console_msg "Change from member to root-nolb"
+test_partition root-nolb
+
+console_msg "Change from root-nolb to root"
+test_partition root
+
+console_msg "Change from root to member"
+test_partition member
+
+#
+# Testing partition root with no cpu
+#
+console_msg "Distribute all cpus to child partition"
+echo +cpuset > cgroup.subtree_control
+test_partition root
+
+mkdir t1
+cd t1
+echo 2-3 > cpuset.cpus
+test_partition root
+test_effective_cpus 2-3
+cd ..
+test_effective_cpus ""
+
+console_msg "Moving task to partition test"
+test_add_proc "No space left"
+cd t1
+test_add_proc ""
+cd ..
+
+console_msg "Shrink and expand child partition"
+cd t1
+echo 2 > cpuset.cpus
+cd ..
+test_effective_cpus 3
+cd t1
+echo 2-3 > cpuset.cpus
+cd ..
+test_effective_cpus ""
+
+# Cleaning up
+console_msg "Cleaning up"
+echo $$ > $CGROUP2/cgroup.procs
+[[ -d t1 ]] && rmdir t1
+cd ..
+rmdir test
+echo "Test PASSED"
-- 
2.18.1

