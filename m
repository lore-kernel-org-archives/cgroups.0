From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 3/5] memcg: calculate root usage from global state
Date: Fri, 21 Apr 2023 17:40:18 +0000
Message-ID: <20230421174020.2994750-4-yosryahmed@google.com>
References: <20230421174020.2994750-1-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682098828; x=1684690828;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZwYNf0IQKL13Uvalja3XtUe1fz98Sj9XyCNuQ2xKGcs=;
        b=Vz7q7OzmTKVhjKuL1Z10tx4sjzaZzQc1RfkV5JIKDa4QF+qc7PE1nRpKj4JbTW26CL
         6HWg0Bk/Qn7IeGOg2v+aAU068B55qLODSnp8tJGuESSICbp+6Gjpfa3HASvT4P/INIIX
         FNJAyhgiBW8P7szSQRrC+9yXtrHR4LwEf5c+uGkIF6nWGq5t81yHqYblmUSNV6/Pj4a5
         x4hPCDxoK7EryyUSzUifkrvbv6JClx5/LSyTe0bPdsXuYCvvh5cuu7sfplfgaUZyWnve
         cPw/375qmd31nmxG3Xi1PRi7CTxei8qHjgER9ienP6JVZlSSk1rMC1yFsifBD6+eDFuk
         /A6g==
In-Reply-To: <20230421174020.2994750-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Currently, we approximate the root usage by adding the memcg stats for
anon, file, and conditionally swap (for memsw). To read the memcg stats
we need to invoke an rstat flush. rstat flushes can be expensive, they
scale with the number of cpus and cgroups on the system.

mem_cgroup_usage() is called by memcg_events()->mem_cgroup_threshold()
with irqs disabled, so such an expensive operation with irqs disabled
can cause problems.

Instead, approximate the root usage from global state. This is not 100%
accurate, but the root usage has always been ill-defined anyway.

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org>
Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5e79fdf8442b..cb78bba5b4a4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3699,27 +3699,13 @@ static unsigned long mem_cgroup_usage(struct mem_cg=
roup *memcg, bool swap)
=20
 	if (mem_cgroup_is_root(memcg)) {
 		/*
-		 * We can reach here from irq context through:
-		 * uncharge_batch()
-		 * |--memcg_check_events()
-		 *    |--mem_cgroup_threshold()
-		 *       |--__mem_cgroup_threshold()
-		 *          |--mem_cgroup_usage
-		 *
-		 * rstat flushing is an expensive operation that should not be
-		 * done from irq context; use stale stats in this case.
-		 * Arguably, usage threshold events are not reliable on the root
-		 * memcg anyway since its usage is ill-defined.
-		 *
-		 * Additionally, other call paths through memcg_check_events()
-		 * disable irqs, so make sure we are flushing stats atomically.
+		 * Approximate root's usage from global state. This isn't
+		 * perfect, but the root usage was always an approximation.
 		 */
-		if (in_task())
-			mem_cgroup_flush_stats_atomic();
-		val =3D memcg_page_state(memcg, NR_FILE_PAGES) +
-			memcg_page_state(memcg, NR_ANON_MAPPED);
+		val =3D global_node_page_state(NR_FILE_PAGES) +
+			global_node_page_state(NR_ANON_MAPPED);
 		if (swap)
-			val +=3D memcg_page_state(memcg, MEMCG_SWAP);
+			val +=3D total_swap_pages - get_nr_swap_pages();
 	} else {
 		if (!swap)
 			val =3D page_counter_read(&memcg->memory);
--=20
2.40.0.634.g4ca3ef3211-goog

