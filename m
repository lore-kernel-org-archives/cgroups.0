From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/5] mm, memcg: avoid possible NULL pointer dereferencing in mem_cgroup_init()
Date: Thu, 29 Jul 2021 20:57:54 +0800
Message-ID: <20210729125755.16871-5-linmiaohe@huawei.com>
References: <20210729125755.16871-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20210729125755.16871-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

rtpn might be NULL in very rare case. We have better to check it before
dereferencing it. Since memcg can live with NULL rb_tree_per_node in
soft_limit_tree, warn this case and continue.

Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5b4592d1e0f2..70a32174e7c4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7109,6 +7109,8 @@ static int __init mem_cgroup_init(void)
 		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL,
 				    node_online(node) ? node : NUMA_NO_NODE);
 
+		if (WARN_ON_ONCE(!rtpn))
+			continue;
 		rtpn->rb_root = RB_ROOT;
 		rtpn->rb_rightmost = NULL;
 		spin_lock_init(&rtpn->lock);
-- 
2.23.0

