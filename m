From: Anastasia Belova <abelova-5XX0/9e/aDUTdZ/Q6W51Bg@public.gmane.org>
Subject: [PATCH] mm: memcomtrol: add warning in case of rtpn = NULL
Date: Mon, 21 Aug 2023 17:20:51 +0300
Message-ID: <20230821142051.31889-1-abelova@astralinux.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Anastasia Belova <abelova-5XX0/9e/aDUTdZ/Q6W51Bg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lvc-project-tpLiQldItUH5n4uC9ZG1Ww@public.gmane.org

kzalloc_node may return NULL. So rtpn should be
checked before dereference in mem_cgroup_init.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 95a045f63d98 ("mm: memcontrol: consolidate memory controller initi=
alization")
Signed-off-by: Anastasia Belova <abelova-5XX0/9e/aDUTdZ/Q6W51Bg@public.gmane.org>
---
 mm/memcontrol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e8ca4bdcb03c..7998dbf3c7cd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7377,6 +7377,7 @@ static int __init mem_cgroup_init(void)
 		struct mem_cgroup_tree_per_node *rtpn;
=20
 		rtpn =3D kzalloc_node(sizeof(*rtpn), GFP_KERNEL, node);
+		WARN_ON(!rtpn);
=20
 		rtpn->rb_root =3D RB_ROOT;
 		rtpn->rb_rightmost =3D NULL;
--=20
2.30.2

