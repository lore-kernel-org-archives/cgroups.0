From: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] memcg: remove extra newlines from memcg oom kill log
Date: Mon, 12 Jan 2015 22:45:39 -0800
Message-ID: <1421131539-3211-1-git-send-email-gthelen@google.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=KQ1Dk0LyKR9P72SJtY/2LD5dWWFo+z0x7c/Ox/SbQkA=;
        b=pW983NOYoCYuPWRcKpX4HUYECjHJF07P/A9C2jNLDgOxz7DZmbGmnHDhN9+dvD1oUI
         2LTpg6TNHk13jcZbOgqNFk1Pde4jFCzYELrpLN3E+iAW/kZQ80GSz1HoPHydzBMUTtO5
         yYQaXJleWH+JpC0X8MSXmTAr3jpDzsuqnMlyNUgJv+y32StGXE88fbV1/Hxc5x8+B+r5
         ktwp4HYdzYak0j6EGvfh1ILPDdxJnkf2uPELiSts1lL2h1NnNH8h68R0s0ArYj3QeV99
         daDOQB0LeY6n7UUuQP+h9xL2sFNzClVIPejH2ZKkxeflfCJx7QjpAZPFK25Dx+WEYCPX
         kSGA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Commit e61734c55c24 ("cgroup: remove cgroup->name") added two extra
newlines to memcg oom kill log messages.  This makes dmesg hard to read
and parse.  The issue affects 3.15+.
Example:
  Task in /t                          <<< extra #1
   killed as a result of limit of /t
                                      <<< extra #2
  memory: usage 102400kB, limit 102400kB, failcnt 274712

Remove the extra newlines from memcg oom kill messages, so the messages
look like:
  Task in /t killed as a result of limit of /t
  memory: usage 102400kB, limit 102400kB, failcnt 240649

Fixes: e61734c55c24 ("cgroup: remove cgroup->name")
Signed-off-by: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 851924fa5170..683b4782019b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1477,9 +1477,9 @@ void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
 
 	pr_info("Task in ");
 	pr_cont_cgroup_path(task_cgroup(p, memory_cgrp_id));
-	pr_info(" killed as a result of limit of ");
+	pr_cont(" killed as a result of limit of ");
 	pr_cont_cgroup_path(memcg->css.cgroup);
-	pr_info("\n");
+	pr_cont("\n");
 
 	rcu_read_unlock();
 
-- 
2.2.0.rc0.207.ga3a616c
