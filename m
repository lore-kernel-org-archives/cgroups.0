Received: from mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113913C0A0E
	for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 09:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787911034; cv=none; b=qEKUM5gDweSFy6pQ7dJOUr2gyx6XbIhtS2bFQXyQb+T2Aatic3BB4TedBq6CmBWrSxaawTH73YU3A20NDR9MDlHUCv8dG4QTDQTkhXDoa+lgUj5bRewFZ9LeUji7FenSs9w3231zDJfkzcHhMOpnJUwC5+MqOtcjNo9jcf8tP9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787911034; c=relaxed/simple;
	bh=drPVOyolYCnPh2K4/e2rtcuRq5n2j3ZAGzXU3LXcVPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KdlXpRjXRNpq9W0i239R8r5sUUX1xhyxUFHnwU38Jb0lXvk7W5J7l1Oo2ocJHcPZjhoCeltZoCTQsdVV3Xb/ARMTwvFJyb7ObdFKGok8ldn94EkLNYsvOHkdFM0aI44lhmQ2t2oH/9gKGtOIYANx6q9zPBDkMlYWcP8M4sqrfu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KgE0S1JW; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KgE0S1JW"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=drPVOyolYCnPh2K4/e2rtcuRq5n2j3ZAGzXU3LXcVPo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787911030; v=1; x=1788515830;
 b=KgE0S1JWlsT+Wa0lEDd3pXviHotbS+YgVK3W2bLxP+PPaKFBoogPoK/RotQ3QIkq5dO///Gi
 zs62Rv4+LzJouFjbfKjrXLIYB8ULleIboBf/cTojEdXEl1eoTg7Z9cVvARJ5T6eygPbcdT7S8Px
 lD7k6rKs0YKyc/VMIzeCvwFY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id fd5b384a51f02d79;
	Fri, 28 Aug 2026 09:57:10 +0000
X-Mizu-Trace-ID: fd5b384a51f02d79
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
Subject: [PATCH v2 3/6] selftests/cgroup: Add tests for type changes with child-owned CPUs
Date: Fri, 28 Aug 2026 17:56:40 +0800
Message-ID: <20260828095643.13395-4-guopeng.zhang@linux.dev>
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

Create an isolated child that owns a boot-isolated CPU, then change its
parent type and CPU mask. Check that the child stays isolated and the
parent remains valid.

Cache the boot-isolated CPU data during setup so this test does not depend
on an earlier test calling get_boot_isolated_cpu(). Keep the per-test check
that the selected CPU is online.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 .../selftests/cgroup/test_cpuset_prs.sh       | 69 +++++++++++++++++--
 1 file changed, 65 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 9a1cce4807b4..ae27245e90bb 100755
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
@@ -1214,6 +1222,58 @@ test_boot_isolated()
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
 #
 # Wait for inotify event for the given file and read it
 # $1: cgroup file to wait for
@@ -1286,5 +1346,6 @@ run_state_test TEST_MATRIX
 run_remote_state_test REMOTE_TEST_MATRIX
 test_isolated
 test_boot_isolated
+test_child_owned_cpus
 test_inotify
 echo "All tests PASSED."
-- 
2.43.0

