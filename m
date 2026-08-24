Received: from mta0.migadu.com (out-80.mta0.migadu.com [91.218.175.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921FB311968
	for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 02:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787536939; cv=none; b=az9w8vHZQQiN9xf8LLdlRlEQzXVo/Pf31bktl3+RPMdReDwUBlDRJ1dGvhzBFsvtocbL2VR0C28z5jZXXpZOVficwDOCgAG1SBjg/cEWKJr2qZns1Afi/2XHjnkYZspC8h+Vme/mGN4ycWhe4bH5F3MmIzBmqrH3T96+XmnB1VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787536939; c=relaxed/simple;
	bh=xzuiCyOQkUshOw/dQoqpJd4cRH9nvcLkQjfLEBLwDso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vAUOH8nRoNdfo8kzniAuvy8clNzfnPwr9PYuFCJLFjvYrnvgqFZ8QpFqtbiwvbz1Y+A21lD9kxlzOTAmOnK1dLJTuKdsp9wAOJROa4GdakNtDbC5g+afget7pkPViiKOZS4OHxk2KBSndEWqiTooBMJ4LvE4AfTbNSRpH/DQ+JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ePUAeIbT; arc=none smtp.client-ip=91.218.175.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ePUAeIbT"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=xzuiCyOQkUshOw/dQoqpJd4cRH9nvcLkQjfLEBLwDso=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787536935; v=1; x=1788141735;
 b=ePUAeIbTsQ3Rv6zSNS/shGcqqDvT0PGk0+NwtpsC6xA/eciFnPFeVnvM+2Yc7uay5Ijn0Xoo
 dPzzR2mBYOFXYefTVixXiRpTCPF7mbwhvWOgjQxctm3f2wuSzSXbPD/TeMP7T5CUKj5XdFgtIs6
 jC+HqdrZqNez2yVAbu0j0HMI=
X-Envelope-To: cgroups@vger.kernel.org
Received: from zgp.. (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 0c116af405542692;
	Mon, 24 Aug 2026 02:02:15 +0000
X-Mizu-Trace-ID: 0c116af405542692
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH v2 3/3] selftests/cgroup: Add test for preserving boot-isolated CPUs
Date: Mon, 24 Aug 2026 10:01:40 +0800
Message-ID: <20260824020140.21130-4-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260824020140.21130-1-guopeng.zhang@linux.dev>
References: <20260824020140.21130-1-guopeng.zhang@linux.dev>
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

