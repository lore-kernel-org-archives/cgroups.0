From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.15 05/21] cgroup: Remove data-race around cgrp_dfl_visible
Date: Mon, 17 Oct 2022 20:09:24 -0400
Message-ID: <20221018000940.2731329-5-sashal@kernel.org>
References: <20221018000940.2731329-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051790;
        bh=oN6JrRW7HxtTEZenVxRVgLqm+0Dic4qTguzq3ewBC+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JlZEQPHU5Eojtsq7OcZ0RwYgIU2i7qnwmxiI5X0h/Tl3nHOHyxilbBRgSFlsdBavl
         1Np37eMg0yuP+Mzh+Ll9n6vxKBtkkscMo+fDZJTfUEiaxx89eNooHHSv7nFA3ybGjg
         qbU79cKBbb5imKEzRjLJWjh6B4J/BFLoAkDYlMjQGlVe1Ojz68rQ3+wdnHRVPshd3/
         RLDmV7TwaCV1SOmB8wJ3rISQYlVAJrUorWSl6HWD1wZLPHX/Kc7O0Ie7Aes+gac+Rc
         u7IWmrUcxfvqRzyAiIn6EEhNC/CbKNAYdbTKI96ggnPzDCcRzpnUcEjCpVvITNYiqP
         en0rxB+NMInpA==
In-Reply-To: <20221018000940.2731329-1-sashal@kernel.org>
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
index 4b19f7fc4deb..1dd45a1c1acc 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2152,7 +2152,7 @@ static int cgroup_get_tree(struct fs_context *fc)
 	struct cgroup_fs_context *ctx = cgroup_fc2context(fc);
 	int ret;
 
-	cgrp_dfl_visible = true;
+	WRITE_ONCE(cgrp_dfl_visible, true);
 	cgroup_get_live(&cgrp_dfl_root.cgrp);
 	ctx->root = &cgrp_dfl_root;
 
@@ -6067,7 +6067,7 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 		struct cgroup *cgrp;
 		int ssid, count = 0;
 
-		if (root == &cgrp_dfl_root && !cgrp_dfl_visible)
+		if (root == &cgrp_dfl_root && !READ_ONCE(cgrp_dfl_visible))
 			continue;
 
 		seq_printf(m, "%d:", root->hierarchy_id);
-- 
2.35.1

