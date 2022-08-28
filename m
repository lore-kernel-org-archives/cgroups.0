From: Tejun Heo <tj@kernel.org>
Subject: Re: data-race in cgroup_get_tree / proc_cgroup_show
Date: Sun, 28 Aug 2022 08:22:02 -1000
Message-ID: <YwuySgH4j6h2CGvk@slm.duckdns.org>
References: <CAEHB249jcoG=sMGLUgqw3Yf+SjZ7ZkUfF_M+WcyQGCAe77o2kA@mail.gmail.com>
 <20220819072256.fn7ctciefy4fc4cu@wittgenstein>
 <CALbthtdFY+GHTzGH9OujzqpOtWZAqsU3MAsjv5OpwZUW6gVa7A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=fDxt/23RMfjSPySyD961NLt4VpOweqOjLnL5SIVCHSw=;
        b=bYRe2XZSiSci2LOHFk4x2DL4UfLXQoCGgCBD1X+W6bzYL4E1x6f+eLhYmIXp7q53rW
         Uo4HLItQM5SCdwRKOFo/PKO99zk0ev1GsMB4n8AfLYQjMlsPBBchv0gViHGlRajCZW+K
         cA9OvTZId4uB8YFICMpI/1EkiEyyzvHs0SZdjd0LBmU+XWTWtTyb/6/HhwPbnmqlIRss
         kEbrFVTf+Jr0SVAsukYkqK/AOqGbxpalP10Wr6ELwkCpjLKMc4yVLcoMTZQnZfCCmuvf
         oP/IvdKyf+e3fgFbFTmyrw1IHO3wI6pgK1/WjAkAppW869soncCXuBC+5JdGn0xcr0Ni
         udyQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <CALbthtdFY+GHTzGH9OujzqpOtWZAqsU3MAsjv5OpwZUW6gVa7A@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gabriel Ryan <gabe@cs.columbia.edu>
Cc: Christian Brauner <brauner@kernel.org>, Abhishek Shah <abhishek.shah@columbia.edu>, linux-kernel@vger.kernel.org, andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, daniel@iogearbox.net, hannes@cmpxchg.org, john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org, lizefan.x@bytedance.com, netdev@vger.kernel.org, songliubraving@fb.com, yhs@fb.com

On Mon, Aug 22, 2022 at 01:04:58PM -0400, Gabriel Ryan wrote:
> Hi Christian,
> 
> We ran a quick test and confirm your suggestion would eliminate the
> data race alert we observed. If the data race is benign (and it
> appears to be), using WRITE_ONCE(cgrp_dfl_visible, true) instead of
> cmpxchg in cgroup_get_tree() would probably also be ok.

I don't see how the data race can lead to anything but would the following
work?

Thanks.

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index ffaccd6373f1e..a90fdba881bdb 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2172,7 +2172,7 @@ static int cgroup_get_tree(struct fs_context *fc)
 	struct cgroup_fs_context *ctx = cgroup_fc2context(fc);
 	int ret;
 
-	cgrp_dfl_visible = true;
+	WRITE_ONCE(cgrp_dfl_visible, true);
 	cgroup_get_live(&cgrp_dfl_root.cgrp);
 	ctx->root = &cgrp_dfl_root;
 
@@ -6056,7 +6056,7 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 		struct cgroup *cgrp;
 		int ssid, count = 0;
 
-		if (root == &cgrp_dfl_root && !cgrp_dfl_visible)
+		if (root == &cgrp_dfl_root && !READ_ONCE(cgrp_dfl_visible))
 			continue;
 
 		seq_printf(m, "%d:", root->hierarchy_id);


-- 
tejun
