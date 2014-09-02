From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] cgroup: check cgroup liveliness before unbreaking kernfs
 protection
Date: Tue, 2 Sep 2014 18:57:54 +0800
Message-ID: <5405A2B2.4010406@huawei.com>
References: <5405A27A.3090605@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5405A27A.3090605-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster-Mmb7MZpHnFY@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

When cgroup_kn_lock_live() is called through some kernfs operation and
another thread is calling cgroup_rmdir(), we may trigger the warning in
cgroup_get().

------------[ cut here ]------------
WARNING: CPU: 1 PID: 1228 at kernel/cgroup.c:1034 cgroup_get+0x89/0xa0(=
)
=2E..
Call Trace:
 [<c16ee73d>] dump_stack+0x41/0x52
 [<c10468ef>] warn_slowpath_common+0x7f/0xa0
 [<c104692d>] warn_slowpath_null+0x1d/0x20
 [<c10bb999>] cgroup_get+0x89/0xa0
 [<c10bbe58>] cgroup_kn_lock_live+0x28/0x70
 [<c10be3c1>] __cgroup_procs_write.isra.26+0x51/0x230
 [<c10be5b2>] cgroup_tasks_write+0x12/0x20
 [<c10bb7b0>] cgroup_file_write+0x40/0x130
 [<c11aee71>] kernfs_fop_write+0xd1/0x160
 [<c1148e58>] vfs_write+0x98/0x1e0
 [<c114934d>] SyS_write+0x4d/0xa0
 [<c16f656b>] sysenter_do_call+0x12/0x12
---[ end trace 6f2e0c38c2108a74 ]---

=46ix this by calling css_tryget() instead of cgroup_get().

Reported-by: Toralf F=C3=B6rster <toralf.foerster-Mmb7MZpHnFY@public.gmane.org>
Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e03fc62..c8d07e5 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1025,6 +1025,11 @@ static umode_t cgroup_file_mode(const struct cft=
ype *cft)
 	return mode;
 }
=20
+static bool cgroup_tryget(struct cgroup *cgrp)
+{
+	return css_tryget(&cgrp->self);
+}
+
 static void cgroup_get(struct cgroup *cgrp)
 {
 	WARN_ON_ONCE(cgroup_is_dead(cgrp));
@@ -1091,7 +1096,8 @@ static struct cgroup *cgroup_kn_lock_live(struct =
kernfs_node *kn)
 	 * protection against removal.  Ensure @cgrp stays accessible and
 	 * break the active_ref protection.
 	 */
-	cgroup_get(cgrp);
+	if (!cgroup_tryget(cgrp))
+		return NULL;
 	kernfs_break_active_protection(kn);
=20
 	mutex_lock(&cgroup_mutex);
--=20
1.8.0.2
