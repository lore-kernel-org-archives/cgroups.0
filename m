From: Tejun Heo <tj@kernel.org>
Subject: [PATCH cgroup/for-6.1] cgroup: Remove data-race around
 cgrp_dfl_visible
Date: Sun, 4 Sep 2022 09:23:32 -1000
Message-ID: <YxT7NASKiuZDx6PT@slm.duckdns.org>
References: <CAEHB249jcoG=sMGLUgqw3Yf+SjZ7ZkUfF_M+WcyQGCAe77o2kA@mail.gmail.com>
 <20220819072256.fn7ctciefy4fc4cu@wittgenstein>
 <CALbthtdFY+GHTzGH9OujzqpOtWZAqsU3MAsjv5OpwZUW6gVa7A@mail.gmail.com>
 <YwuySgH4j6h2CGvk@slm.duckdns.org>
 <20220829072741.tsxfgjp75lywzlgn@wittgenstein>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=t1xTYA4sjuGCh4pw3N6/8X8I4YHHyXAx3KGLnNc3nds=;
        b=JuQdFQznN6fig6R2GT4wFv4boLIPrh52pkOjt7Lk8nwSgI65990K1hikW1+UWssukE
         hkoBhQ15kid+XL/9WfgKqmYdxnNhivT42x0Favs9JqSVfbZk7KM6V/nvm87u8L5ENJxK
         sUnBMp3KajXtvWlKqVkJ2nmon4lFv5WpkK7pP63O25Cz9I3Lhra7fp0atBGfasq85YMU
         0piwSM/rdcd/050P3aavp1ybATVo4tInhsgWKqxmQjpQ02QhR1ya7lZCMid3kzVbxR0H
         j6RZa8ATgc8gnLynqW/GwbdGRJVzFBafXFM12/beAvTFdWSb/jM8PqtVC1QNo4dxT1YA
         tMQg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220829072741.tsxfgjp75lywzlgn@wittgenstein>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <brauner@kernel.org>
Cc: Gabriel Ryan <gabe@cs.columbia.edu>, Abhishek Shah <abhishek.shah@columbia.edu>, linux-kernel@vger.kernel.org, andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, daniel@iogearbox.net, hannes@cmpxchg.org, john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org, lizefan.x@bytedance.com, netdev@vger.kernel.org, songliubraving@fb.com, yhs@fb.com

From dc79ec1b232ad2c165d381d3dd2626df4ef9b5a4 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Sun, 4 Sep 2022 09:16:19 -1000

There's a seemingly harmless data-race around cgrp_dfl_visible detected by
kernel concurrency sanitizer. Let's remove it by throwing WRITE/READ_ONCE at
it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Abhishek Shah <abhishek.shah@columbia.edu>
Cc: Gabriel Ryan <gabe@cs.columbia.edu>
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Link: https://lore.kernel.org/netdev/20220819072256.fn7ctciefy4fc4cu@wittgenstein/
---
Applied to cgroup/for-6.1.

Thanks.

 kernel/cgroup/cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 0005de2e2ed9..e0b72eb5d283 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2173,7 +2173,7 @@ static int cgroup_get_tree(struct fs_context *fc)
 	struct cgroup_fs_context *ctx = cgroup_fc2context(fc);
 	int ret;
 
-	cgrp_dfl_visible = true;
+	WRITE_ONCE(cgrp_dfl_visible, true);
 	cgroup_get_live(&cgrp_dfl_root.cgrp);
 	ctx->root = &cgrp_dfl_root;
 
@@ -6098,7 +6098,7 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 		struct cgroup *cgrp;
 		int ssid, count = 0;
 
-		if (root == &cgrp_dfl_root && !cgrp_dfl_visible)
+		if (root == &cgrp_dfl_root && !READ_ONCE(cgrp_dfl_visible))
 			continue;
 
 		seq_printf(m, "%d:", root->hierarchy_id);
-- 
2.37.3

