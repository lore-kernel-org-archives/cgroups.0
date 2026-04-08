Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB232727F3;
	Wed,  8 Apr 2026 18:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674345; cv=none; b=ueWrxcWLydiRiG5Ptc2Eq4Hl+wAxQptl9hKKyTLpuyyvYodMrbrllkGSnpAmOlz6bWrPoZDxh54D7srIe41QriHEMtb6GsvUO+92VRBp0Krmgf11F7m/7zHa26+jbhwHdUteMbuwVzhGyTyAE+6ahnIpMf1JM7iVkoG0DJo/kfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674345; c=relaxed/simple;
	bh=SELW4TiPptRnmXdWxotjOyA8YS4BchLlO1nacMGkv0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6/DYzY6+Ta9qVSCEERfImnTck2vxHmODxa2Lt2R2wJmbB7fsoTqtLmvES185kSLek/Aj/r5PXtEYHeyxLD/dEkaquSrtD9oTC83sCwBbAst9jEt51ZnSIbLq810zQYauKhkAOceRBcmoIPt4lQlzueZxtMaZMZ6l6FTfOPre+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LrfXExgC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LrfXExgC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05BE3C19421;
	Wed,  8 Apr 2026 18:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674345;
	bh=SELW4TiPptRnmXdWxotjOyA8YS4BchLlO1nacMGkv0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LrfXExgC9mZ6zR2d2+voUKOxgql672vZmMJyY+qTi5bbIgLcG5QRA4PvuafTK/ILl
	 DQavDPl1NP8CmiW4XYQ98ZlcE7EaNyhFdlCD2wL8OfgR5XiK4lnSt+CdqC5zEtupgj
	 oY0qoegv7aPKcU0+mcEv1PgggFzyN8JX65d/fJ0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Tejun Heo <tj@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	cgroups@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 034/311] selftests/cgroup: Dont require synchronous populated update on task exit
Date: Wed,  8 Apr 2026 20:00:34 +0200
Message-ID: <20260408175940.688785924@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 6680c162b4850976ee52b57372eddc4450c1d074 ]

test_cgcore_populated (test_core) and test_cgkill_{simple,tree,forkbomb}
(test_kill) check cgroup.events "populated 0" immediately after reaping
child tasks with waitpid(). This used to work because cgroup_task_exit() in
do_exit() unlinked tasks from css_sets before exit_notify() woke up
waitpid().

d245698d727a ("cgroup: Defer task cgroup unlink until after the task is done
switching out") moved the unlink to cgroup_task_dead() in
finish_task_switch(), which runs after exit_notify(). The populated counter
is now decremented after the parent's waitpid() can return, so there is no
longer a synchronous ordering guarantee. On PREEMPT_RT, where
cgroup_task_dead() is further deferred through lazy irq_work, the race
window is even larger.

The synchronous populated transition was never part of the cgroup interface
contract - it was an implementation artifact. Use cg_read_strcmp_wait() which
retries for up to 1 second, matching what these tests actually need to
verify: that the cgroup eventually becomes unpopulated after all tasks exit.

Fixes: d245698d727a ("cgroup: Defer task cgroup unlink until after the task is done switching out")
Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Tejun Heo <tj@kernel.org>
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Christian Brauner <brauner@kernel.org>
Cc: cgroups@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/lib/cgroup_util.c  | 15 +++++++++++++++
 .../selftests/cgroup/lib/include/cgroup_util.h    |  2 ++
 tools/testing/selftests/cgroup/test_core.c        |  3 ++-
 tools/testing/selftests/cgroup/test_kill.c        |  7 ++++---
 4 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/cgroup/lib/cgroup_util.c b/tools/testing/selftests/cgroup/lib/cgroup_util.c
index 44c52f620fda1..4b0f2c46d4322 100644
--- a/tools/testing/selftests/cgroup/lib/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/lib/cgroup_util.c
@@ -123,6 +123,21 @@ int cg_read_strcmp(const char *cgroup, const char *control,
 	return ret;
 }
 
+int cg_read_strcmp_wait(const char *cgroup, const char *control,
+			    const char *expected)
+{
+	int i, ret;
+
+	for (i = 0; i < 100; i++) {
+		ret = cg_read_strcmp(cgroup, control, expected);
+		if (!ret)
+			return ret;
+		usleep(10000);
+	}
+
+	return ret;
+}
+
 int cg_read_strstr(const char *cgroup, const char *control, const char *needle)
 {
 	char buf[PAGE_SIZE];
diff --git a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
index 7ab2824ed7b54..1cbe3b0ac6f73 100644
--- a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
+++ b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
@@ -59,6 +59,8 @@ extern int cg_read(const char *cgroup, const char *control,
 		   char *buf, size_t len);
 extern int cg_read_strcmp(const char *cgroup, const char *control,
 			  const char *expected);
+extern int cg_read_strcmp_wait(const char *cgroup, const char *control,
+				   const char *expected);
 extern int cg_read_strstr(const char *cgroup, const char *control,
 			  const char *needle);
 extern long cg_read_long(const char *cgroup, const char *control);
diff --git a/tools/testing/selftests/cgroup/test_core.c b/tools/testing/selftests/cgroup/test_core.c
index 102262555a599..7b83c7e7c9d4f 100644
--- a/tools/testing/selftests/cgroup/test_core.c
+++ b/tools/testing/selftests/cgroup/test_core.c
@@ -233,7 +233,8 @@ static int test_cgcore_populated(const char *root)
 	if (err)
 		goto cleanup;
 
-	if (cg_read_strcmp(cg_test_d, "cgroup.events", "populated 0\n"))
+	if (cg_read_strcmp_wait(cg_test_d, "cgroup.events",
+				   "populated 0\n"))
 		goto cleanup;
 
 	/* Remove cgroup. */
diff --git a/tools/testing/selftests/cgroup/test_kill.c b/tools/testing/selftests/cgroup/test_kill.c
index c8c9d306925b6..f6cd23a8ecc71 100644
--- a/tools/testing/selftests/cgroup/test_kill.c
+++ b/tools/testing/selftests/cgroup/test_kill.c
@@ -86,7 +86,7 @@ static int test_cgkill_simple(const char *root)
 		wait_for_pid(pids[i]);
 
 	if (ret == KSFT_PASS &&
-	    cg_read_strcmp(cgroup, "cgroup.events", "populated 0\n"))
+	    cg_read_strcmp_wait(cgroup, "cgroup.events", "populated 0\n"))
 		ret = KSFT_FAIL;
 
 	if (cgroup)
@@ -190,7 +190,8 @@ static int test_cgkill_tree(const char *root)
 		wait_for_pid(pids[i]);
 
 	if (ret == KSFT_PASS &&
-	    cg_read_strcmp(cgroup[0], "cgroup.events", "populated 0\n"))
+	    cg_read_strcmp_wait(cgroup[0], "cgroup.events",
+				   "populated 0\n"))
 		ret = KSFT_FAIL;
 
 	for (i = 9; i >= 0 && cgroup[i]; i--) {
@@ -251,7 +252,7 @@ static int test_cgkill_forkbomb(const char *root)
 		wait_for_pid(pid);
 
 	if (ret == KSFT_PASS &&
-	    cg_read_strcmp(cgroup, "cgroup.events", "populated 0\n"))
+	    cg_read_strcmp_wait(cgroup, "cgroup.events", "populated 0\n"))
 		ret = KSFT_FAIL;
 
 	if (cgroup)
-- 
2.53.0



