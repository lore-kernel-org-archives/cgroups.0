Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3BC46EC84;
	Sun, 11 Oct 2026 22:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791758061; cv=none; b=IDO0KjMHBnsu44yNTCfuCfZq39dEjG9p/No4bwbNzBSYbthk/ZwMPu8hvI0/mGjy3zQtII8Tpr+ek70gJhV0oAzv4YR2eLjonimY8MObrIqa0vuMT8KRarfqVPOjTWNCBGsfSJg6vLAyR/hubVZgHR4LyTNw6r4jZTYPieX20ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791758061; c=relaxed/simple;
	bh=FtIcu6AuXNFhD75PsUd5wJaXxDlCmgnClBrQK3EYzQA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b1zjjmSOkEkOiETHlxu/kynirMv1d+VFRSTYpzQVVk/CZ/tPCgzQT8IeKH+G4qMIyLGtK3GNSkXYs8h0e/MHq1osfdcfn3Z1pt6c8OrGrdcJWdz/N8t50aEG2cyRbrxxyr87e//zf2c3zQFD9T558555kXXZPxx3oWy9ffWTih0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bfwRQ5EK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bfwRQ5EK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74831F0089B;
	Sun, 11 Oct 2026 22:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791758060;
	bh=f7AQDySFLtUgs27lY0yLdMRGLjRcMyst2lqiD9WLTvk=;
	h=From:To:Cc:Subject:Date;
	b=bfwRQ5EKiy+BsKqVol4YNekR1lb8bmZRSyWcXRM+ykDAm8obV7Kkbtx0LWy0ZlxFp
	 +ACJ5dsaAMoKcwxX6fg9fuhep3GXxTxXJuqeVZ0wm1+xAf7FEv6HOtWtHfCim5aIsg
	 moDgm6EY17vwuRBOkCdE5It9NSVy5IKa7nf2WrjhtS6GmbjDXJEAxaUlaPx3Br3ZgE
	 6vd/6wbViCXA7WnSMbcnqmneBPOTtAgKY7nYcrg3NtKBWiVbM1syFAMthdHqMAfFrO
	 5FL9iW5G2+BeydrWsFNUNNqXqmvfuH/nAU6YjBdp9xkxYOgit8Q2sppNn6+n75kytX
	 a2RaoKbXNvfLg==
From: Sasha Levin <sashal@kernel.org>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Amir Goldstein <amir73il@gmail.com>,
	"T.J. Mercier" <tjmercier@google.com>
Cc: Sasha Levin <sashal@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] selftests/cgroup: free the paths returned by cg_control()
Date: Sun, 11 Oct 2026 18:33:38 -0400
Message-ID: <20261011223358.2327625-10-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cg_control() returns a path allocated with malloc(). The two callers
that pass it straight to inotify_add_watch() never free it, and pass
NULL to it if the allocation fails.

Keep the path in a local variable, check it, and free it when done.

Fixes: 5313bfe425c8a ("kselftests: cgroup: add freezer controller self-tests")
Fixes: 2de27980e1d46 ("selftests: memcg: Add tests for IN_DELETE_SELF and IN_IGNORED")
Assisted-by: LLM
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/lib/cgroup_util.c | 13 ++++++++++---
 tools/testing/selftests/cgroup/test_memcontrol.c |  9 +++++++--
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/cgroup/lib/cgroup_util.c b/tools/testing/selftests/cgroup/lib/cgroup_util.c
index 2596c12cd8645..ed99a235e76e1 100644
--- a/tools/testing/selftests/cgroup/lib/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/lib/cgroup_util.c
@@ -626,18 +626,25 @@ int clone_into_cgroup_run_wait(const char *cgroup)
 
 static int __prepare_for_wait(const char *cgroup, const char *filename)
 {
-	int fd, ret = -1;
+	char *path;
+	int fd, ret;
+
+	path = cg_control(cgroup, filename);
+	if (!path)
+		return -1;
 
 	fd = inotify_init1(0);
 	if (fd == -1)
-		return fd;
+		goto out;
 
-	ret = inotify_add_watch(fd, cg_control(cgroup, filename), IN_MODIFY);
+	ret = inotify_add_watch(fd, path, IN_MODIFY);
 	if (ret == -1) {
 		close(fd);
 		fd = -1;
 	}
 
+out:
+	free(path);
 	return fd;
 }
 
diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 047d487f6dd57..7bcf772bcea2d 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -1677,7 +1677,7 @@ static int read_event(int inotify_fd, int expected_event, int expected_wd)
 static int test_memcg_inotify_delete_file(const char *root)
 {
 	int ret = KSFT_FAIL;
-	char *memcg = NULL;
+	char *memcg = NULL, *events = NULL;
 	int fd = -1, wd;
 
 	memcg = cg_name(root, "memcg_test_0");
@@ -1692,7 +1692,11 @@ static int test_memcg_inotify_delete_file(const char *root)
 	if (fd == -1)
 		goto cleanup;
 
-	wd = inotify_add_watch(fd, cg_control(memcg, "memory.events"), IN_DELETE_SELF);
+	events = cg_control(memcg, "memory.events");
+	if (!events)
+		goto cleanup;
+
+	wd = inotify_add_watch(fd, events, IN_DELETE_SELF);
 	if (wd == -1)
 		goto cleanup;
 
@@ -1714,6 +1718,7 @@ static int test_memcg_inotify_delete_file(const char *root)
 		close(fd);
 	if (memcg)
 		cg_destroy(memcg);
+	free(events);
 	free(memcg);
 
 	return ret;
-- 
2.53.0

