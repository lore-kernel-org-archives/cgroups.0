From: Jing-Ting Wu <jing-ting.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: BUG: HANG_DETECT waiting for migration_cpu_stop() complete
Date: Mon, 5 Sep 2022 10:47:36 +0800
Message-ID: <88b2910181bda955ac46011b695c53f7da39ac47.camel@mediatek.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:Date:CC:To:From:Subject:Message-ID; bh=SPZom6e4m2DwhVGUgCYsOooFFaI6jPFzv+CbKS3SeiE=;
        b=FuOO+lR0kcjnnoOqg8R88BKGO4Ch702JrZNpT41Il53R5YqzmMyAr+YfTxwu49cWoHTsXdWSha8PM4HgtI9iKHm/3TzfysGIaTdyIwc2QGcWgD4ProghQqFVzEa8veZyYmDxGfDF9FjvAWp4XyHeBk503uTP8eNa8ZOsDzOY+CA=;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: wsd_upstream-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Jonathan.JMChen-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, "chris.redpath-5wv7dgnIgG8@public.gmane.org" <chris.redpath-5wv7dgnIgG8@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Vincent Donnefort <vdonnefort-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lixiong.liu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, wenju.xu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org

Hi,

We meet the HANG_DETECT happened in T SW version with kernel-5.15.
Many tasks have been blocked for a long time.


Root cause:
migration_cpu_stop() is not complete due to is_migration_disabled(p) is
true, complete is false and complete_all() never get executed.
It let other task wait the rwsem.

Detail:
system_server waiting for cgroup_threadgroup_rwsem.
OomAdjuster is holding the cgroup_threadgroup_rwsem and waiting for
cpuset_rwsem.
cpuset_hotplug_workfn is holding the cpuset_rwsem and waiting for
affine_move_task() complete.
affine_move_task() waiting for migration_cpu_stop() complete.

The backtrace of system_server:
__switch_to
__schedule
schedule
percpu_rwsem_wait
__percpu_down_read
cgroup_css_set_fork => wait for cgroup_threadgroup_rwsem
cgroup_can_fork
copy_process
kernel_clone

The backtrace of OomAdjuster:
__switch_to
__schedule
schedule
percpu_rwsem_wait
percpu_down_write
cpuset_can_attach => wait for cpuset_rwsem
cgroup_migrate_execute
cgroup_attach_task
__cgroup1_procs_write => hold cgroup_threadgroup_rwsem
cgroup1_procs_write
cgroup_file_write
kernfs_fop_write_iter
vfs_write
ksys_write

The backtrace of cpuset_hotplug_workfn:
__switch_to
__schedule
schedule
schedule_timeout
wait_for_common
affine_move_task => wait for complete
__set_cpus_allowed_ptr_locked
update_tasks_cpumask
cpuset_hotplug_update_tasks => hold cpuset_rwsem
cpuset_hotplug_workfn
process_one_work
worker_thread
kthread


In affine_move_task() will call migration_cpu_stop() and wait for it
complete.
In normal case, if migration_cpu_stop() complete it will inform
everyone that he is done.
But there is an exception case that will not notify.
If is_migration_disabled(p) is true and complete will always is false,
then complete_all() never get executed.

static int migration_cpu_stop(void *data)
{
...
    bool complete = false;
...

    if (task_rq(p) == rq) {
        if (is_migration_disabled(p))
              goto out; => is_migration_disabled(p) = true,
                           so complete = false.
            ...
        }
...

out:
...
    if (complete) => complete = false,
                     so complete_all() never get executed.
        complete_all(&pending->done);

        return 0;
}


Review the code, we found that there are many places can change
is_migration_disabled() value.
(such as: __rt_spin_lock(), rt_read_lock(), rt_write_lock(), ...)

Do you have any suggestion for this issue?
Thank you.




Best regards,
Jing-Ting Wu


