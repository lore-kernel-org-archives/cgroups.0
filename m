From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 2/5] memcg: flush stats non-atomically in mem_cgroup_wb_stats()
Date: Fri, 21 Apr 2023 17:40:17 +0000
Message-ID: <20230421174020.2994750-3-yosryahmed@google.com>
References: <20230421174020.2994750-1-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682098826; x=1684690826;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ze/kPlw8gotaEo1sJnB2fYrZx8MA/zlu9x0xYHZ+g7E=;
        b=evkdgDpSyqlLAXON2ZuU2lSGfLM1dQnhdPP+fmyZWeKwGNZTWFCJKPVGhM2bZZGKOC
         f7YfSGCo2Nf3oXwwYJmGjEDgBvFsw6i76b70QgcRaecrvTKD295qL9CqwnO4UztiMSAR
         wca4o1fBiZOb2DZIrqp+VDQfAwIcLci5K41MPeROy0/47HRyQgXuMC8OBwZyCxCgwh/S
         8f4JUGNY1xeou8G6F0i+W3dKhEWQ3Zv+nckYooRRkUzwRcW77nDMDOwXtSb1IOOWcx0Y
         jIqwdtbmW/rhz4VKzZZ8k/jeg5TikDCeSv0Wmg2wr9UElKoOoUpGS9AakxlgHuAC0y31
         KsJw==
In-Reply-To: <20230421174020.2994750-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

The previous patch moved the wb_over_bg_thresh()->mem_cgroup_wb_stats()
code path in wb_writeback() outside the lock section. We no longer need
to flush the stats atomically. Flush the stats non-atomically.

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org>
Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4b27e245a055..5e79fdf8442b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4648,11 +4648,7 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, u=
nsigned long *pfilepages,
 	struct mem_cgroup *memcg =3D mem_cgroup_from_css(wb->memcg_css);
 	struct mem_cgroup *parent;
=20
-	/*
-	 * wb_writeback() takes a spinlock and calls
-	 * wb_over_bg_thresh()->mem_cgroup_wb_stats(). Do not sleep.
-	 */
-	mem_cgroup_flush_stats_atomic();
+	mem_cgroup_flush_stats();
=20
 	*pdirty =3D memcg_page_state(memcg, NR_FILE_DIRTY);
 	*pwriteback =3D memcg_page_state(memcg, NR_WRITEBACK);
--=20
2.40.0.634.g4ca3ef3211-goog

