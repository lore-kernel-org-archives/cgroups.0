From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: [PATCH] cgroup: inline cgroup_task_freeze()
Date: Mon, 10 May 2021 11:45:56 -0700
Message-ID: <20210510184556.946798-1-guro@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=rWFLuxjlkCJpY+dUzioJAmlhNduAcTJxyvXk5dzyWIo=;
 b=ouzbLFe/3wo/rDw79rBNsSn8TgezE+cVrTlolHE5MX8NxiOlk7budplM3sBW5sdsFgQa
 xD+IQfa/4hFJd5E9Lbpyd2qKOg7QlhNFqbtDduufaw3Jae6qPK9QTp+Z/80a6NsCj2ZV
 PFs+OZ23qLio35ekaQxLn6bprQRS+6wOvXw= 
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

After the introduction of the cgroup.kill there is only one call site
of cgroup_task_freeze() left: cgroup_exit(). cgroup_task_freeze() is
currently taking rcu_read_lock() to read task's cgroup flags, but
because it's always called with css_set_lock locked, the rcu protection
is excessive.

Simplify the code by inlining cgroup_task_freeze().

Signed-off-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
---
 include/linux/cgroup.h | 18 ------------------
 kernel/cgroup/cgroup.c |  3 ++-
 2 files changed, 2 insertions(+), 19 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 4f2f79de083e..a72764287cb5 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -906,20 +906,6 @@ void cgroup_freeze(struct cgroup *cgrp, bool freeze)=
;
 void cgroup_freezer_migrate_task(struct task_struct *task, struct cgroup=
 *src,
 				 struct cgroup *dst);
=20
-static inline bool cgroup_task_freeze(struct task_struct *task)
-{
-	bool ret;
-
-	if (task->flags & PF_KTHREAD)
-		return false;
-
-	rcu_read_lock();
-	ret =3D test_bit(CGRP_FREEZE, &task_dfl_cgroup(task)->flags);
-	rcu_read_unlock();
-
-	return ret;
-}
-
 static inline bool cgroup_task_frozen(struct task_struct *task)
 {
 	return task->frozen;
@@ -929,10 +915,6 @@ static inline bool cgroup_task_frozen(struct task_st=
ruct *task)
=20
 static inline void cgroup_enter_frozen(void) { }
 static inline void cgroup_leave_frozen(bool always_leave) { }
-static inline bool cgroup_task_freeze(struct task_struct *task)
-{
-	return false;
-}
 static inline bool cgroup_task_frozen(struct task_struct *task)
 {
 	return false;
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index e640fc78d731..29be28e903ab 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6267,7 +6267,8 @@ void cgroup_exit(struct task_struct *tsk)
 	cset->nr_tasks--;
=20
 	WARN_ON_ONCE(cgroup_task_frozen(tsk));
-	if (unlikely(cgroup_task_freeze(tsk)))
+	if (unlikely(!(task->flags & PF_KTHREAD) &&
+		     test_bit(CGRP_FREEZE, &task_dfl_cgroup(task)->flags)))
 		cgroup_update_frozen(task_dfl_cgroup(tsk));
=20
 	spin_unlock_irq(&css_set_lock);
--=20
2.30.2

