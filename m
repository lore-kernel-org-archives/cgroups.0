From: Sodagudi Prasad <psodagud@codeaurora.org>
Subject: deadlock due to circular dependency between threads
Date: Wed, 03 May 2017 19:39:07 -0700
Message-ID: <c6c7f2f89b567cec29921df03fe4bd14@codeaurora.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1493865548;
        bh=NJ/SGb/Dz9PrOupSaJ9BjweMWqE2lcyc4T8Iv5dvGyM=;
        h=Date:From:To:Cc:Subject:From;
        b=LsbnBuGLi1sPrpi3c2m645nEldeW1jbVZ1jCLTr8GI1PE7vp0SgmkVELUKdurpyFz
         PfAAsFAJ0k3TIJqv1RyCCgKrS2y3gOytrtYxJtf3NrrHOUbBcMW02810B4MSBkt+6K
         u/09H6ge9OjYA14/bCTvcocYO+btsUsYHfZtrL74=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1493865548;
        bh=NJ/SGb/Dz9PrOupSaJ9BjweMWqE2lcyc4T8Iv5dvGyM=;
        h=Date:From:To:Cc:Subject:From;
        b=LsbnBuGLi1sPrpi3c2m645nEldeW1jbVZ1jCLTr8GI1PE7vp0SgmkVELUKdurpyFz
         PfAAsFAJ0k3TIJqv1RyCCgKrS2y3gOytrtYxJtf3NrrHOUbBcMW02810B4MSBkt+6K
         u/09H6ge9OjYA14/bCTvcocYO+btsUsYHfZtrL74=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
To: cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Hi all,

I am working on a platform, which is using the Linux version 4.4. I have=20
observed a DEADLOCK between couple of threads and looking for=20
suggestions/comments.
Here is my understanding from the call stacks of these blocked tasks.

0) CPU3 is getting hot plugged from a kthread and which is running on=20
core5.
1) Cpu hot plug flow needs to flush the work items on hot plugging CPU3,=20
with a high priority worker from the corresponding CPU=E2=80=99s(cpu3) work=
er=20
pool.
2) There are no high priority workers on the CPU3 worker pool, so=20
create_worker was initiated to create high priority kernel=20
thread/worker.
3) This thread creation should be done by kthreadd demon, but kthreadd =20
demon have got stuck in some other thread creation. At this point of=20
time kthreadd creating a thread and updating cgroup settings and waiting=20
on rw semaphore of cgroup subsystem.
4) Cgroup readwrite semaphore is taken by "init" thread and waiting on=20
cpuset mutex lock. init task is updating cgroup's based on userspace=20
request.
5) Cpuset mutex lock is taken by "kworker:5/1" and it is waiting for=20
cpuhotplug lock.
Cpuhotplug mutex is taken by "ABC_XYZ" hotplugging thread. DEADLOCK!!!!!

circular dependency between threads:-
"kthread_XYZ" =3D=3D> "kthreadd" =3D=3D> "init"  =3D=3D> "kworker/5:1" =3D=
=3D>=20
"kthread_XYZ"


PID: 910    TASK: ffffffc0ee8dd780  CPU: 5   COMMAND: "ABC_XYZ"
  #0 [ffffffc0ee9cb900] __switch_to at ffffff800808553c
  #1 [ffffffc0ee9cb930] __schedule at ffffff8008d76aa0
  #2 [ffffffc0ee9cb990] schedule at ffffff8008d76e04
  #3 [ffffffc0ee9cb9b0] schedule_timeout at ffffff8008d7953c
  #4 [ffffffc0ee9cba60] wait_for_common at ffffff8008d77888
  #5 [ffffffc0ee9cbaf0] wait_for_completion at ffffff8008d778dc
  #6 [ffffffc0ee9cbb00] flush_work at ffffff80080b3850
  #7 [ffffffc0ee9cbb80] workqueue_cpu_down_callback at ffffff80080b5360
  #8 [ffffffc0ee9cbbc0] notifier_call_chain at ffffff80080b9c4c
  #9 [ffffffc0ee9cbc00] __raw_notifier_call_chain at ffffff80080b9cb8
#10 [ffffffc0ee9cbc10] __cpu_notify at ffffff800809eb50
#11 [ffffffc0ee9cbc20] _cpu_down at ffffff800809ee84
#12 [ffffffc0ee9cbca0] cpu_down at ffffff800809f124
#13 [ffffffc0ee9cbcd0] cpu_subsys_offline at ffffff800856b768
#14 [ffffffc0ee9cbce0] device_offline at ffffff8008567040
#15 [ffffffc0ee9cbd10] update_offline_cores at ffffff8008d74b54
#16 [ffffffc0ee9cbda0] do_hotplug at ffffff8008d75358
#17 [ffffffc0ee9cbe20] kthread at ffffff80080b8e3c



PID: 2      TASK: ffffffc0f9660c80  CPU: 4   COMMAND: "kthreadd"
  #0 [ffffffc0f9683bf0] __switch_to at ffffff800808553c
  #1 [ffffffc0f9683c20] __schedule at ffffff8008d76aa0
  #2 [ffffffc0f9683c80] schedule at ffffff8008d76e04
  #3 [ffffffc0f9683ca0] rwsem_down_read_failed at ffffff8008d79144
  #4 [ffffffc0f9683cf0] __percpu_down_read at ffffff80080edc4c
  #5 [ffffffc0f9683d10] copy_process at ffffff800809cecc
  #6 [ffffffc0f9683df0] _do_fork at ffffff800809d5a0
  #7 [ffffffc0f9683e50] kernel_thread at ffffff800809d89c
  #8 [ffffffc0f9683e60] kthreadd at ffffff80080b9714


PID: 898    TASK: ffffffc0ee910000  CPU: 0   COMMAND: "init"
  #0 [ffffffc06fd93980] __switch_to at ffffff800808553c
  #1 [ffffffc06fd939b0] __schedule at ffffff8008d76aa0
  #2 [ffffffc06fd93a10] schedule at ffffff8008d76e04
  #3 [ffffffc06fd93a30] schedule_preempt_disabled at ffffff8008d7714c
  #4 [ffffffc06fd93a50] __mutex_lock_slowpath at ffffff8008d78684
  #5 [ffffffc06fd93ab0] mutex_lock at ffffff8008d78714
  #6 [ffffffc06fd93ad0] cpuset_can_attach at ffffff800812d490
  #7 [ffffffc06fd93b20] cgroup_taskset_migrate at ffffff8008129194
  #8 [ffffffc06fd93b70] cgroup_migrate at ffffff8008129454
  #9 [ffffffc06fd93bf0] cgroup_attach_task at ffffff800812950c
#10 [ffffffc06fd93c50] __cgroup_procs_write at ffffff8008129884
#11 [ffffffc06fd93d10] cgroup_tasks_write at ffffff800812993c
#12 [ffffffc06fd93d20] cgroup_file_write at ffffff8008125078
#13 [ffffffc06fd93d70] kernfs_fop_write at ffffff800820bef4
#14 [ffffffc06fd93db0] __vfs_write at ffffff80081ac6f4
#15 [ffffffc06fd93e30] vfs_write at ffffff80081acf28
#16 [ffffffc06fd93e70] sys_write at ffffff80081ad6d8
#17 [ffffffc06fd93ed0] el0_svc_naked at ffffff800808462



PID: 66     TASK: ffffffc020dc7080  CPU: 5   COMMAND: "kworker/5:1"
  #0 [ffffffc0f7ff3a90] __switch_to at ffffff800808553c
  #1 [ffffffc0f7ff3ac0] __schedule at ffffff8008d76aa0
  #2 [ffffffc0f7ff3b20] schedule at ffffff8008d76e04
  #3 [ffffffc0f7ff3b40] schedule_preempt_disabled at ffffff8008d7714c
  #4 [ffffffc0f7ff3b60] __mutex_lock_slowpath at ffffff8008d78684
  #5 [ffffffc0f7ff3bc0] mutex_lock at ffffff8008d78714
  #6 [ffffffc0f7ff3be0] get_online_cpus at ffffff800809e9bc
  #7 [ffffffc0f7ff3c00] rebuild_sched_domains_locked at ffffff800812c960
  #8 [ffffffc0f7ff3cb0] rebuild_sched_domains at ffffff800812e7bc
  #9 [ffffffc0f7ff3cd0] cpuset_hotplug_workfn at ffffff800812eca8
#10 [ffffffc0f7ff3d70] process_one_work at ffffff80080b3cec
#11 [ffffffc0f7ff3dc0] worker_thread at ffffff80080b4700
#12 [ffffffc0f7ff3e20] kthread at ffffff80080b8e3c

I think, we can avoid this DEADLOCK with following sequence change.=20
Currently "kworker/5:1" thread which is executing the=20
cpuset_hotplug_workfn work function and this work item is queued as part=20
of hotplug notifier.
Can we change the cpuset_hotplug_workfn to take cpuhotplug mutex lock=20
first and then cpuset_mutex later?

I am testing with below change to reorder of these locks to avoid dead=20
locks and looking for suggestions/inputs.

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 29c7240..c3cde38 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -846,6 +846,22 @@ void rebuild_sched_domains(void)
         mutex_unlock(&cpuset_mutex);
  }

+void rebuild_sched_domains_unlocked(void)
+{
+       struct sched_domain_attr *attr;
+       cpumask_var_t *doms;
+       int ndoms;
+
+       if (!cpumask_equal(top_cpuset.effective_cpus, cpu_active_mask))
+               return;
+
+       /* Generate domain masks and attrs */
+       ndoms =3D generate_sched_domains(&doms, &attr);
+
+       /* Have scheduler rebuild the domains */
+       partition_sched_domains(ndoms, doms, attr);
+}
+
  /**
   * update_tasks_cpumask - Update the cpumasks of tasks in the cpuset.
   * @cs: the cpuset in which each task's cpus_allowed mask needs to be=20
changed
@@ -2316,6 +2332,7 @@ static void cpuset_hotplug_workfn(struct=20
work_struct *work)
         bool cpus_updated, mems_updated;
         bool on_dfl =3D cgroup_subsys_on_dfl(cpuset_cgrp_subsys);

+       get_online_cpus();
         mutex_lock(&cpuset_mutex);

         /* fetch the available cpus/mems and find out which changed how=20
*/
@@ -2366,9 +2383,13 @@ static void cpuset_hotplug_workfn(struct=20
work_struct *work)
                 rcu_read_unlock();
         }

+       mutex_lock(&cpuset_mutex);
         /* rebuild sched domains if cpus_allowed has changed */
         if (cpus_updated)
-               rebuild_sched_domains();
+               rebuild_sched_domains_unlocked();
+
+       mutex_unlock(&cpuset_mutex);
+       put_online_cpus();
  }


-Thanks, Prasad
--=20
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora=20
Forum,
Linux Foundation Collaborative Project
