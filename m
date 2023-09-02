From: Tejun Heo <tj@kernel.org>
Subject: [PATCH cgroup/for-6.6-fixes] cgroup: Put cgroup_local_stat_show()
 inside CONFIG_CGROUP_SCHED
Date: Sat, 2 Sep 2023 05:42:50 -1000
Message-ID: <ZPNX-jZAZbebizXA@slm.duckdns.org>
References: <ZPMdTJ7zwrCkdMTu@debian>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693669373; x=1694274173; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6SQfYFAS0iiVi0orcSaVcos5wFLJxvemd/2Ha3R3PtM=;
        b=g68w/pSDRFvZIkLd+b5CqkL3pvlZnFKG1mpjkSF7JwC4z9P03ASSMkLyobfqDRMd6J
         uw30zS9vzquH6tTEWaXkHRsKSGwBkocXDhw2eBP7xql1wZqtBItfTmT79sa+SQJMbwcm
         lq9/We9hS7aYsDM12AVvs/+Wkvqx/wk0QkANye2WIHs7wbHIPO615jTkNjUehp0OokGB
         vLo+YqtgL9PqiTBOBLYZdg3kgkGan0oZL0Z8UHCe0skGw4FNuB/Lq6PP8cF8slZ/sPst
         W20IfMfMM8/pg2tDG6HZsjcZ6dxERXpmFLIqLkU5FZTCwP85x0z3E/ilyR8ehM30abCc
         gHlw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <ZPMdTJ7zwrCkdMTu@debian>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, regressions@lists.linux.dev

From d8416c5d2a38e36651f022be01bb234a404b8f01 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Sat, 2 Sep 2023 05:28:06 -1000

677ea015f231 ("sched: add throttled time stat for throttled children") which
was merged through the sched branch added cgroup_local_stat_show() which is
marked with __maybe_unused and used iff CONFIG_CGROUP_SCHED is set. This was
following the existing pattern of cgroup_extra_stat_show().

However, in the cgroup tree, 1299eb2b0ad5 ("cgroup: minor cleanup for
cgroup_extra_stat_show()") moved cgroup_extra_stat_show() inside
CONFIG_CGROUP_SCHED and dropped __maybe_unused and subsequently d1d4ff5d11a5
("cgroup: put cgroup_tryget_css() inside CONFIG_CGROUP_SCHED") moved
cgroup_tryget_css() inside the config option too as cgroup_extra_stat_show()
was the only user.

When the tree commits met in mainline, this led to a build breakage when
!CONFIG_CGROUP_SCHED as cgroup_tryget_css() was no longer available for the
__maybe_unused cgroup_local_stat_show().

Fix it by moving cgroup_local_stat_show() inside CONFIG_CGROUP_SCHED and
also drop __maybe_unused.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
Link: http://lkml.kernel.org/r/ZPMdTJ7zwrCkdMTu@debian
Fixes: 677ea015f231 ("sched: add throttled time stat for throttled children")
Cc: Josh Don <joshdon@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
---
Sorry about that. This should fix it. Guess nobody is building linux-next w/
!CONFIG_CGROUP_SCHED. I'll send the pull request to Linus soon.

Thanks.

 kernel/cgroup/cgroup.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index babb34a643ea..156eb96d7cc5 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3686,8 +3686,9 @@ static int cpu_stat_show(struct seq_file *seq, void *v)
 	return ret;
 }
 
-static int __maybe_unused cgroup_local_stat_show(struct seq_file *seq,
-						 struct cgroup *cgrp, int ssid)
+#ifdef CONFIG_CGROUP_SCHED
+static int cgroup_local_stat_show(struct seq_file *seq, struct cgroup *cgrp,
+				  int ssid)
 {
 	struct cgroup_subsys *ss = cgroup_subsys[ssid];
 	struct cgroup_subsys_state *css;
@@ -3704,6 +3705,7 @@ static int __maybe_unused cgroup_local_stat_show(struct seq_file *seq,
 	css_put(css);
 	return ret;
 }
+#endif
 
 static int cpu_local_stat_show(struct seq_file *seq, void *v)
 {
-- 
2.42.0

