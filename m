From: Roman Gushchin <guro@fb.com>
Subject: [PATCH 1/2] kselftests: cgroup: add freezer mkdir test
Date: Thu, 12 Sep 2019 10:56:44 -0700
Message-ID: <20190912175645.2841713-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=DiB/JXN9MiGhOXyaA1IgQrfA2ly3wM/1C1ucZaXosR4=;
 b=JKSb3CP/Bw2i+foP7KE87GSWZtaROeAwj6jVHNNFz5ljU0B2UHXJxUw9TPdGYLYn8qAu
 vIEt07HcijFyxWE2JHVjnfk0Z1Q9C8rGLDw19E4NFW1n7LyuE1q50IU877LRL0KPG4Wq
 +UFr3dnVSuKD4fB6gcU6WMsgxQ7fhDAvpNg= 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-team@fb.com, Mark Crossen <mcrossen@fb.com>, Roman Gushchin <guro@fb.com>, Shuah Khan <shuah@kernel.org>

Add a new cgroup freezer selftest, which checks that if a cgroup is
frozen, their new child cgroups will properly inherit the frozen
state.

It creates a parent cgroup, freezes it, creates a child cgroup
and populates it with a dummy process. Then it checks that both
parent and child cgroup are frozen.

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
---
 tools/testing/selftests/cgroup/test_freezer.c | 54 +++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_freezer.c b/tools/testing/selftests/cgroup/test_freezer.c
index 8219a30853d2..0fc1b6d4b0f9 100644
--- a/tools/testing/selftests/cgroup/test_freezer.c
+++ b/tools/testing/selftests/cgroup/test_freezer.c
@@ -447,6 +447,59 @@ static int test_cgfreezer_forkbomb(const char *root)
 	return ret;
 }
 
+/*
+ * The test creates a cgroups and freezes it. Then it creates a child cgroup
+ * and populates it with a task. After that it checks that the child cgroup
+ * is frozen and the parent cgroup remains frozen too.
+ */
+static int test_cgfreezer_mkdir(const char *root)
+{
+	int ret = KSFT_FAIL;
+	char *parent, *child = NULL;
+	int pid;
+
+	parent = cg_name(root, "cg_test_mkdir_A");
+	if (!parent)
+		goto cleanup;
+
+	child = cg_name(parent, "cg_test_mkdir_B");
+	if (!child)
+		goto cleanup;
+
+	if (cg_create(parent))
+		goto cleanup;
+
+	if (cg_freeze_wait(parent, true))
+		goto cleanup;
+
+	if (cg_create(child))
+		goto cleanup;
+
+	pid = cg_run_nowait(child, child_fn, NULL);
+	if (pid < 0)
+		goto cleanup;
+
+	if (cg_wait_for_proc_count(child, 1))
+		goto cleanup;
+
+	if (cg_check_frozen(child, true))
+		goto cleanup;
+
+	if (cg_check_frozen(parent, true))
+		goto cleanup;
+
+	ret = KSFT_PASS;
+
+cleanup:
+	if (child)
+		cg_destroy(child);
+	free(child);
+	if (parent)
+		cg_destroy(parent);
+	free(parent);
+	return ret;
+}
+
 /*
  * The test creates two nested cgroups, freezes the parent
  * and removes the child. Then it checks that the parent cgroup
@@ -815,6 +868,7 @@ struct cgfreezer_test {
 	T(test_cgfreezer_simple),
 	T(test_cgfreezer_tree),
 	T(test_cgfreezer_forkbomb),
+	T(test_cgfreezer_mkdir),
 	T(test_cgfreezer_rmdir),
 	T(test_cgfreezer_migrate),
 	T(test_cgfreezer_ptrace),
-- 
2.21.0

