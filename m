Received: from mta0.migadu.com (out-78.mta0.migadu.com [91.218.175.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0706D443E20
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 12:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787229771; cv=none; b=ie30thjlQNEvZ//2o4cRRZ5KjswKbOOqHXN5cXffRrvV8O35NIFr0VH5H6NcCoG/BaaBKzywprxnpFdI6qiZqESW/xzB4quA57drw6IxxUGrZxTe0QxVGvbngI5FlA23r9VqRXRh8mmgktfvJzqDvj4vm1PUTPqxTA87Lhof9oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787229771; c=relaxed/simple;
	bh=jxPbR2mK9lljfvgwT3kZM/oMOKqspdf8wCL3DVZsWO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFB6Fpxgisk0y0JejMtseEokwYa2TcYypBAf/mSn3C5zzJgDUyAnL8cQSqj5NkJWISyzO22ZVwpnKMGB1W0nLGJ7gR7i9dvTHwDuy5C2RB8APpquh/cZ6zBwyIy5/gGa+dQaIT2H3jCH3FFOH5qzpdrdXugpjuvPTCLMSK+gp7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RrFpfKWR; arc=none smtp.client-ip=91.218.175.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RrFpfKWR"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=jxPbR2mK9lljfvgwT3kZM/oMOKqspdf8wCL3DVZsWO4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787229768; v=1; x=1787834568;
 b=RrFpfKWR36KFiTrmRSbXgUqiFjdZ4SsDmX0knnHR3DRR3LeloYfIaRAP9SOSXtw7cZyGty76
 876Lv2yvih7X+UH5TKMX6dT4/mRULLIOAZeQBFG1hIu3lStGlrvitTIfLcDesu/IyTBpX/0V2LV
 TRX32mFUXPI0UxmkYRy61AH4=
X-Envelope-To: cgroups@vger.kernel.org
Received: from zgp.. (223.70.159.239)
	by smtp.migadu.com with ESMTPS id ba9e50599f008768;
	Thu, 20 Aug 2026 12:42:48 +0000
X-Mizu-Trace-ID: ba9e50599f008768
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
Subject: [PATCH 07/17] selftests/cgroup: Test type-change validation with child-owned CPUs
Date: Thu, 20 Aug 2026 20:41:52 +0800
Message-ID: <20260820124202.517160-8-guopeng.zhang@linux.dev>
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

Create an isolated child which owns a CPU isolated at boot, then change
its parent from isolated to root. Check that the change succeeds without
altering the child or its isolated CPU.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 .../selftests/cgroup/test_cpuset_prs.sh       | 47 +++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 9a1cce4807b4..bc8dbb724d5c 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -1214,6 +1214,52 @@ test_boot_isolated()
 	echo "$TEST_NAME test PASSED."
 }
 
+#
+# A parent's type change must validate only CPUs owned directly by the parent,
+# not a boot-isolated CPU owned by a valid isolated child partition.
+#
+test_owned_cpus_housekeeping()
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
+	[[ $(cat A1/cpuset.cpus.partition) = isolated ]] || {
+		echo "Child partition changed during parent type change"
+		exit 1
+	}
+	check_isolcpus "." || {
+		echo "Parent type change corrupted child isolation"
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
@@ -1286,5 +1332,6 @@ run_state_test TEST_MATRIX
 run_remote_state_test REMOTE_TEST_MATRIX
 test_isolated
 test_boot_isolated
+test_owned_cpus_housekeeping
 test_inotify
 echo "All tests PASSED."
-- 
2.43.0

