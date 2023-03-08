From: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3, 1/4] mm, memcg: Prevent memory.oom.group load/store tearing
Date: Thu,  9 Mar 2023 00:25:52 +0800
Message-ID: <20230308162555.14195-2-findns94@gmail.com>
References: <20230308162555.14195-1-findns94@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678292775;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dSGH6XW8GGWy2Vlt5EOF3HzragLrWkAt6Pl6/u4DucU=;
        b=En9ZXMIVUd6NZpo/Upabpi/wUSCx0yExcRdNjF/axSruKy2K9v6CA7OeDMP3a/ru9n
         pL9y2zjezsuviNzL0E6V/HZCzlzqC90vqu7LGfuG08q9vH1O0eE411zH8qUX+D/gtGE0
         tSEiT6I5xfRcgCFgsfPzksV+nRLOqFCHPY18ucVNS++GJg2xfxfkOXzCC8d+b+09OF/Z
         bS8fbe+mIauuqeZpC97vkqdt7Y0sqyo3ZSskkmZzZFmjxZnk5N7M41AqEXZdXVK+A1gx
         eHODoCOX9g9owrKSLb6HJPHJjDy1UznEl8NXE104v6PUHJ0AFQeyPIAg3F36YfKq2Oqd
         Snpw==
In-Reply-To: <20230308162555.14195-1-findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tangyeechou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

The knob for cgroup v2 memory controller: memory.oom.group
is not protected by any locking so it can be modified while it is used.
This is not an actual problem because races are unlikely (the knob is
usually configured long before any workloads hits actual memcg oom)
but it is better to use [READ|WRITE]_ONCE to prevent compiler from
doing anything funky.

The access of memcg->oom_group is lockless, so it can be
concurrently set at the same time as we are trying to read it.
All occurrences of memcg->oom_group are updated with [READ|WRITE]_ONCE.

Signed-off-by: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5abffe6f8389..06821e5f7604 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2067,7 +2067,7 @@ struct mem_cgroup *mem_cgroup_get_oom_group(struct task_struct *victim,
 	 * highest-level memory cgroup with oom.group set.
 	 */
 	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
-		if (memcg->oom_group)
+		if (READ_ONCE(memcg->oom_group))
 			oom_group = memcg;
 
 		if (memcg == oom_domain)
@@ -6623,7 +6623,7 @@ static int memory_oom_group_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	seq_printf(m, "%d\n", memcg->oom_group);
+	seq_printf(m, "%d\n", READ_ONCE(memcg->oom_group));
 
 	return 0;
 }
@@ -6645,7 +6645,7 @@ static ssize_t memory_oom_group_write(struct kernfs_open_file *of,
 	if (oom_group != 0 && oom_group != 1)
 		return -EINVAL;
 
-	memcg->oom_group = oom_group;
+	WRITE_ONCE(memcg->oom_group, oom_group);
 
 	return nbytes;
 }
-- 
2.17.1

