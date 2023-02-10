From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH bpf-next v2 3/4] bpf: allow to disable bpf map memory accounting
Date: Fri, 10 Feb 2023 15:47:33 +0000
Message-ID: <20230210154734.4416-4-laoar.shao@gmail.com>
References: <20230210154734.4416-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KSCoSnxCH+oujuHlV2ueRvXQv9wOk6fb9r3EfXFy+Xw=;
        b=Jn96c5OSkEZ79jtvvUAgxCfdeK/vT5MXjAismyeWwqGOzgWUC7tOQxF5/wxGDKBd1+
         NQDqmadFBtS46XsKBvPQanuRJ4CwVD32afSccI431oQcKgoPI4yakO5ePhv3luG5q4Kq
         G1OmhSBaxjhnTpnCLISjIYzOyY4hc8swEO+5XOnMEsBhV8Ya3KN0EuX4XEAqdxIK1Qux
         u/rEUAhudYR05Nnyx77XVHNXBp+2OJQuOwOWJb7EYssyfW/YRSbb/a/Nj8C/Epr16s8S
         l5ToX2SA9BGj3aEmQ8g2629uZDbs5iDhJl7GvAh40gqex9vmEEaTyV1bl6WUkifgR+Ui
         sbUw==
In-Reply-To: <20230210154734.4416-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kafai-b10kYP2dOMg@public.gmane.org, songliubraving-b10kYP2dOMg@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

We can simply set root memcg as the map's memcg to disable bpf memory
accounting. bpf_map_area_alloc is a little special as it gets the memcg
from current rather than from the map, so we need to disable GFP_ACCOUNT
specifically for it.

Signed-off-by: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
---
 include/linux/bpf.h   | 8 ++++++++
 kernel/bpf/memalloc.c | 3 ++-
 kernel/bpf/syscall.c  | 5 +++--
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index fe0bf48..4385418 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -28,6 +28,7 @@
 #include <linux/btf.h>
 #include <linux/rcupdate_trace.h>
 #include <linux/static_call.h>
+#include <linux/memcontrol.h>
 
 struct bpf_verifier_env;
 struct bpf_verifier_log;
@@ -2933,4 +2934,11 @@ static inline bool type_is_alloc(u32 type)
 	return type & MEM_ALLOC;
 }
 
+static inline gfp_t bpf_memcg_flags(gfp_t flags)
+{
+	if (memcg_bpf_enabled())
+		return flags | __GFP_ACCOUNT;
+	return flags;
+}
+
 #endif /* _LINUX_BPF_H */
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

