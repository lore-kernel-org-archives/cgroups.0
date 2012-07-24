From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] memcg, oom: Clarify some oom dump messages
Date: Wed, 25 Jul 2012 00:12:14 +0800
Message-ID: <1343146334-15161-1-git-send-email-handai.szj@taobao.com>
References: <1343146160-15012-1-git-send-email-handai.szj@taobao.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=t6KSyZQuZTdrYRvRqPiEItzqu7i/K4voxDZKR6Mg7uQ=;
        b=iMjU8fXhqPK48TAssSDVqMcAtESgC65BDt75lHqxWVvyG6n6PZ1vAYnUV2dIhQl756
         ww8jnZyTGEAhTGlxM8wtSBz5iL6h0oiAVZlnS3pRnRVMh5wBaZ9LnHgHHGv1rXeSwSbA
         2MmqT70bEUIys4ArE5iIvAZdCBIR4R5OElQy5Rk5e750qdXPA6FJjBxgJs60D6V4HKOz
         QB8R3rBhs1f+zz1/UhJoXuPZ1K1sElSN51wsLxsDS5MNeYSiH6HYvDCMga+E/QUDzwDA
         PgwjmBSeIvTtsOh+5dxvXOf/MHgq5kwZ1unjjFs5LbtU9WU9RGqEUMYs8R8eEjBKlfwd
         7FKg==
In-Reply-To: <1343146160-15012-1-git-send-email-handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

Revise some oom dump messages to avoid misleading admin.

Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Cc: kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: mhocko-AlSwsSmVLrQ@public.gmane.org
Cc: gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
---
 mm/memcontrol.c |    2 +-
 mm/oom_kill.c   |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a3037af..7ce605c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1472,7 +1472,7 @@ void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
 	}
 	rcu_read_unlock();
 
-	printk(KERN_INFO "Task in %s killed", memcg_name);
+	printk(KERN_INFO "Task in %s will be killed", memcg_name);
 
 	rcu_read_lock();
 	ret = cgroup_path(mem_cgrp, memcg_name, PATH_MAX);
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index b47ed97..3fc9f99 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -471,7 +471,7 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 		dump_header(p, gfp_mask, order, memcg, nodemask);
 
 	task_lock(p);
-	pr_err("%s: Kill process %d (%s) score %d or sacrifice child\n",
+	pr_err("%s: Will kill process %d (%s) score %d or sacrifice child\n",
 		message, task_pid_nr(p), p->comm, points);
 	task_unlock(p);
 
@@ -508,6 +508,7 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 	if (!p) {
 		rcu_read_unlock();
 		put_task_struct(victim);
+		pr_err("No process has been killed!\n");
 		return;
 	} else if (victim != p) {
 		get_task_struct(p);
@@ -539,7 +540,7 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 				continue;
 
 			task_lock(p);	/* Protect ->comm from prctl() */
-			pr_err("Kill process %d (%s) sharing same memory\n",
+			pr_err("Killed process %d (%s) sharing same memory\n",
 				task_pid_nr(p), p->comm);
 			task_unlock(p);
 			do_send_sig_info(SIGKILL, SEND_SIG_FORCED, p, true);
-- 
1.7.1
