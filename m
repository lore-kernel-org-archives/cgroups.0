Received: from mta0.migadu.com (out-163.mta0.migadu.com [91.218.175.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C587337C927
	for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 09:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787911049; cv=none; b=N5Sll9xLFMBsXyZj0dtM2yk0Zy1ja69D7ASsGd3NWjpH7GaOzExMbD/M075IrG58RJqFG7GpfEESD7VlIYefROxbgDxbPdS8IMmmbDr6fqTDQVTu80j18e00YcTromHvJ49zpheswucRglYKOZEVDdTu3nD+LO61ZOf4IDPR0r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787911049; c=relaxed/simple;
	bh=8gctiQayN9AteUHWBqHT2qKA3oPtMk+DGZXUaD6Q10Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gS8hI7SeIlbRAZTXsuPVNbo5KvoaWpFK+IxSLRoDnhr9PeGTeqfQO7S4G/BKA24WdfXgwFc0FRVNJDNgUqO5eWUAKvG0rufsMVoI4sRafWQ85lAJ2vB164RoVGi5/6ieUm9MD5C0z0zP/ykaGRpP0LcPk68Wzkx4UW0FPMAlUS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=toQXFrvC; arc=none smtp.client-ip=91.218.175.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="toQXFrvC"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=8gctiQayN9AteUHWBqHT2qKA3oPtMk+DGZXUaD6Q10Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787911043; v=1; x=1788515843;
 b=toQXFrvCxBaMDBbXjaFh4NEnQkU+MS3cVayA61G77Tb1zlVwqbKdGTFG2C13AMgjZM9/f1jH
 fdW7eSjHHdaUrqvZT+Lwhk3NBj0we9N6TnahdvReiX+2HyWPyc4RkW0U72RdftZdVEQBIHfHpug
 iTDUr4AwgAWak6iiuoQDnp1c=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 990eda6ec407a941;
	Fri, 28 Aug 2026 09:57:23 +0000
X-Mizu-Trace-ID: 990eda6ec407a941
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
Subject: [PATCH v2 6/6] selftests/cgroup: Add CPU release tests for type-change validation failures
Date: Fri, 28 Aug 2026 17:56:43 +0800
Message-ID: <20260828095643.13395-7-guopeng.zhang@linux.dev>
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

Exercise housekeeping validation failures for local and remote partition
type changes. Check that the requested partition type becomes invalid,
its CPUs are returned to the top cpuset and their boot-time isolation
state is preserved.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 .../selftests/cgroup/test_cpuset_prs.sh       | 93 +++++++++++++++++++
 1 file changed, 93 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 72fe5ce48eff..9b236826166c 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -1419,6 +1419,97 @@ test_housekeeping_cpu_return()
 	echo "$TEST_NAME test PASSED."
 }
 
+#
+# A local type change that fails the boot housekeeping constraint must release
+# the partition CPUs and preserve their boot-isolated state.
+#
+test_partition_type_failure()
+{
+	TEST_NAME="Local partition type-change validation failure"
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
+	echo root > cpuset.cpus.partition
+	grep -q '^root invalid (partition config conflicts with housekeeping setup)$' \
+		cpuset.cpus.partition || {
+		echo "Partition type failure did not produce the expected state"
+		exit 1
+	}
+	[[ $(cat $CGROUP2/cpuset.cpus.effective) = "$CPULIST" ]] || {
+		echo "Partition type failure did not release CPU $BOOT_CPU"
+		exit 1
+	}
+	check_isolcpus "." || {
+		echo "Partition type failure lost boot-isolated CPU $BOOT_CPU"
+		exit 1
+	}
+	echo member > cpuset.cpus.partition
+	echo "" > cpuset.cpus
+	cd $CGROUP2
+	echo "$TEST_NAME test PASSED."
+}
+
+#
+# Exercise the same type-change validation failure for a remote partition.
+#
+test_remote_partition_type_failure()
+{
+	TEST_NAME="Remote partition type-change validation failure"
+	get_boot_isolated_cpu "$TEST_NAME" || return 0
+	echo "Running $TEST_NAME test ..."
+
+	cd $CGROUP2/test
+	echo member > cpuset.cpus.partition
+	echo +cpuset > cgroup.subtree_control
+	echo $BOOT_CPU > cpuset.cpus
+	echo $BOOT_CPU > cpuset.cpus.exclusive
+	[[ $(cat cpuset.cpus.effective) = "$BOOT_CPU" ]] || {
+		echo "$TEST_NAME test SKIPPED: CPU $BOOT_CPU is unavailable"
+		echo "" > cpuset.cpus.exclusive
+		echo "" > cpuset.cpus
+		cd $CGROUP2
+		return 0
+	}
+	mkdir A1
+	cd A1
+	echo $BOOT_CPU > cpuset.cpus
+	echo $BOOT_CPU > cpuset.cpus.exclusive
+	test_partition isolated
+	echo root > cpuset.cpus.partition
+	grep -q '^root invalid (partition config conflicts with housekeeping setup)$' \
+		cpuset.cpus.partition || {
+		echo "Remote type failure did not produce the expected state"
+		exit 1
+	}
+	[[ $(cat $CGROUP2/cpuset.cpus.effective) = "$CPULIST" ]] || {
+		echo "Remote type failure did not release CPU $BOOT_CPU"
+		exit 1
+	}
+	check_isolcpus "." || {
+		echo "Remote type failure lost boot-isolated CPU $BOOT_CPU"
+		exit 1
+	}
+	echo member > cpuset.cpus.partition
+	echo "" > cpuset.cpus.exclusive
+	echo "" > cpuset.cpus
+	cd ..
+	rmdir A1
+	echo "" > cpuset.cpus.exclusive
+	echo "" > cpuset.cpus
+	cd $CGROUP2
+	echo "$TEST_NAME test PASSED."
+}
+
 #
 # Wait for inotify event for the given file and read it
 # $1: cgroup file to wait for
@@ -1493,5 +1584,7 @@ test_isolated
 test_boot_isolated
 test_child_owned_cpus
 test_housekeeping_cpu_return
+test_partition_type_failure
+test_remote_partition_type_failure
 test_inotify
 echo "All tests PASSED."
-- 
2.43.0

