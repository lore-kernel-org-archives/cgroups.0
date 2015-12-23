From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH] cgroup: Fix uninitialized variable warning
Date: Wed, 23 Dec 2015 14:53:27 -0700
Message-ID: <1450907607-5060-1-git-send-email-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>

Commit 1f7dd3e5a6e4 ("cgroup: fix handling of multi-destination migrati=
on
from subtree_control enabling") introduced the following compiler warni=
ng:

mm/memcontrol.c: In function =E2=80=98mem_cgroup_can_attach=E2=80=99:
mm/memcontrol.c:4790:9: warning: =E2=80=98memcg=E2=80=99 may be used un=
initialized in this function [-Wmaybe-uninitialized]
   mc.to =3D memcg;
         ^

=46ix this by initializing 'memcg' to NULL.

This was found using gcc (GCC) 4.9.2 20150212 (Red Hat 4.9.2-6).

Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 48b22c3..ffd9750 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4735,7 +4735,7 @@ static void mem_cgroup_clear_mc(void)
 static int mem_cgroup_can_attach(struct cgroup_taskset *tset)
 {
 	struct cgroup_subsys_state *css;
-	struct mem_cgroup *memcg;
+	struct mem_cgroup *memcg =3D NULL; /* unneeded init to make gcc happy=
 */
 	struct mem_cgroup *from;
 	struct task_struct *leader, *p;
 	struct mm_struct *mm;
--=20
2.6.3
