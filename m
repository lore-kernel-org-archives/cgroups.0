Received: from mta1.migadu.com (out-38.mta1.migadu.com [95.215.58.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8035B4457DE
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 12:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787229754; cv=none; b=O41EbxZdbqNDbOaOOVJAJBoHNWJwWNMW+Fx4j4el95q0N37xngZGNlGhE+LVBe1C2tr4NuGzTSzuTCX2BcTCN5lEiRY2XvgVrdwiVEYAiOdIyVInZt1HQUvjlClYajtiPjaWrxMqkTI+2752G5PT5DiNJmc/AjuKaVSb0NMvtkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787229754; c=relaxed/simple;
	bh=xzuiCyOQkUshOw/dQoqpJd4cRH9nvcLkQjfLEBLwDso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZSUDJWxjakOrUOcoZ/TTCCPR8ogCu7sd4GQGFK3Xj9qyYcJqZ8tjSmA8ZZA8fo0q+wxPJUEDZ1kiXF2qB2ouvpizpmd7dc/D1QF6Xxt6Y5PK4VaAmXllRx4JadfBz1RRL/I+wJk3EpGCsrr3ZVdQypImApBBgBIloHaZM55iA20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pw4q/B8Y; arc=none smtp.client-ip=95.215.58.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pw4q/B8Y"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=xzuiCyOQkUshOw/dQoqpJd4cRH9nvcLkQjfLEBLwDso=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787229750; v=1; x=1787834550;
 b=pw4q/B8Yr/DahBGnAs2/z9A6qeFb9DTCnbFKVy0F69whTIjperD6LyewZUvInvoadYqi7c1H
 rvJyNWoFW7XgIfvIOGo+tGck7IdkRV4ZsAOFLthBdO2VOBydgrQrWlxbZUthgsvC01MvLp+Qjr7
 mMhXOQZAziZ5oEp9/rLH7rlQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: from zgp.. (223.70.159.239)
	by smtp.migadu.com with ESMTPS id e10e27d3da9d99c5;
	Thu, 20 Aug 2026 12:42:30 +0000
X-Mizu-Trace-ID: e10e27d3da9d99c5
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: longman@redhat.com,
	cgroups@vger.kernel.org
Cc: ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH 03/17] selftests/cgroup: Test boot-isolated CPU partition release
Date: Thu, 20 Aug 2026 20:41:48 +0800
Message-ID: <20260820124202.517160-4-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260820124202.517160-1-guopeng.zhang@linux.dev>
References: <20260820124202.517160-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

Put a CPU isolated at boot into an isolated partition, change the
partition back to member and check that the CPU remains isolated.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 .../selftests/cgroup/test_cpuset_prs.sh       | 58 +++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index fdb3185570d4..131d8b4551ef 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -1155,6 +1155,63 @@ test_isolated()
 	pause 0.05
 }
 
+#
+# Select an online CPU isolated from scheduler domains at boot.
+# $1: test name used in the skip message
+#
+get_boot_isolated_cpu()
+{
+	TEST_NAME=$1
+	BOOT_ISOLATED_FILE=/sys/devices/system/cpu/isolated
+
+	[[ -r $BOOT_ISOLATED_FILE ]] || {
+		echo "$TEST_NAME test SKIPPED: boot isolation state unavailable"
+		return 1
+	}
+	BOOT_CPUS=$(cat $BOOT_ISOLATED_FILE)
+	[[ -n "$BOOT_CPUS" ]] || {
+		echo "$TEST_NAME test SKIPPED: no boot-isolated CPU"
+		return 1
+	}
+
+	BOOT_CPU=$(echo "$BOOT_CPUS" | sed -e 's/[,-].*//')
+	CPU_ONLINE=/sys/devices/system/cpu/cpu${BOOT_CPU}/online
+	[[ ! -e $CPU_ONLINE || $(cat $CPU_ONLINE) -eq 1 ]] || {
+		echo "$TEST_NAME test SKIPPED: CPU $BOOT_CPU is offline"
+		return 1
+	}
+}
+
+#
+# A CPU isolated at boot must stay isolated after it is released by a dynamic
+# isolated partition.
+#
+test_boot_isolated()
+{
+	TEST_NAME="Boot-isolated CPU partition release"
+	get_boot_isolated_cpu "$TEST_NAME" || return 0
+	echo "Running $TEST_NAME test ..."
+
+	cd $CGROUP2/test
+	echo member > cpuset.cpus.partition
+	echo $BOOT_CPU > cpuset.cpus
+	[[ $(cat cpuset.cpus.effective) = "$BOOT_CPU" ]] || {
+		echo "$TEST_NAME test SKIPPED: CPU $BOOT_CPU is unavailable"
+		echo "" > cpuset.cpus
+		cd $CGROUP2
+		return 0
+	}
+	test_partition isolated
+	test_partition member
+	check_isolcpus "." || {
+		echo "Boot-isolated CPU $BOOT_CPU was lost after partition release"
+		exit 1
+	}
+	echo "" > cpuset.cpus
+	cd $CGROUP2
+	echo "$TEST_NAME test PASSED."
+}
+
 #
 # Wait for inotify event for the given file and read it
 # $1: cgroup file to wait for
@@ -1226,5 +1283,6 @@ trap cleanup 0 2 3 6
 run_state_test TEST_MATRIX
 run_remote_state_test REMOTE_TEST_MATRIX
 test_isolated
+test_boot_isolated
 test_inotify
 echo "All tests PASSED."
-- 
2.43.0

