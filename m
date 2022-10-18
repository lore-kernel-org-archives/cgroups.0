From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.19 06/29] cgroup: Remove data-race around cgrp_dfl_visible
Date: Mon, 17 Oct 2022 20:08:15 -0400
Message-ID: <20221018000839.2730954-6-sashal@kernel.org>
References: <20221018000839.2730954-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051733;
        bh=suO48gKpN6vaGn7ollF2e/6WDrLDFaf4THUYc859unw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QqgdIlEgEM/1Q/NVPPtquNcTAiFNkVR91/uFuO9+nIkHWAdmAayxlrKEB2LOUnnxl
         HkcskpR0nHypMjdIPw5sHaUxGzBUt8Gz9k25Po7MlLsCJEZlfQT1zz2mv11u8yUxRG
         nihI403tJ7uUl6UfKHTaQ6PtZCGWB99zOwhfqFGDnkNLENyhOYXiNE6kA68mlohUtd
         Gd7Zz1eF6E9jRWc3Do5lQP2SIqO9jTKrIN6HDTSsh5hXr3AdloEXA9dWLj25vxkGIy
         UZhEpjg+ZkPyY53+znd3X2JN8nwD8usmw//aCHe2qzYQa2ISpPRwgcAJ3qlgJWs4ad
         wkwPAFoXP2TyQ==
In-Reply-To: <20221018000839.2730954-1-sashal@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Abhishek Shah <abhishek.shah@columbia.edu>, Gabriel Ryan <gabe@cs.columbia.edu>, Christian Brauner <brauner@kernel.org>, Sasha Levin <sashal@kernel.org>, lizefan.x@bytedance.com, hannes@cmpxchg.org, cgroups@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

[ Upstream commit dc79ec1b232ad2c165d381d3dd2626df4ef9b5a4 ]

There's a seemingly harmless data-race around cgrp_dfl_visible detected by
kernel concurrency sanitizer. Let's remove it by throwing WRITE/READ_ONCE at
it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Abhishek Shah <abhishek.shah@columbia.edu>
Cc: Gabriel Ryan <gabe@cs.columbia.edu>
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Link: https://lore.kernel.org/netdev/20220819072256.fn7ctciefy4fc4cu@wittgenstein/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 80c23f48f3b4..1969ba9b4090 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2153,7 +2153,7 @@ static int cgroup_get_tree(struct fs_context *fc)
 	struct cgroup_fs_context *ctx = cgroup_fc2context(fc);
 	int ret;
 
-	cgrp_dfl_visible = true;
+	WRITE_ONCE(cgrp_dfl_visible, true);
 	cgroup_get_live(&cgrp_dfl_root.cgrp);
 	ctx->root = &cgrp_dfl_root;
 
@@ -6068,7 +6068,7 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 		struct cgroup *cgrp;
 		int ssid, count = 0;
 
-		if (root == &cgrp_dfl_root && !cgrp_dfl_visible)
+		if (root == &cgrp_dfl_root && !READ_ONCE(cgrp_dfl_visible))
 			continue;
 
 		seq_printf(m, "%d:", root->hierarchy_id);
-- 
2.35.1

