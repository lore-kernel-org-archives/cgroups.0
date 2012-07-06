From: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] mm/memcg: mem_cgroup_resize_xxx_limit can guarantee memcg->res.limit <= memcg->memsw.limit
Date: Fri,  6 Jul 2012 11:24:15 +0800
Message-ID: <1341545055-5830-1-git-send-email-liwp.linux@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=r04RqSlgWX97CJFkBgtRPr06dCtpWXxydAZZTIDn7kI=;
        b=foj+ysW6m+yqh/BqCfM72ei5hcE3SnRjeq+XnzWbTotn5iwX8d/3NsH56k1wb4oHVN
         7oV5/bRub075Od42IfrePg3ftbRco/UKnBrhNBdBX9kdAT1q5o7iyp9voPU3CI9ZzL+x
         WmQnhNtggjrTrmrOG/zh0Hh289l6+jyjuX4A8vjLLMCZ1QpNeZbQAP+UvInEYgvZ2a3d
         U86RrT9Lwur/4WK0/aXKu5A7NVyGGlaOi7ZAiVhF0k7PnHO64yBAUjXQnCFnmhzWhrKo
         bhEfW5qztabkUTP9jjS0zFHOVcqUczEW8olCcEyNPyZbYEfcYO0SUyqRdI85Pixc6koo
         sP0Q==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Changlog:

V2:
* correct title 

Signed-off-by: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4b64fe0..a501660 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3418,7 +3418,7 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
 		/*
 		 * Rather than hide all in some function, I do this in
 		 * open coded manner. You see what this really does.
-		 * We have to guarantee memcg->res.limit < memcg->memsw.limit.
+		 * We have to guarantee memcg->res.limit <= memcg->memsw.limit.
 		 */
 		mutex_lock(&set_limit_mutex);
 		memswlimit = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
@@ -3479,7 +3479,7 @@ static int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
 		/*
 		 * Rather than hide all in some function, I do this in
 		 * open coded manner. You see what this really does.
-		 * We have to guarantee memcg->res.limit < memcg->memsw.limit.
+		 * We have to guarantee memcg->res.limit <= memcg->memsw.limit.
 		 */
 		mutex_lock(&set_limit_mutex);
 		memlimit = res_counter_read_u64(&memcg->res, RES_LIMIT);
-- 
1.7.5.4
