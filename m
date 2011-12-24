From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: [PATCH 1/6] memcg: fix unused variable warning
Date: Sat, 24 Dec 2011 05:00:14 +0200
Message-ID: <1324695619-5537-1-git-send-email-kirill@shutemov.name>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>

=46rom: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>

mm/memcontrol.c: In function =E2=80=98memcg_check_events=E2=80=99:
mm/memcontrol.c:784:22: warning: unused variable =E2=80=98do_numainfo=E2=
=80=99 [-Wunused-variable]

Signed-off-by: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
---
 mm/memcontrol.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d643bd6..a5e92bd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -781,14 +781,15 @@ static void memcg_check_events(struct mem_cgroup =
*memcg, struct page *page)
 	/* threshold event is triggered in finer grain than soft limit */
 	if (unlikely(mem_cgroup_event_ratelimit(memcg,
 						MEM_CGROUP_TARGET_THRESH))) {
-		bool do_softlimit, do_numainfo;
+		bool do_softlimit;
=20
-		do_softlimit =3D mem_cgroup_event_ratelimit(memcg,
-						MEM_CGROUP_TARGET_SOFTLIMIT);
 #if MAX_NUMNODES > 1
+		bool do_numainfo;
 		do_numainfo =3D mem_cgroup_event_ratelimit(memcg,
 						MEM_CGROUP_TARGET_NUMAINFO);
 #endif
+		do_softlimit =3D mem_cgroup_event_ratelimit(memcg,
+						MEM_CGROUP_TARGET_SOFTLIMIT);
 		preempt_enable();
=20
 		mem_cgroup_threshold(memcg);
--=20
1.7.7.3
