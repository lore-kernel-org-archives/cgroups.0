From: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH AUTOSEL 5.10 05/16] cgroup: Remove data-race around cgrp_dfl_visible
Date: Mon, 17 Oct 2022 20:10:18 -0400
Message-ID: <20221018001029.2731620-5-sashal@kernel.org>
References: <20221018001029.2731620-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051839;
        bh=pi8pLsYW4g0+QIgNtoUdgUCpe0BC5kGnIcEdILtWFCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dc92d1ac9j9u7r+OmjaAvRO46WjcIArVGC84qt4VOXfO6HWg3CTF1ikMWxVL8QJG1
         97anq76AAQ7bPwGvxgsSBJ6w1bJFt4rJbRBjMz8E5nCLhs1QYchyxwTLQavXF9pe0b
         +0mxFza//hrj4n65mp5tG/1JsARRkpwhGUeiQarAybKYCR3Vzrry101FmsjmENHHax
         pwJBknN5edV7PyR9gCaTqelkgelKENujG1uZEZyTZhb+TKDINjqwAGy1lKiOxSgW1l
         +e7dS0AyajPkLVas/en7u1p3YOBCTANwyQwrQpg2sDUQMPoZfmzl05PCidlgALOBhL
         luDUfLkU7Hl4A==
In-Reply-To: <20221018001029.2731620-1-sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Abhishek Shah <abhishek.shah-WLbs8XpHrcb2fBVCVOL8/A@public.gmane.org>, Gabriel Ryan <gabe-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

[ Upstream commit dc79ec1b232ad2c165d381d3dd2626df4ef9b5a4 ]

There's a seemingly harmless data-race around cgrp_dfl_visible detected by
kernel concurrency sanitizer. Let's remove it by throwing WRITE/READ_ONCE at
it.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reported-by: Abhishek Shah <abhishek.shah-WLbs8XpHrcb2fBVCVOL8/A@public.gmane.org>
Cc: Gabriel Ryan <gabe-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Reviewed-by: Christian Brauner (Microsoft) <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Link: https://lore.kernel.org/netdev/20220819072256.fn7ctciefy4fc4cu@wittgenstein/
Signed-off-by: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 684c16849eff..5178593ee1f1 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2110,7 +2110,7 @@ static int cgroup_get_tree(struct fs_context *fc)
 	struct cgroup_fs_context *ctx = cgroup_fc2context(fc);
 	int ret;
 
-	cgrp_dfl_visible = true;
+	WRITE_ONCE(cgrp_dfl_visible, true);
 	cgroup_get_live(&cgrp_dfl_root.cgrp);
 	ctx->root = &cgrp_dfl_root;
 
@@ -5946,7 +5946,7 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 		struct cgroup *cgrp;
 		int ssid, count = 0;
 
-		if (root == &cgrp_dfl_root && !cgrp_dfl_visible)
+		if (root == &cgrp_dfl_root && !READ_ONCE(cgrp_dfl_visible))
 			continue;
 
 		seq_printf(m, "%d:", root->hierarchy_id);
-- 
2.35.1

