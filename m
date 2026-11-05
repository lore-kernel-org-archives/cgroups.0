Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793841510;
	b=t3uezNlAqyNUhpgb1xGPyqppMpyyL1fCzUqpedl35Zj7dqEC0hvO0PLXOz9B/7I3NaiC
	 s0fP+1xn0dvB/9jR1f5T4yJnm7MEtvI7BdRDxQJOYLQGpJCHa8rwxyLgND76tWwwS77+y
	 j9V0SCE3ceYJn1fChNPGeojYlvs8a5NT8uUu7S4WzvWvN/l4hGC+lN/FpDT5qEU8r8Xe7
	 Ma8z/warOdP3BW6JtD8Mtq5wcq+NAGlvntf7kWERAsOe026NdIWyKCvcvmxIpqFN2hjLs
	 wckIpzJXsC089rw3DtPDJmIy22jsIglB7cbXkfl8rILmqUsZ1QvDhUpIcCwSKYVH7tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793841510;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6uEnGaOIenA5eydcCh3cJrgCw/m8lMhIgSChXVe85sM=;
	b=xm0Dy1Wz+Kf7D9K8Ii5I/jiaNn34YLJOAcPEXqFzMJTpvfz9wDD+gqM9JlOHVxDH+UZd
	 EqhEOw4e8M1blg1FfD2f8EaGhLQNsbw0CV/NAOLs1NuUd5DA1imIx9VjYQDUvATWOZ/oc
	 G71J5SfBAbdRXpaa2/hBSbUEqFyWVU8CgyJVCZqw5RfuqOQgMyJIvA3TKz0RSRoujWE7G
	 7rq6ZKwI4znNnB1HtSXcuvxTTRuskcVVBKKGgVYOzlgIlL4FbStduy6rBXRKuf1jWRHis
	 mVMB41Me9tNgFDhpKOQvCcdFpoVEo7a1usTIwC4koml9wYfGFYgTLUd6r5xUz9BXKJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QNytI8or;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E2B606A32F;
	Thu,  5 Nov 2026 01:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QNytI8or
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D36A1F00A21;
	Thu,  5 Nov 2026 01:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793841509;
	bh=6uEnGaOIenA5eydcCh3cJrgCw/m8lMhIgSChXVe85sM=;
	h=From:To:Cc:Subject:Date;
	b=QNytI8orpl2T6IdtqZ7UwDe2tMu/Md9OiMt0rM0MQFfG5cmmY3kMO8PhrDV3OW0Mp
	 SAbZYNbFbETl9czaiRlHp0tREwZevuCKsh5eYI8hQv0FsoGcSSSMsDTYO27QjWW2j7
	 +hQllQmgcx3mhAZrYf4c1eZg4rhuQyugaR3UdJ22FhkcqnX2huYLlC7lgIXUuwojRa
	 eQ4hjQaropjE9u/XfEbwDWXHC3DxS59KxQgB1/YhlYiZxSDIh5xp1xs4dum6Bs5h2l
	 ETIZX1VWIgF3MQUzCGjlz+yqGVJzZaDgwgBgEw3ZvzVJOgPp4coiNlmj4OcOuuB6Gn
	 RYcpBSaxMdaNQ==
From: Sasha Levin <sashal@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	David Vernet <void@manifault.com>,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests: cgroup: skip the cpu.max tests without CFS bandwidth control
Date: Wed,  4 Nov 2026 20:18:27 -0500
Message-ID: <20261105011827.1143972-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cpu.max only exists when the kernel is built with CONFIG_CFS_BANDWIDTH,
which arm64's defconfig does not enable. test_cpucg_max and
test_cpucg_max_nested then fail to write it and report a failure.

Skip both tests when cpu.max does not exist, and add CONFIG_CFS_BANDWIDTH
to the cgroup selftests' config.

Fixes: 889ab8113ef1 ("cgroup: Add test_cpucg_max() testcase")
Fixes: a79906570f96 ("cgroup: Add test_cpucg_max_nested() testcase")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
Tested on a 144-CPU Grace with KernelCI's arm64 defconfig build of
05441d697f7f9, which has CONFIG_CFS_BANDWIDTH unset: both tests now skip.

 tools/testing/selftests/cgroup/config     |  1 +
 tools/testing/selftests/cgroup/test_cpu.c | 10 ++++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/config b/tools/testing/selftests/cgroup/config
index 39f979690dd3b..aaf5872c71410 100644
--- a/tools/testing/selftests/cgroup/config
+++ b/tools/testing/selftests/cgroup/config
@@ -1,3 +1,4 @@
+CONFIG_CFS_BANDWIDTH=y
 CONFIG_CGROUPS=y
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_CGROUP_FREEZER=y
diff --git a/tools/testing/selftests/cgroup/test_cpu.c b/tools/testing/selftests/cgroup/test_cpu.c
index 3456e3e988c68..7119aa1db496c 100644
--- a/tools/testing/selftests/cgroup/test_cpu.c
+++ b/tools/testing/selftests/cgroup/test_cpu.c
@@ -694,8 +694,11 @@ static int test_cpucg_max(const char *root)
 	if (cg_create(cpucg))
 		goto cleanup;
 
-	if (cg_write(cpucg, "cpu.max", quota_buf))
+	if (cg_write(cpucg, "cpu.max", quota_buf)) {
+		if (errno == ENOENT)
+			ret = KSFT_SKIP;
 		goto cleanup;
+	}
 
 	struct cpu_hog_func_param param = {
 		.nprocs = 1,
@@ -768,8 +771,11 @@ static int test_cpucg_max_nested(const char *root)
 	if (cg_create(child))
 		goto cleanup;
 
-	if (cg_write(parent, "cpu.max", quota_buf))
+	if (cg_write(parent, "cpu.max", quota_buf)) {
+		if (errno == ENOENT)
+			ret = KSFT_SKIP;
 		goto cleanup;
+	}
 
 	struct cpu_hog_func_param param = {
 		.nprocs = 1,
-- 
2.53.0

