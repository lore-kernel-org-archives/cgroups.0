From: Juri Lelli <juri.lelli@arm.com>
Subject: [PATCH 2/3] sched/deadline: fix bandwidth check/update when migrating tasks between exclusive cpusets
Date: Fri, 19 Sep 2014 10:22:40 +0100
Message-ID: <1411118561-26323-3-git-send-email-juri.lelli@arm.com>
References: <1411118561-26323-1-git-send-email-juri.lelli@arm.com>
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1411118561-26323-1-git-send-email-juri.lelli@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: peterz@infradead.org
Cc: mingo@redhat.com, juri.lelli@gmail.com, raistlin@linux.it, michael@amarulasolutions.com, fchecconi@gmail.com, daniel.wagner@bmw-carit.de, vincent@legout.info, luca.abeni@unitn.it, linux-kernel@vger.kernel.org, Juri Lelli <juri.lelli@arm.com>, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org

Exclusive cpusets are the only way users can restrict SCHED_DEADLINE tasks
affinity (performing what is commonly called clustered scheduling).
Unfortunately, such thing is currently broken for two reasons:

 - No check is performed when the user tries to attach a task to
   an exlusive cpuset (recall that exclusive cpusets have an
   associated maximum allowed bandwidth).

 - Bandwidths of source and destination cpusets are not correctly
   updated after a task is migrated between them.

This patch fixes both things at once, as they are opposite faces
of the same coin.

The check is performed in cpuset_can_attach(), as there aren't any
points of failure after that function. The updated is split in two
halves. We first reserve bandwidth in the destination cpuset, after
we pass the check in cpuset_can_attach(). And we then release
bandwidth from the source cpuset when the task's affinity is
actually changed. Even if there can be time windows when sched_setattr()
may erroneously fail in the source cpuset, we are fine with it, as
we can't perfom an atomic update of both cpusets at once.

Reported-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
Reported-by: Vincent Legout <vincent@legout.info>
Signed-off-by: Juri Lelli <juri.lelli@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: Dario Faggioli <raistlin@linux.it>
Cc: Michael Trimarchi <michael@amarulasolutions.com>
Cc: Fabio Checconi <fchecconi@gmail.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org
---
 include/linux/sched.h   |  2 ++
 kernel/cpuset.c         | 13 ++-------
 kernel/sched/core.c     | 70 +++++++++++++++++++++++++++++++++++----------=
----
 kernel/sched/deadline.c | 25 ++++++++++++++++--
 kernel/sched/sched.h    | 19 ++++++++++++++
 5 files changed, 97 insertions(+), 32 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5c2c885..3a65995 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2029,6 +2029,8 @@ static inline void tsk_restore_flags(struct task_stru=
ct *task,
 =09task->flags |=3D orig_flags & flags;
 }
=20
+extern int task_can_attach(struct task_struct *p,
+=09=09=09   const struct cpumask *cs_cpus_allowed);
 #ifdef CONFIG_SMP
 extern void do_set_cpus_allowed(struct task_struct *p,
 =09=09=09       const struct cpumask *new_mask);
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 22874d7..ab9be24 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1428,17 +1428,8 @@ static int cpuset_can_attach(struct cgroup_subsys_st=
ate *css,
 =09=09goto out_unlock;
=20
 =09cgroup_taskset_for_each(task, tset) {
-=09=09/*
-=09=09 * Kthreads which disallow setaffinity shouldn't be moved
-=09=09 * to a new cpuset; we don't want to change their cpu
-=09=09 * affinity and isolating such threads by their set of
-=09=09 * allowed nodes is unnecessary.  Thus, cpusets are not
-=09=09 * applicable for such threads.  This prevents checking for
-=09=09 * success of set_cpus_allowed_ptr() on all attached tasks
-=09=09 * before cpus_allowed may be changed.
-=09=09 */
-=09=09ret =3D -EINVAL;
-=09=09if (task->flags & PF_NO_SETAFFINITY)
+=09=09ret =3D task_can_attach(task, cs->cpus_allowed);
+=09=09if (ret)
 =09=09=09goto out_unlock;
 =09=09ret =3D security_task_setscheduler(task);
 =09=09if (ret)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 581a429..092143d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2013,25 +2013,6 @@ static inline int dl_bw_cpus(int i)
 }
 #endif
=20
-static inline
-void __dl_clear(struct dl_bw *dl_b, u64 tsk_bw)
-{
-=09dl_b->total_bw -=3D tsk_bw;
-}
-
-static inline
-void __dl_add(struct dl_bw *dl_b, u64 tsk_bw)
-{
-=09dl_b->total_bw +=3D tsk_bw;
-}
-
-static inline
-bool __dl_overflow(struct dl_bw *dl_b, int cpus, u64 old_bw, u64 new_bw)
-{
-=09return dl_b->bw !=3D -1 &&
-=09       dl_b->bw * cpus < dl_b->total_bw - old_bw + new_bw;
-}
-
 /*
  * We must be sure that accepting a new task (or allowing changing the
  * parameters of an existing one) is consistent with the bandwidth
@@ -4606,6 +4587,57 @@ void init_idle(struct task_struct *idle, int cpu)
 #endif
 }
=20
+int task_can_attach(struct task_struct *p,
+=09=09    const struct cpumask *cs_cpus_allowed)
+{
+=09int ret =3D 0;
+
+=09/*
+=09 * Kthreads which disallow setaffinity shouldn't be moved
+=09 * to a new cpuset; we don't want to change their cpu
+=09 * affinity and isolating such threads by their set of
+=09 * allowed nodes is unnecessary.  Thus, cpusets are not
+=09 * applicable for such threads.  This prevents checking for
+=09 * success of set_cpus_allowed_ptr() on all attached tasks
+=09 * before cpus_allowed may be changed.
+=09 */
+=09if (p->flags & PF_NO_SETAFFINITY) {
+=09=09ret =3D -EINVAL;
+=09=09goto out;
+=09}
+
+#ifdef CONFIG_SMP
+=09if (dl_task(p) && !cpumask_intersects(task_rq(p)->rd->span,
+=09=09=09=09=09      cs_cpus_allowed)) {
+=09=09unsigned int dest_cpu =3D cpumask_any_and(cpu_active_mask,
+=09=09=09=09=09=09=09cs_cpus_allowed);
+=09=09struct dl_bw *dl_b =3D dl_bw_of(dest_cpu);
+=09=09bool overflow;
+=09=09int cpus;
+=09=09unsigned long flags;
+
+=09=09raw_spin_lock_irqsave(&dl_b->lock, flags);
+=09=09cpus =3D dl_bw_cpus(dest_cpu);
+=09=09overflow =3D __dl_overflow(dl_b, cpus, 0, p->dl.dl_bw);
+=09=09if (overflow)
+=09=09=09ret =3D -EBUSY;
+=09=09else {
+=09=09=09/*
+=09=09=09 * We reserve space for this task in the destination
+=09=09=09 * root_domain, as we can't fail after this point.
+=09=09=09 * We will free resources in the source root_domain
+=09=09=09 * later on (see set_cpus_allowed_dl()).
+=09=09=09 */
+=09=09=09__dl_add(dl_b, p->dl.dl_bw);
+=09=09}
+=09=09raw_spin_unlock_irqrestore(&dl_b->lock, flags);
+
+=09}
+#endif
+out:
+=09return ret;
+}
+
 #ifdef CONFIG_SMP
 void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_=
mask)
 {
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 4a51b14..56cb157 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1495,10 +1495,33 @@ static void set_cpus_allowed_dl(struct task_struct =
*p,
 =09=09=09=09const struct cpumask *new_mask)
 {
 =09struct rq *rq;
+=09struct root_domain *src_rd;
 =09int weight;
=20
 =09BUG_ON(!dl_task(p));
=20
+=09rq =3D task_rq(p);
+=09src_rd =3D rq->rd;
+=09/*
+=09 * Migrating a SCHED_DEADLINE task between exclusive
+=09 * cpusets (different root_domains) entails a bandwidth
+=09 * update. We already made space for us in the destination
+=09 * domain (see cpuset_can_attach()).
+=09 */
+=09if (!cpumask_intersects(src_rd->span, new_mask)) {
+=09=09struct dl_bw *src_dl_b;
+
+=09=09src_dl_b =3D dl_bw_of(cpu_of(rq));
+=09=09/*
+=09=09 * We now free resources of the root_domain we are migrating
+=09=09 * off. In the worst case, sched_setattr() may temporary fail
+=09=09 * until we complete the update.
+=09=09 */
+=09=09raw_spin_lock(&src_dl_b->lock);
+=09=09__dl_clear(src_dl_b, p->dl.dl_bw);
+=09=09raw_spin_unlock(&src_dl_b->lock);
+=09}
+
 =09/*
 =09 * Update only if the task is actually running (i.e.,
 =09 * it is on the rq AND it is not throttled).
@@ -1515,8 +1538,6 @@ static void set_cpus_allowed_dl(struct task_struct *p=
,
 =09if ((p->nr_cpus_allowed > 1) =3D=3D (weight > 1))
 =09=09return;
=20
-=09rq =3D task_rq(p);
-
 =09/*
 =09 * The process used to be able to migrate OR it can now migrate
 =09 */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 4890484..a0e9e81 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -171,6 +171,25 @@ struct dl_bw {
 =09u64 bw, total_bw;
 };
=20
+static inline
+void __dl_clear(struct dl_bw *dl_b, u64 tsk_bw)
+{
+=09dl_b->total_bw -=3D tsk_bw;
+}
+
+static inline
+void __dl_add(struct dl_bw *dl_b, u64 tsk_bw)
+{
+=09dl_b->total_bw +=3D tsk_bw;
+}
+
+static inline
+bool __dl_overflow(struct dl_bw *dl_b, int cpus, u64 old_bw, u64 new_bw)
+{
+=09return dl_b->bw !=3D -1 &&
+=09       dl_b->bw * cpus < dl_b->total_bw - old_bw + new_bw;
+}
+
 extern struct mutex sched_domains_mutex;
=20
 #ifdef CONFIG_CGROUP_SCHED
--=20
2.1.0

