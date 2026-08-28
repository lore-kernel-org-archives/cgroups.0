Received: from mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923543C8C46
	for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 09:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787911039; cv=none; b=VhLrrlNqcmSAhZK68LNeJEFBoCfyhW0Gr7wG3rIZ3PTnvUr9VJKgfBcuYziSOAwEdHSVnPJJ0eVYfy63y/HHJe4PzcBVPxFJ5bH/PWqY6Vkb9q/h/YXsmiATF+EJJyQ1xRqPTvklRmr5agPqQB/+1VYiRrxby+y3MiAtyY8/mMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787911039; c=relaxed/simple;
	bh=zEzSEhXHQRf73su3lkfr19aUrV+8DzpORBooU0RabIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIuAiINH9Ic6ph8HgZFmhnTyOpfPj0flVxRPuLpTn4FkkCCI9QtVrKGc1ZbG/BSFeWtfae3JOCVpGS5xNSr0cKEe8xmGlHsi2BM6+kKLkO+vm5QkOQyQAT0xkATlSCQyOGWaBmF8BanGhMlAEkM13PAXQ7+gYfvgdeQAhwIkLGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cSOhaKPn; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cSOhaKPn"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=zEzSEhXHQRf73su3lkfr19aUrV+8DzpORBooU0RabIA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787911034; v=1; x=1788515834;
 b=cSOhaKPnYrxIU4keJw3WA78i/94iK5ZxvPuwcEw5uHEacbFKRnTPBl8kuxcXPkCvynvbBUkV
 G+quX47OJmKR2GfM4BbG9V8bPj6XT9jeLL6hkD2dVDrA5YdQdadPpC2v29uAu2WS57kdIkfKjfB
 8ccuSy+nxj+VpFDD4MWwhJe4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c8e864e92068d122;
	Fri, 28 Aug 2026 09:57:14 +0000
X-Mizu-Trace-ID: c8e864e92068d122
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
Subject: [PATCH v2 4/6] selftests/cgroup: Add tests for housekeeping CPU return to isolated parents
Date: Fri, 28 Aug 2026 17:56:41 +0800
Message-ID: <20260828095643.13395-5-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260828095643.13395-1-guopeng.zhang@linux.dev>
References: <20260828095643.13395-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

Return the last housekeeping CPU from a root child to an isolated parent.
Check that the parent becomes invalid and releases its CPUs instead of
adding the returned CPU to the isolated mask.

Repeat the test with two isolated ancestors and check that the outermost
isolated partition is invalidated.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 .../selftests/cgroup/test_cpuset_prs.sh       | 146 ++++++++++++++++++
 1 file changed, 146 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index ae27245e90bb..72fe5ce48eff 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -1222,6 +1222,30 @@ test_boot_isolated()
 	echo "$TEST_NAME test PASSED."
 }
 
+# Return success if CPU $2 is present in cpulist $1.
+cpulist_contains()
+{
+	local CPULIST_ARG=$1
+	local CPU_ARG=$2
+	local ITEM FIRST LAST
+	local OLD_IFS=$IFS
+
+	IFS=,
+	for ITEM in $CPULIST_ARG
+	do
+		FIRST=${ITEM%-*}
+		LAST=${ITEM#*-}
+		[[ $ITEM != *-* ]] && LAST=$FIRST
+		if [[ $CPU_ARG -ge $FIRST && $CPU_ARG -le $LAST ]]
+		then
+			IFS=$OLD_IFS
+			return 0
+		fi
+	done
+	IFS=$OLD_IFS
+	return 1
+}
+
 #
 # A parent's type and CPU-mask changes must check only CPUs owned directly by
 # the parent, not a boot-isolated CPU owned by a valid child partition.
@@ -1274,6 +1298,127 @@ test_child_owned_cpus()
 	echo "$TEST_NAME test PASSED."
 }
 
+#
+# Returning the last housekeeping CPU to an isolated parent must invalidate
+# the isolated partition instead of adding that CPU to the isolated mask.
+#
+test_housekeeping_cpu_return()
+{
+	TEST_NAME="Housekeeping CPU return"
+	NOHZ_FILE=/sys/devices/system/cpu/nohz_full
+	[[ -r $NOHZ_FILE ]] || {
+		echo "$TEST_NAME test SKIPPED: no nohz_full state"
+		return 0
+	}
+	NOHZ_CPUS=$(cat $NOHZ_FILE)
+	[[ -n "$NOHZ_CPUS" && "$NOHZ_CPUS" != "(null)" ]] || {
+		echo "$TEST_NAME test SKIPPED: no nohz_full CPUs"
+		return 0
+	}
+
+	HK_CPU=
+	HK_COUNT=0
+	TYPE_CPUS=()
+	for ((CPU=0; CPU < NR_CPUS; CPU++))
+	do
+		CPU_ONLINE=/sys/devices/system/cpu/cpu${CPU}/online
+		[[ ! -e $CPU_ONLINE || $(cat $CPU_ONLINE) -eq 1 ]] || continue
+		cpulist_contains "$BOOT_CPUS" $CPU && continue
+		if cpulist_contains "$NOHZ_CPUS" $CPU
+		then
+			[[ ${#TYPE_CPUS[@]} -lt 3 ]] && TYPE_CPUS+=("$CPU")
+		else
+			HK_CPU=$CPU
+			((HK_COUNT++))
+		fi
+	done
+
+	[[ $HK_COUNT -eq 1 && ${#TYPE_CPUS[@]} -ge 2 ]] || {
+		echo "$TEST_NAME test SKIPPED: requires one full housekeeping CPU"
+		return 0
+	}
+	echo "Running $TEST_NAME test ..."
+
+	cd $CGROUP2/test
+	echo member > cpuset.cpus.partition
+	echo +cpuset > cgroup.subtree_control
+	echo $HK_CPU,${TYPE_CPUS[0]},${TYPE_CPUS[1]} > cpuset.cpus
+	test_partition root
+	mkdir A1
+	cd A1
+	echo $HK_CPU > cpuset.cpus
+	test_partition root
+	cd ..
+	test_partition isolated
+	cd A1
+	test_partition member
+	cd ..
+	grep -q '^isolated invalid (partition config conflicts with housekeeping setup)$' \
+		cpuset.cpus.partition || {
+		echo "Isolated parent remained valid after housekeeping CPU return"
+		exit 1
+	}
+	[[ $(cat $CGROUP2/cpuset.cpus.effective) = "$CPULIST" ]] || {
+		echo "Housekeeping CPU return did not release the partition CPUs"
+		exit 1
+	}
+	check_isolcpus "." || {
+		echo "Housekeeping CPU was added to the isolated mask"
+		exit 1
+	}
+	rmdir A1
+	echo member > cpuset.cpus.partition
+	echo "" > cpuset.cpus
+
+	if [[ ${#TYPE_CPUS[@]} -lt 3 ]]
+	then
+		echo "Nested $TEST_NAME test SKIPPED: requires three nohz_full CPUs"
+		cd $CGROUP2
+		echo "$TEST_NAME test PASSED."
+		return 0
+	fi
+
+	# Repeat the check with two isolated ancestors.
+	echo $HK_CPU,${TYPE_CPUS[0]},${TYPE_CPUS[1]},${TYPE_CPUS[2]} > cpuset.cpus
+	test_partition root
+	mkdir A1
+	cd A1
+	echo $HK_CPU,${TYPE_CPUS[1]},${TYPE_CPUS[2]} > cpuset.cpus
+	test_partition root
+	echo +cpuset > cgroup.subtree_control
+	mkdir A2
+	cd A2
+	echo $HK_CPU > cpuset.cpus
+	test_partition root
+	cd ..
+	test_partition isolated
+	cd ..
+	test_partition isolated
+	cd A1/A2
+	test_partition member
+	cd ../..
+	grep -q '^isolated invalid (partition config conflicts with housekeeping setup)$' \
+		cpuset.cpus.partition || {
+		echo "Outermost isolated partition remained valid after housekeeping CPU return"
+		exit 1
+	}
+	[[ $(cat $CGROUP2/cpuset.cpus.effective) = "$CPULIST" ]] || {
+		echo "Nested housekeeping CPU return did not release the partition CPUs"
+		exit 1
+	}
+	check_isolcpus "." || {
+		echo "Nested housekeeping CPU return added the CPU to the isolated mask"
+		exit 1
+	}
+	rmdir A1/A2
+	echo member > A1/cpuset.cpus.partition
+	rmdir A1
+	echo member > cpuset.cpus.partition
+	echo "" > cpuset.cpus
+	cd $CGROUP2
+	echo "$TEST_NAME test PASSED."
+}
+
 #
 # Wait for inotify event for the given file and read it
 # $1: cgroup file to wait for
@@ -1347,5 +1492,6 @@ run_remote_state_test REMOTE_TEST_MATRIX
 test_isolated
 test_boot_isolated
 test_child_owned_cpus
+test_housekeeping_cpu_return
 test_inotify
 echo "All tests PASSED."
-- 
2.43.0

