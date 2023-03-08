From: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3, 4/4] mm, memcg: Prevent memory.soft_limit_in_bytes load/store tearing
Date: Thu,  9 Mar 2023 00:25:55 +0800
Message-ID: <20230308162555.14195-5-findns94@gmail.com>
References: <20230308162555.14195-1-findns94@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678292788;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=z+4uYXTHdSZJGlTQ4yJuaUKIcEogMIg606wt+PsHQ10=;
        b=kswqtEU7Xj6n7CisW2qiImBeQaeJAQosHCyMQLF85hJ3RIz6SE9Rt2WZbQXfYtQarS
         w1QOwuboYFZVWg3MH8bUqqwclcgHc3MmuZZUsydleg5jg4zMt4wgbQMRkOBzw3Zucdt8
         bDfH1puKOJ2+Jws7pHS692luihVb02mlaXjFcfe/mkc0SVVtNkvvaMGjhmgRWz60Hrhj
         hsoZyvjuIAA64kBJePxrgKD3g/6sRoG8j42SBuX/XEEqcwDNrw4HvoAAvVN3G64Ld9aT
         Efv9BEBWmzR2cSAbKApAMZDiqB5AIM5zyFGrDWK2hfiWrdLkaCvW3wS224bS2oq9JkyC
         BQvA==
In-Reply-To: <20230308162555.14195-1-findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tangyeechou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

The knob for cgroup v1 memory controller: memory.soft_limit_in_bytes
is not protected by any locking so it can be modified while it is used.
This is not an actual problem because races are unlikely.
But it is better to use [READ|WRITE]_ONCE to prevent compiler from
doing anything funky.

The access of memcg->soft_limit is lockless,
so it can be concurrently set at the same time as we are
trying to read it. All occurrences of memcg->soft_limit
are updated with [READ|WRITE]_ONCE.

Signed-off-by: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5b7062d0f5e0..13ec89c45389 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3728,7 +3728,7 @@ static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
 	case RES_FAILCNT:
 		return counter->failcnt;
 	case RES_SOFT_LIMIT:
-		return (u64)memcg->soft_limit * PAGE_SIZE;
+		return (u64)READ_ONCE(memcg->soft_limit) * PAGE_SIZE;
 	default:
 		BUG();
 	}
@@ -3870,7 +3870,7 @@ static ssize_t mem_cgroup_write(struct kernfs_open_file *of,
 		if (IS_ENABLED(CONFIG_PREEMPT_RT)) {
 			ret = -EOPNOTSUPP;
 		} else {
-			memcg->soft_limit = nr_pages;
+			WRITE_ONCE(memcg->soft_limit, nr_pages);
 			ret = 0;
 		}
 		break;
@@ -5347,7 +5347,7 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 		return ERR_CAST(memcg);
 
 	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
-	memcg->soft_limit = PAGE_COUNTER_MAX;
+	WRITE_ONCE(memcg->soft_limit, PAGE_COUNTER_MAX);
 #if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
 	memcg->zswap_max = PAGE_COUNTER_MAX;
 #endif
@@ -5502,7 +5502,7 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 	page_counter_set_min(&memcg->memory, 0);
 	page_counter_set_low(&memcg->memory, 0);
 	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
-	memcg->soft_limit = PAGE_COUNTER_MAX;
+	WRITE_ONCE(memcg->soft_limit, PAGE_COUNTER_MAX);
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	memcg_wb_domain_size_changed(memcg);
 }
-- 
2.17.1

