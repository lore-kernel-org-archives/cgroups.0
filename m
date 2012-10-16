From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] oom, memcg: handle sysctl oom_kill_allocating_task while memcg oom happening
Date: Tue, 16 Oct 2012 18:12:08 +0800
Message-ID: <1350382328-28977-1-git-send-email-handai.szj@taobao.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=GHLB8klPPOWpjeK2oSOjYbVy9ePFeuoRG9oKBZEQLA8=;
        b=LUd7ebOHQFWmCOHudT/YvFfpxm/jvUY+N7i4nKvyoHghOBxCbLRoVf3l5NhCxim2em
         LU2i8fYBzoNnlxFQDCBI2+VoZNe5AkAIgHz9WmrdokS73CeveGmDDRhXYJfN4Jv6uDr9
         fuT5taoHkKSMZXPkmkJNKzx8oJKPbc/93GOlw6huVOwsDAWu6vIfdAquk4H2XpzdfgVz
         lu08EbmuYv9Anf+pVltxoh9RzTk+Kfk4bWQSZb54tN45yX7/KcqZn0rmXhmC3EV1wxJN
         mrAwXaGlZmchZh8nq+rPSEhh75ywNWql3pb1UFrulVFS73aboidsWpXOkbJH2NL6ZQpt
         5swQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

Sysctl oom_kill_allocating_task enables or disables killing the OOM-triggering
task in out-of-memory situations, but it only works on overall system-wide oom.
But it's also a useful indication in memcg so we take it into consideration
while oom happening in memcg. Other sysctl such as panic_on_oom has already
been memcg-ware.


Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e4e9b18..c329940 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1486,6 +1486,15 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
 	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL);
 	totalpages = mem_cgroup_get_limit(memcg) >> PAGE_SHIFT ? : 1;
+	if (sysctl_oom_kill_allocating_task && current->mm &&
+	    !oom_unkillable_task(current, memcg, NULL) &&
+	    current->signal->oom_score_adj != OOM_SCORE_ADJ_MIN) {
+		get_task_struct(current);
+		oom_kill_process(current, gfp_mask, order, 0, totalpages, memcg, NULL,
+				 "Memory cgroup out of memory (oom_kill_allocating_task)");
+		return;
+	}
+
 	for_each_mem_cgroup_tree(iter, memcg) {
 		struct cgroup *cgroup = iter->css.cgroup;
 		struct cgroup_iter it;
-- 
1.7.6.1
