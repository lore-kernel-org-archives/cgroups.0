Received: from mta1.migadu.com (out-164.mta1.migadu.com [95.215.58.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E32E442FA0
	for <cgroups@vger.kernel.org>; Wed,  2 Sep 2026 10:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788344818; cv=none; b=fm48L3WkXP88iRsyDZjZvLtmoi5TdexemurMAMzOMU946PN5HalhEVRQQj4mxoMcsaqo+eRU9uPUmDaJDQheN/J3U3yRz3oJBt9/bH469RwL54HO6BHoLMFGrFPRlWMg5rXcUw/AF1jOdC5JU/OBAtLJ+uIfnItB0vG251f6GmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788344818; c=relaxed/simple;
	bh=/ikd6VTrvjXZj78tpx3i6udPWaTYHhZauv7sMPOjvO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASFrU/mjtdtz6mdW6Ogb7nuJJJHmAZm3jgdYrQYwZuErvb2gwdRXl2ewm76yH7sUKU3JdwWhx6XrID9MkfJpOoboE9Y+lzabJHehkFus3uB8RltVP+D32bsD916n65TMkQiqZeOMSKxRXvTUrbLza/75jvahXhbPmec2k+LEXSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=o5o828pN; arc=none smtp.client-ip=95.215.58.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="o5o828pN"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=/ikd6VTrvjXZj78tpx3i6udPWaTYHhZauv7sMPOjvO8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788344814; v=1; x=1788949614;
 b=o5o828pNx8hX9eiYWQ/Q3YmA0iuFmlmbjpUfuJC28Vd1MhKt/42v5L/0m92Pzvi1EVYfHAm+
 Z20jBA5edgBlKMKc4i84Zws2m6eXh6A9PoaJdgeBGTnsOuVqPO7/g5hbike+g+KDw8Wui7RePBX
 oYQc5/2vHs+v68yV6uwyVzF8=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9d0f1adc879670a0;
	Wed, 02 Sep 2026 10:26:54 +0000
X-Mizu-Trace-ID: 9d0f1adc879670a0
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: cgroups@vger.kernel.org,
	longman@redhat.com,
	ridong.chen@linux.dev
Cc: tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH v3 4/7] selftests/cgroup: Test child CPU ownership in partition changes
Date: Wed,  2 Sep 2026 18:26:12 +0800
Message-ID: <20260902102615.79189-5-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902102615.79189-1-guopeng.zhang@linux.dev>
References: <20260902102615.79189-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

Create an isolated child which owns a boot-isolated CPU, then change its
parent's partition type and CPU mask. Verify that a valid child keeps its
CPUs and isolation state.

Also test trial parent masks which would invalidate the child because its
CPU mask is no longer covered or because it would consume every remaining
CPU of a populated parent. Verify that the returning boot-isolated CPU is
included in the parent's housekeeping check.

Cache the boot-isolated CPU during setup so the tests do not depend on the
order in which earlier test cases run.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 .../selftests/cgroup/test_cpuset_prs.sh       | 186 +++++++++++++++++-
 1 file changed, 182 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 9a1cce4807b4..a3df6b094e0f 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -107,6 +107,17 @@ then
 	echo "Pre-isolated CPUs: $BOOT_ISOLCPUS"
 fi
 
+# Cache the CPUs isolated from scheduler domains at boot.
+BOOT_ISOLATED_FILE=/sys/devices/system/cpu/isolated
+BOOT_CPUS=
+BOOT_CPU=
+if [[ -r $BOOT_ISOLATED_FILE ]]
+then
+	BOOT_CPUS=$(cat $BOOT_ISOLATED_FILE)
+	[[ -n "$BOOT_CPUS" ]] &&
+		BOOT_CPU=$(echo "$BOOT_CPUS" | sed -e 's/[,-].*//')
+fi
+
 cleanup()
 {
 	online_cpus
@@ -1158,25 +1169,22 @@ test_isolated()
 }
 
 #
-# Select an online CPU isolated from scheduler domains at boot.
+# Check that a boot-isolated CPU selected during initialization is online.
 # $1: test name used in the skip message
 #
 get_boot_isolated_cpu()
 {
 	TEST_NAME=$1
-	BOOT_ISOLATED_FILE=/sys/devices/system/cpu/isolated
 
 	[[ -r $BOOT_ISOLATED_FILE ]] || {
 		echo "$TEST_NAME test SKIPPED: boot isolation state unavailable"
 		return 1
 	}
-	BOOT_CPUS=$(cat $BOOT_ISOLATED_FILE)
 	[[ -n "$BOOT_CPUS" ]] || {
 		echo "$TEST_NAME test SKIPPED: no boot-isolated CPU"
 		return 1
 	}
 
-	BOOT_CPU=$(echo "$BOOT_CPUS" | sed -e 's/[,-].*//')
 	CPU_ONLINE=/sys/devices/system/cpu/cpu${BOOT_CPU}/online
 	[[ ! -e $CPU_ONLINE || $(cat $CPU_ONLINE) -eq 1 ]] || {
 		echo "$TEST_NAME test SKIPPED: CPU $BOOT_CPU is offline"
@@ -1214,6 +1222,174 @@ test_boot_isolated()
 	echo "$TEST_NAME test PASSED."
 }
 
+#
+# A parent's type and CPU-mask changes must check only CPUs owned directly by
+# the parent, not a boot-isolated CPU owned by a valid child partition.
+#
+test_child_owned_cpus()
+{
+	TEST_NAME="Child-owned CPU type change"
+	get_boot_isolated_cpu "$TEST_NAME" || return 0
+	echo "Running $TEST_NAME test ..."
+
+	cd $CGROUP2/test
+	echo member > cpuset.cpus.partition
+	echo +cpuset > cgroup.subtree_control
+	echo 2,$BOOT_CPU > cpuset.cpus
+	[[ $(cat cpuset.cpus.effective) = "2,$BOOT_CPU" ]] || {
+		echo "$TEST_NAME test SKIPPED: CPUs 2,$BOOT_CPU are unavailable"
+		echo "" > cpuset.cpus
+		cd $CGROUP2
+		return 0
+	}
+	test_partition isolated
+	mkdir A1
+	cd A1
+	echo $BOOT_CPU > cpuset.cpus
+	test_partition isolated
+	cd ..
+	test_effective_cpus 2
+	test_partition root
+	echo 2-3,$BOOT_CPU > cpuset.cpus
+	test_effective_cpus 2-3
+	[[ $(cat cpuset.cpus.partition) = root ]] || {
+		echo "Parent partition became invalid during CPU update"
+		exit 1
+	}
+	[[ $(cat A1/cpuset.cpus.partition) = isolated ]] || {
+		echo "Child partition changed during parent update"
+		exit 1
+	}
+	check_isolcpus "." || {
+		echo "Parent update corrupted child isolation"
+		exit 1
+	}
+	cd A1
+	test_partition member
+	cd ..
+	rmdir A1
+	test_partition member
+	echo "" > cpuset.cpus
+	cd $CGROUP2
+	echo "$TEST_NAME test PASSED."
+}
+
+#
+# A child that will become invalid under a trial parent CPU mask no longer
+# owns its CPUs for the purpose of the parent's housekeeping validation.
+#
+test_trial_child_invalidation()
+{
+	TEST_NAME="Trial child partition invalidation"
+	get_boot_isolated_cpu "$TEST_NAME" || return 0
+	echo "Running $TEST_NAME test ..."
+
+	cd $CGROUP2/test
+	echo member > cpuset.cpus.partition
+	echo +cpuset > cgroup.subtree_control
+	echo 2-3,$BOOT_CPU > cpuset.cpus
+	[[ $(cat cpuset.cpus.effective) = "2-3,$BOOT_CPU" ]] || {
+		echo "$TEST_NAME test SKIPPED: CPUs 2-3,$BOOT_CPU are unavailable"
+		echo "" > cpuset.cpus
+		cd $CGROUP2
+		return 0
+	}
+
+	#
+	# The child would fail validation with PERR_INVCPUS because CPU 2 is
+	# absent from the trial parent mask. CPU $BOOT_CPU must therefore be
+	# checked as a CPU that will return to the parent, not subtracted as
+	# child-owned.
+	#
+	test_partition isolated
+	mkdir A1
+	cd A1
+	echo 2,$BOOT_CPU > cpuset.cpus
+	test_partition isolated
+	cd ..
+	test_partition root
+	test_effective_cpus 3
+	echo 3,$BOOT_CPU > cpuset.cpus
+	grep -q '^root invalid (partition config conflicts with housekeeping setup)$' \
+		cpuset.cpus.partition || {
+		echo "PERR_INVCPUS trial allowed the parent to bypass housekeeping validation"
+		exit 1
+	}
+	[[ $(cat A1/cpuset.cpus.partition) = "isolated invalid"* ]] || {
+		echo "Child did not become invalid after the parent CPU update"
+		exit 1
+	}
+	[[ $(cat $CGROUP2/cpuset.cpus.effective) = "$CPULIST" ]] || {
+		echo "PERR_INVCPUS trial did not release the parent partition CPUs"
+		exit 1
+	}
+	#
+	# An invalid isolated child retains its isolation state after its
+	# effective_xcpus is cleared. Explicitly transition CPU 2 through an
+	# isolated partition before starting the next case.
+	#
+	echo member > A1/cpuset.cpus.partition
+	rmdir A1
+	echo member > cpuset.cpus.partition
+	echo "" > cpuset.cpus
+	echo 2 > cpuset.cpus
+	test_partition isolated
+	test_partition member
+	echo "" > cpuset.cpus
+	check_isolcpus "." || {
+		echo "PERR_INVCPUS trial cleanup left CPU 2 isolated"
+		exit 1
+	}
+
+	#
+	# With a task in the parent, the child would fail validation with
+	# PERR_NOCPUS because it consumes all CPUs in the trial mask. Its
+	# boot-isolated CPU must therefore participate in the parent's
+	# housekeeping validation.
+	#
+	echo 2-3,$BOOT_CPU > cpuset.cpus
+	test_partition isolated
+	mkdir A1
+	cd A1
+	echo 2,$BOOT_CPU > cpuset.cpus
+	test_partition isolated
+	cd ..
+	test_partition root
+	test_effective_cpus 3
+	echo 0 > cgroup.procs
+	echo 2,$BOOT_CPU > cpuset.cpus
+	echo 0 > $CGROUP2/cgroup.procs
+	grep -q '^root invalid (partition config conflicts with housekeeping setup)$' \
+		cpuset.cpus.partition || {
+		echo "PERR_NOCPUS trial allowed the parent to bypass housekeeping validation"
+		exit 1
+	}
+	[[ $(cat A1/cpuset.cpus.partition) = "isolated invalid"* ]] || {
+		echo "Child did not become invalid after exhausting the parent CPUs"
+		exit 1
+	}
+	[[ $(cat $CGROUP2/cpuset.cpus.effective) = "$CPULIST" ]] || {
+		echo "PERR_NOCPUS trial did not release the parent partition CPUs"
+		exit 1
+	}
+	# Clean up the retained isolation state as in the PERR_INVCPUS case.
+	echo member > A1/cpuset.cpus.partition
+	rmdir A1
+	echo member > cpuset.cpus.partition
+	echo "" > cpuset.cpus
+	echo 2 > cpuset.cpus
+	test_partition isolated
+	test_partition member
+	echo "" > cpuset.cpus
+	check_isolcpus "." || {
+		echo "PERR_NOCPUS trial cleanup left CPU 2 isolated"
+		exit 1
+	}
+
+	cd $CGROUP2
+	echo "$TEST_NAME test PASSED."
+}
+
 #
 # Wait for inotify event for the given file and read it
 # $1: cgroup file to wait for
@@ -1286,5 +1462,7 @@ run_state_test TEST_MATRIX
 run_remote_state_test REMOTE_TEST_MATRIX
 test_isolated
 test_boot_isolated
+test_child_owned_cpus
+test_trial_child_invalidation
 test_inotify
 echo "All tests PASSED."
-- 
2.43.0

