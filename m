Received: from mta0.migadu.com (out-87.mta0.migadu.com [91.218.175.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2994457D3
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 12:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787229781; cv=none; b=mXWNrp6f8MH+ZzfJ+KxicTn1I6sUMWlB5StWGWMM5OXJPtY+hrl7Y0gIEWNQ4Lg1l1IRl9hfnjm77xbphwIGQQUhez97/bv7xNVNl/wnoXVLh7kltyhPeuurpWG8u/LlM/wSdwFuMeFzYiXl/pI0dK2OhXerVRLFSS97Yj6Y+Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787229781; c=relaxed/simple;
	bh=6JU0p/Mbmxgk7gewp7yNkURQEZbjwDYnQ6iCJMjybt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kykj7PQ7Ez3mOqM+hVzw+OKQNbfrFnEUKA8EFleYtedzJEaBudEcRc2XmHRpJ/X4zs8lHQB8XSc3AWLSV144K2ktUbOEv60j7p6328/OhnpqXKARZBxhWTVOBovzQCuDxOoWqfOveRVxkAf2qtAmfedASEvo4r7slf5ANefY4iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=brlgC4g1; arc=none smtp.client-ip=91.218.175.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="brlgC4g1"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=6JU0p/Mbmxgk7gewp7yNkURQEZbjwDYnQ6iCJMjybt0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787229776; v=1; x=1787834576;
 b=brlgC4g1GR4ejqYtVLuGEs8dJzqMx5kOkE5rte3sUc8rUek2DlFbzowetUnY+EN1yam9Dw6c
 lpJDlZEWHb3WfuEqokRsaO1MnVivIOvCFqgEO/GlwvBUDb7hKeFlWqftCn1AeYLPHGK6gp2kNGQ
 U3WvHg5fN4KUuTRpdR+fYb5A=
X-Envelope-To: cgroups@vger.kernel.org
Received: from zgp.. (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 0ba0aa442e9239da;
	Thu, 20 Aug 2026 12:42:56 +0000
X-Mizu-Trace-ID: 0ba0aa442e9239da
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
Subject: [PATCH 09/17] selftests/cgroup: Test rejected partition type changes
Date: Thu, 20 Aug 2026 20:41:54 +0800
Message-ID: <20260820124202.517160-10-guopeng.zhang@linux.dev>
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

Exercise housekeeping rejection for local and remote partition type
changes. Check the invalid state, the CPUs returned to the top cpuset and
the boot-time isolation state of those CPUs.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 .../selftests/cgroup/test_cpuset_prs.sh       | 93 +++++++++++++++++++
 1 file changed, 93 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index bc8dbb724d5c..35c19738aaa4 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -1260,6 +1260,97 @@ test_owned_cpus_housekeeping()
 	echo "$TEST_NAME test PASSED."
 }
 
+#
+# A local type change rejected by the boot housekeeping constraint must release
+# the partition CPUs and preserve their boot-isolated state.
+#
+test_partition_type_failure()
+{
+	TEST_NAME="Rejected local partition type change"
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
+# Exercise the same rejected type change for a remote partition.
+#
+test_remote_partition_type_failure()
+{
+	TEST_NAME="Rejected remote partition type change"
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
@@ -1333,5 +1424,7 @@ run_remote_state_test REMOTE_TEST_MATRIX
 test_isolated
 test_boot_isolated
 test_owned_cpus_housekeeping
+test_partition_type_failure
+test_remote_partition_type_failure
 test_inotify
 echo "All tests PASSED."
-- 
2.43.0

