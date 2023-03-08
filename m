From: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3, 2/4] mm, memcg: Prevent memory.swappiness load/store tearing
Date: Thu,  9 Mar 2023 00:25:53 +0800
Message-ID: <20230308162555.14195-3-findns94@gmail.com>
References: <20230308162555.14195-1-findns94@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678292780;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pobmz56zWKXlv9VCRaNaOZMVD/RL8QxL/evDPGbbBYE=;
        b=McRkR1WhMXjVktc5aTw6T5/gz6rhdeR71Ukow2/ZzU1pNGgYskeBNM0STRwyIy0Hfm
         VTjxzQlU7sNL+v1NTYRQO8byhGn8P2ftwg0bNZl33Yx1hL90jCxOR3bvGXjNkeWh9G+m
         C3j8eWUiMVJgELYTg2oJkgiUFs3xb8VJ3e0o8SI1++jbALmILsUgu9mjOqkVEbP7RbIl
         TMWTLq/3F2oYXfLXSG/GLKvyAmjIjvn95772zy1qiECDYhLI3hP7yw575MZeEwjnopoj
         KCscHtCaCIVPuwZUB7vRCpSp6eQz5bg1OXfrbbiYqWy19G0Ga3XuBmYXT4rGuhEJ20xZ
         Vryg==
In-Reply-To: <20230308162555.14195-1-findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tangyeechou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

The knob for cgroup v1 memory controller: memory.swappiness
is not protected by any locking so it can be modified while it is used.
This is not an actual problem because races are unlikely.
But it is better to use [READ|WRITE]_ONCE to prevent compiler from
doing anything funky.

The access of memcg->swappiness and vm_swappiness is lockless,
so both of them can be concurrently set at the same time
as we are trying to read them. All occurrences of memcg->swappiness
and vm_swappiness are updated with [READ|WRITE]_ONCE.

Signed-off-by: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 include/linux/swap.h | 8 ++++----
 mm/memcontrol.c      | 6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 209a425739a9..3f3fe43d1766 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -620,18 +620,18 @@ static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 {
 	/* Cgroup2 doesn't have per-cgroup swappiness */
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		return vm_swappiness;
+		return READ_ONCE(vm_swappiness);
 
 	/* root ? */
 	if (mem_cgroup_disabled() || mem_cgroup_is_root(memcg))
-		return vm_swappiness;
+		return READ_ONCE(vm_swappiness);
 
-	return memcg->swappiness;
+	return READ_ONCE(memcg->swappiness);
 }
 #else
 static inline int mem_cgroup_swappiness(struct mem_cgroup *mem)
 {
-	return vm_swappiness;
+	return READ_ONCE(vm_swappiness);
 }
 #endif
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 06821e5f7604..1b0112afcad3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4179,9 +4179,9 @@ static int mem_cgroup_swappiness_write(struct cgroup_subsys_state *css,
 		return -EINVAL;
 
 	if (!mem_cgroup_is_root(memcg))
-		memcg->swappiness = val;
+		WRITE_ONCE(memcg->swappiness, val);
 	else
-		vm_swappiness = val;
+		WRITE_ONCE(vm_swappiness, val);
 
 	return 0;
 }
@@ -5353,7 +5353,7 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 #endif
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	if (parent) {
-		memcg->swappiness = mem_cgroup_swappiness(parent);
+		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
 		memcg->oom_kill_disable = parent->oom_kill_disable;
 
 		page_counter_init(&memcg->memory, &parent->memory);
-- 
2.17.1

