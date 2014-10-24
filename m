From: Juri Lelli <juri.lelli@arm.com>
Subject: [PATCH 2/4] sched/deadline: ensure that updates to exclusive cpusets don't break AC
Date: Fri, 24 Oct 2014 10:16:36 +0100
Message-ID: <1414142198-18552-3-git-send-email-juri.lelli@arm.com>
References: <1414142198-18552-1-git-send-email-juri.lelli@arm.com>
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1414142198-18552-1-git-send-email-juri.lelli@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org, peterz@infradead.org
Cc: juri.lelli@gmail.com, mingo@redhat.com, daniel.wagner@bmw-carit.de, vincent@legout.info, Juri Lelli <juri.lelli@arm.com>, Dario Faggioli <raistlin@linux.it>, Michael Trimarchi <michael@amarulasolutions.com>, Fabio Checconi <fchecconi@gmail.com>, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org

How we deal with updates to exclusive cpusets is currently broken.
As an example, suppose we have an exclusive cpuset composed of
two cpus: A[cpu0,cpu1]. We can assign SCHED_DEADLINE task to it
up to the allowed bandwidth. If we want now to modify cpusetA's
cpumask, we have to check that removing a cpu's amount of
bandwidth doesn't break AC guarantees. This thing isn't checked
in the current code.

This patch fixes the problem above, denying an update if the
new cpumask won't have enough bandwidth for SCHED_DEADLINE tasks
that are currently active.

Signed-off-by: Juri Lelli <juri.lelli@arm.com>
Reported-by: Peter Zijlstra <peterz@infradead.org>
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
 include/linux/sched.h |  2 ++
 kernel/cpuset.c       | 10 ++++++++++
 kernel/sched/core.c   | 21 +++++++++++++++++++++
 3 files changed, 33 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index f225f20..d4ed0db 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2032,6 +2032,8 @@ static inline void tsk_restore_flags(struct task_stru=
ct *task,
 =09task->flags |=3D orig_flags & flags;
 }
=20
+extern int cpuset_cpumask_can_shrink(const struct cpumask *cur,
+=09=09=09=09     const struct cpumask *trial);
 extern int task_can_attach(struct task_struct *p,
 =09=09=09   const struct cpumask *cs_cpus_allowed);
 #ifdef CONFIG_SMP
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index ab9be24..9066cc7 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -505,6 +505,16 @@ static int validate_change(struct cpuset *cur, struct =
cpuset *trial)
 =09=09=09goto out;
 =09}
=20
+=09/*
+=09 * We can't shrink if we won't have enough room for SCHED_DEADLINE
+=09 * tasks.
+=09 */
+=09ret =3D -EBUSY;
+=09if (is_cpu_exclusive(cur) &&
+=09    !cpuset_cpumask_can_shrink(cur->cpus_allowed,
+=09=09=09=09       trial->cpus_allowed))
+=09=09goto out;
+
 =09ret =3D 0;
 out:
 =09rcu_read_unlock();
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 07ec9bb..35674eb 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4622,6 +4622,27 @@ void init_idle(struct task_struct *idle, int cpu)
 #endif
 }
=20
+int cpuset_cpumask_can_shrink(const struct cpumask *cur,
+=09=09=09      const struct cpumask *trial)
+{
+=09int ret =3D 1, trial_cpus;
+=09struct dl_bw *cur_dl_b;
+=09unsigned long flags;
+
+=09rcu_read_lock_sched();
+=09cur_dl_b =3D dl_bw_of(cpumask_any(cur));
+=09trial_cpus =3D cpumask_weight(trial);
+
+=09raw_spin_lock_irqsave(&cur_dl_b->lock, flags);
+=09if (cur_dl_b->bw !=3D -1 &&
+=09    cur_dl_b->bw * trial_cpus < cur_dl_b->total_bw)
+=09=09ret =3D 0;
+=09raw_spin_unlock_irqrestore(&cur_dl_b->lock, flags);
+=09rcu_read_unlock_sched();
+
+=09return ret;
+}
+
 int task_can_attach(struct task_struct *p,
 =09=09    const struct cpumask *cs_cpus_allowed)
 {
--=20
2.1.2

