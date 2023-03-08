From: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3, 3/4] mm, memcg: Prevent memory.oom_control load/store tearing
Date: Thu,  9 Mar 2023 00:25:54 +0800
Message-ID: <20230308162555.14195-4-findns94@gmail.com>
References: <20230308162555.14195-1-findns94@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678292783;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kqeFiKRizo4EGYqriaZmF5h1PWpLfju0MvbdsBusLUQ=;
        b=RrUABNuCm23cw7zAS2r7lcfX6PoRi1Q4A6nYTvlFu+h/X4B289H2dUHucrYXkd+iTy
         hsSB64i59WWfc0uy40q5BicLg5T3NqA4EyM2HtbP9aMG90H7ysqkcwwRIBDQM+oKsL2c
         jPzCGI3yBDcGPpWH5BAjJXwdZxPUUwC1rqqb3BWim1UFKIptfQROIZjUOFkUF2Ymg+N5
         n6LeGStUZx/yL69zcRf/KOjYv/sAPzIADkPqKSYyNQGpBeLOeQvpPCva8YqeIATfzeqG
         ztixlNoZ28CemrDp8oaWk6AisdpRAoEDS3zAo3qrU3z2NhNSc3zR/aUp1Y8rFBkKVIEI
         GWcA==
In-Reply-To: <20230308162555.14195-1-findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tangyeechou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

The knob for cgroup v1 memory controller: memory.oom_control
is not protected by any locking so it can be modified while it is used.
This is not an actual problem because races are unlikely.
But it is better to use [READ|WRITE]_ONCE to prevent compiler from
doing anything funky.

The access of memcg->oom_kill_disable is lockless,
so it can be concurrently set at the same time as we are
trying to read it. All occurrences of memcg->oom_kill_disable
are updated with [READ|WRITE]_ONCE.

Signed-off-by: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1b0112afcad3..5b7062d0f5e0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1929,7 +1929,7 @@ static bool mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int order)
 	 * Please note that mem_cgroup_out_of_memory might fail to find a
 	 * victim and then we have to bail out from the charge path.
 	 */
-	if (memcg->oom_kill_disable) {
+	if (READ_ONCE(memcg->oom_kill_disable)) {
 		if (current->in_user_fault) {
 			css_get(&memcg->css);
 			current->memcg_in_oom = memcg;
@@ -1999,7 +1999,7 @@ bool mem_cgroup_oom_synchronize(bool handle)
 	if (locked)
 		mem_cgroup_oom_notify(memcg);
 
-	if (locked && !memcg->oom_kill_disable) {
+	if (locked && !READ_ONCE(memcg->oom_kill_disable)) {
 		mem_cgroup_unmark_under_oom(memcg);
 		finish_wait(&memcg_oom_waitq, &owait.wait);
 		mem_cgroup_out_of_memory(memcg, current->memcg_oom_gfp_mask,
@@ -4515,7 +4515,7 @@ static int mem_cgroup_oom_control_read(struct seq_file *sf, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(sf);
 
-	seq_printf(sf, "oom_kill_disable %d\n", memcg->oom_kill_disable);
+	seq_printf(sf, "oom_kill_disable %d\n", READ_ONCE(memcg->oom_kill_disable));
 	seq_printf(sf, "under_oom %d\n", (bool)memcg->under_oom);
 	seq_printf(sf, "oom_kill %lu\n",
 		   atomic_long_read(&memcg->memory_events[MEMCG_OOM_KILL]));
@@ -4531,7 +4531,7 @@ static int mem_cgroup_oom_control_write(struct cgroup_subsys_state *css,
 	if (mem_cgroup_is_root(memcg) || !((val == 0) || (val == 1)))
 		return -EINVAL;
 
-	memcg->oom_kill_disable = val;
+	WRITE_ONCE(memcg->oom_kill_disable, val);
 	if (!val)
 		memcg_oom_recover(memcg);
 
@@ -5354,7 +5354,7 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	if (parent) {
 		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
-		memcg->oom_kill_disable = parent->oom_kill_disable;
+		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
 
 		page_counter_init(&memcg->memory, &parent->memory);
 		page_counter_init(&memcg->swap, &parent->swap);
-- 
2.17.1

