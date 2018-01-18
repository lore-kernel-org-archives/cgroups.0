From: =?UTF-8?q?Christopher=20D=C3=ADaz=20Riveros?= <chrisadr-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Subject: [PATCH-next] MEMCG: memcontrol: make local symbol static
Date: Thu, 18 Jan 2018 14:33:27 -0500
Message-ID: <20180118193327.14200-1-chrisadr@gentoo.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: =?UTF-8?q?Christopher=20D=C3=ADaz=20Riveros?= <chrisadr-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Fixes the following sparse warning:

mm/memcontrol.c:1097:14: warning:
  symbol 'memcg1_stats' was not declared. Should it be static?

Signed-off-by: Christopher D=C3=ADaz Riveros <chrisadr-aBrp7R+bbdUdnm+yROfE=
0A@public.gmane.org>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c3d1eaef752d..c992491dfb03 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1094,7 +1094,7 @@ static bool mem_cgroup_wait_acct_move(struct mem_cgro=
up *memcg)
 	return false;
 }
=20
-unsigned int memcg1_stats[] =3D {
+static const unsigned int memcg1_stats[] =3D {
 	MEMCG_CACHE,
 	MEMCG_RSS,
 	MEMCG_RSS_HUGE,
--=20
2.15.1
