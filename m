From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH bpf-next 4/5] bpf: allow to disable bpf map memory accounting
Date: Sun,  5 Feb 2023 06:58:04 +0000
Message-ID: <20230205065805.19598-5-laoar.shao@gmail.com>
References: <20230205065805.19598-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PJFamjlYxQHTtnnrxr9/CB6pQuqIvvtPFL7L8VSX2/I=;
        b=gVVFqTvJAZvfk8KKjegWy9aL927a4bXCh4S7/MsZ+dJ0CQpxeUSN6EnF7tyCklTTVQ
         OVsq1QzMjsCmcd4BOylXTpoB3f2DZmVqjGVsbDRHa5Lie0k/KIbmAGfFc/MYK1Jdcvp8
         kXbE1kfU4oELctIwFWc7kLsfhakbRJ8kr6itCLvgz2YzqPxDbiE1XUY/QiK1L4g+zGnf
         eI6yV7bDEnOzZWom77cfc2Ly8cBIzfy+2ALeyzmgSBVV37qlT46yiT8rx5iPwXyumGu9
         Ts4yaKM1P5BfT/IhvtQg1f+x7ANzPnIYfqWkXtcAVNgbvrPeUMWaS7CyzW7PnviXTyq1
         BwOA==
In-Reply-To: <20230205065805.19598-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kafai-b10kYP2dOMg@public.gmane.org, songliubraving-b10kYP2dOMg@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

We can simply set root memcg as the map's memcg to disable bpf memory
accounting. bpf_map_area_alloc is a little special as it gets the memcg
from current rather than from the map, so we need to disable GFP_ACCOUNT
specifically for it.

Signed-off-by: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/bpf/memalloc.c | 3 ++-
 kernel/bpf/syscall.c  | 5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/memalloc.c b/kernel/bpf/memalloc.c
index ebcc3dd..6da9051 100644
--- a/kernel/bpf/memalloc.c
+++ b/kernel/bpf/memalloc.c
@@ -395,7 +395,8 @@ int bpf_mem_alloc_init(struct bpf_mem_alloc *ma, int size, bool percpu)
 		unit_size = size;
 
 #ifdef CONFIG_MEMCG_KMEM
-		objcg = get_obj_cgroup_from_current();
+		if (memcg_bpf_enabled())
+			objcg = get_obj_cgroup_from_current();
 #endif
 		for_each_possible_cpu(cpu) {
 			c = per_cpu_ptr(pc, cpu);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 9d94a35..cda8d00 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -309,7 +309,7 @@ static void *__bpf_map_area_alloc(u64 size, int numa_node, bool mmapable)
 	 * __GFP_RETRY_MAYFAIL to avoid such situations.
 	 */
 
-	const gfp_t gfp = __GFP_NOWARN | __GFP_ZERO | __GFP_ACCOUNT;
+	gfp_t gfp = bpf_memcg_flags(__GFP_NOWARN | __GFP_ZERO);
 	unsigned int flags = 0;
 	unsigned long align = 1;
 	void *area;
@@ -418,7 +418,8 @@ static void bpf_map_save_memcg(struct bpf_map *map)
 	 * So we have to check map->objcg for being NULL each time it's
 	 * being used.
 	 */
-	map->objcg = get_obj_cgroup_from_current();
+	if (memcg_bpf_enabled())
+		map->objcg = get_obj_cgroup_from_current();
 }
 
 static void bpf_map_release_memcg(struct bpf_map *map)
-- 
1.8.3.1

