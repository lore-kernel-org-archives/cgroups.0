From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH 3/4] mm: memcontrol: bail out early when id is zero
Date: Sat, 13 Feb 2021 01:01:58 +0800
Message-ID: <20210212170159.32153-3-songmuchun@bytedance.com>
References: <20210212170159.32153-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uMiCMlqqsGt4v3DIDBbc5Tzpa+oMrTR3N8I/PD9p2nk=;
        b=NmStyGwgQEnVNrqN5Ubtgd25sYfpL8IXtOClOXbtc4s/sjMIQFqvb31t0DYjJZidM1
         gCU3y8v0DWb3bByea+46x2tO/zxaZI0DLjF8Y1CVsBZu6wD68sRHZXdAlzW5+0pqOwTT
         TM3Jb8qnl9xOL4mWSIZj8Q1QL2ERlMxEY4F9uzUa1wjlotEQZKxZVjviz3OXd8WsF/Rg
         jFVabi1XtYlsOwbqnSNgovnWpCfmsOpZKBCmrxZU1f8vkqYrTp2sVvrX738HsEIw8MFn
         blBu6Yfthn9vxzvgemOvsKgO0ZWZHZw99ZIC5oXvfM3NPLKZaY4jXeVvJfxkeLuu24Wy
         6/NQ==
In-Reply-To: <20210212170159.32153-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

The memcg ID cannot be zero, but we can pass zero to mem_cgroup_from_id,
so idr_find() is pointless and wastes CPU cycles.

Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 mm/memcontrol.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a3f26522765a..68ed4b297c13 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5173,6 +5173,9 @@ static inline void mem_cgroup_id_put(struct mem_cgroup *memcg)
 struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
 {
 	WARN_ON_ONCE(!rcu_read_lock_held());
+	/* The memcg ID cannot be zero. */
+	if (id == 0)
+		return NULL;
 	return idr_find(&mem_cgroup_idr, id);
 }
 
-- 
2.11.0

