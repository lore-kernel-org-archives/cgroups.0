From: Xuewen Yan <xuewen.yan94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH cgroup/for-6.0-fixes] cgroup: Fix threadgroup_rwsem <->
 cpus_read_lock() deadlock
Date: Wed, 17 Aug 2022 14:55:26 +0800
Message-ID: <CAB8ipk8YAyLrH=+BDkekur0nZKx-i3Nn+nyyHi46xUnXpm32tA@mail.gmail.com>
References: <bbc01477-231b-3dbb-3e09-9338f5413f06@oracle.com>
 <ba48eac5-8ef7-251b-11fe-8163bb7a2d54@quicinc.com> <224b19f3-912d-b858-7af4-185b8e55bc66@quicinc.com>
 <YthDz4BnfYHce1od@slm.duckdns.org> <YuGTBLkFerUboctl@slm.duckdns.org>
 <dc0cff0e-b744-9d5d-e727-70d1c31b2a74@quicinc.com> <20220815090556.GB27407@blackbody.suse.cz>
 <CAB8ipk90LxNNbq5OKamd-ArkqhEZjxS1fFZJXtnbQwGzyyJ3wQ@mail.gmail.com>
 <20220815093934.GA29323@blackbody.suse.cz> <f584fecd-6ca4-4ab0-763d-2ed219009c61@quicinc.com>
 <YvrWaml3F+x9Dk+T@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=VOpSjjXSrOl6CgX0507YWSBo7n2ojbse/8iZcix0Ud8=;
        b=H9hZ5UidPGHsMxCngxat9sXuPd5vY/MZbKUBgOFusBGxqP0OgskxtJiYvB5cV3dmWo
         yPxkuE9oxiSb9J/qLLA/qEEJz8AqgQRzMSpl7GFsS6yFdMEObCYXT/jPAIcEzS2kLLo0
         o7lkuwjskAXv1Fn1dTkfN8VFl/6lENGPJowYNRm26TnTMZgiOxbjXj1L3FYGvPfGknI+
         Ft4r3IU20jwYFzxVM8n5zvd0LBRgeWDI7RoSAF0SCwWq3QOyuBRayYVb5+fS6Z21wa+6
         ikyvMwNyxrZnDFqjaAqzAf+537v1yw/y3pWAxtZuNxyuTgpZ4wqUGXj6/TMeFUWfEgZ5
         fSFw==
In-Reply-To: <YvrWaml3F+x9Dk+T-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mukesh Ojha <quic_mojha-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Imran Khan <imran.f.khan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, steven.price-5wv7dgnIgG8@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zhao Gongyi <zhaogongyi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Zhang Qiao <zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, =?UTF-8?B?546L56eRIChLZSBXYW5nKQ==?= <Ke.Wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, "orson.zhai-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org" <orson.zhai-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Xuewen Yan <xuewen.yan-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>

Hi Tejun

On Tue, Aug 16, 2022 at 7:27 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Bringing up a CPU may involve creating new tasks which requires read-lock=
ing
> threadgroup_rwsem, so threadgroup_rwsem nests inside cpus_read_lock().

Indeed, it is creating new kthreads. And not only creating new
kthread, but also destroying kthread. the backtrace is:

__switch_to
__schedule
schedule
percpu_rwsem_wait   <<< wait for cgroup_threadgroup_rwsem
__percpu_down_read
exit_signals
do_exit
kthread

> However, cpuset's ->attach(), which may be called with thredagroup_rwsem
> write-locked, also wants to disable CPU hotplug and acquires
> cpus_read_lock(), leading to a deadlock.
>
> Fix it by guaranteeing that ->attach() is always called with CPU hotplug
> disabled and removing cpus_read_lock() call from cpuset_attach().
>
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
> Hello, sorry about the delay.
>
> So, the previous patch + the revert isn't quite correct because we someti=
mes
> elide both cpus_read_lock() and threadgroup_rwsem together and
> cpuset_attach() woudl end up running without CPU hotplug enabled. Can you
> please test whether this patch fixes the problem?
>
> Thanks.
>
>  kernel/cgroup/cgroup.c |   77 ++++++++++++++++++++++++++++++++++--------=
-------
>  kernel/cgroup/cpuset.c |    3 -
>  2 files changed, 55 insertions(+), 25 deletions(-)
>
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index ffaccd6373f1e..52502f34fae8c 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -2369,6 +2369,47 @@ int task_cgroup_path(struct task_struct *task, cha=
r *buf, size_t buflen)
>  }
>  EXPORT_SYMBOL_GPL(task_cgroup_path);
>
> +/**
> + * cgroup_attach_lock - Lock for ->attach()
> + * @lock_threadgroup: whether to down_write cgroup_threadgroup_rwsem
> + *
> + * cgroup migration sometimes needs to stabilize threadgroups against fo=
rks and
> + * exits by write-locking cgroup_threadgroup_rwsem. However, some ->atta=
ch()
> + * implementations (e.g. cpuset), also need to disable CPU hotplug.
> + * Unfortunately, letting ->attach() operations acquire cpus_read_lock()=
 can
> + * lead to deadlocks.
> + *
> + * Bringing up a CPU may involve creating new tasks which requires read-=
locking

Is it better to change to creating new kthreads and destroying kthreads?

> + * threadgroup_rwsem, so threadgroup_rwsem nests inside cpus_read_lock()=
. If we
> + * call an ->attach() which acquires the cpus lock while write-locking
> + * threadgroup_rwsem, the locking order is reversed and we end up waitin=
g for an
> + * on-going CPU hotplug operation which in turn is waiting for the
> + * threadgroup_rwsem to be released to create new tasks. For more detail=
s:
> + *
> + *   http://lkml.kernel.org/r/20220711174629.uehfmqegcwn2lqzu@wubuntu
> + *
> + * Resolve the situation by always acquiring cpus_read_lock() before opt=
ionally
> + * write-locking cgroup_threadgroup_rwsem. This allows ->attach() to ass=
ume that
> + * CPU hotplug is disabled on entry.
> + */
> +static void cgroup_attach_lock(bool lock_threadgroup)
> +{
> +       cpus_read_lock();
> +       if (lock_threadgroup)
> +               percpu_down_write(&cgroup_threadgroup_rwsem);
> +}
> +
> +/**
> + * cgroup_attach_unlock - Undo cgroup_attach_lock()
> + * @lock_threadgroup: whether to up_write cgroup_threadgroup_rwsem
> + */
> +static void cgroup_attach_unlock(bool lock_threadgroup)
> +{
> +       if (lock_threadgroup)
> +               percpu_up_write(&cgroup_threadgroup_rwsem);
> +       cpus_read_unlock();
> +}
> +
>  /**
>   * cgroup_migrate_add_task - add a migration target task to a migration =
context
>   * @task: target task
> @@ -2841,8 +2882,7 @@ int cgroup_attach_task(struct cgroup *dst_cgrp, str=
uct task_struct *leader,
>  }
>
>  struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup=
,
> -                                            bool *locked)
> -       __acquires(&cgroup_threadgroup_rwsem)
> +                                            bool *threadgroup_locked)
>  {
>         struct task_struct *tsk;
>         pid_t pid;
> @@ -2859,12 +2899,8 @@ struct task_struct *cgroup_procs_write_start(char =
*buf, bool threadgroup,
>          * Therefore, we can skip the global lock.
>          */
>         lockdep_assert_held(&cgroup_mutex);
> -       if (pid || threadgroup) {
> -               percpu_down_write(&cgroup_threadgroup_rwsem);
> -               *locked =3D true;
> -       } else {
> -               *locked =3D false;
> -       }
> +       *threadgroup_locked =3D pid || threadgroup;
> +       cgroup_attach_lock(*threadgroup_locked);
>
>         rcu_read_lock();
>         if (pid) {
> @@ -2895,17 +2931,14 @@ struct task_struct *cgroup_procs_write_start(char=
 *buf, bool threadgroup,
>         goto out_unlock_rcu;
>
>  out_unlock_threadgroup:
> -       if (*locked) {
> -               percpu_up_write(&cgroup_threadgroup_rwsem);
> -               *locked =3D false;
> -       }
> +       cgroup_attach_unlock(*threadgroup_locked);
> +       *threadgroup_locked =3D false;
>  out_unlock_rcu:
>         rcu_read_unlock();
>         return tsk;
>  }
>
> -void cgroup_procs_write_finish(struct task_struct *task, bool locked)
> -       __releases(&cgroup_threadgroup_rwsem)
> +void cgroup_procs_write_finish(struct task_struct *task, bool threadgrou=
p_locked)
>  {
>         struct cgroup_subsys *ss;
>         int ssid;
> @@ -2913,8 +2946,8 @@ void cgroup_procs_write_finish(struct task_struct *=
task, bool locked)
>         /* release reference from cgroup_procs_write_start() */
>         put_task_struct(task);
>
> -       if (locked)
> -               percpu_up_write(&cgroup_threadgroup_rwsem);
> +       cgroup_attach_unlock(threadgroup_locked);
> +
>         for_each_subsys(ss, ssid)
>                 if (ss->post_attach)
>                         ss->post_attach();
> @@ -3000,8 +3033,7 @@ static int cgroup_update_dfl_csses(struct cgroup *c=
grp)
>          * write-locking can be skipped safely.
>          */
>         has_tasks =3D !list_empty(&mgctx.preloaded_src_csets);
> -       if (has_tasks)
> -               percpu_down_write(&cgroup_threadgroup_rwsem);
> +       cgroup_attach_lock(has_tasks);
>
>         /* NULL dst indicates self on default hierarchy */
>         ret =3D cgroup_migrate_prepare_dst(&mgctx);
> @@ -3022,8 +3054,7 @@ static int cgroup_update_dfl_csses(struct cgroup *c=
grp)
>         ret =3D cgroup_migrate_execute(&mgctx);
>  out_finish:
>         cgroup_migrate_finish(&mgctx);
> -       if (has_tasks)
> -               percpu_up_write(&cgroup_threadgroup_rwsem);
> +       cgroup_attach_unlock(has_tasks);

In kernel5.15, I just set cgroup_attach_lock/unlock(true).

>         return ret;
>  }
>
> @@ -4971,13 +5002,13 @@ static ssize_t __cgroup_procs_write(struct kernfs=
_open_file *of, char *buf,
>         struct task_struct *task;
>         const struct cred *saved_cred;
>         ssize_t ret;
> -       bool locked;
> +       bool threadgroup_locked;
>
>         dst_cgrp =3D cgroup_kn_lock_live(of->kn, false);
>         if (!dst_cgrp)
>                 return -ENODEV;
>
> -       task =3D cgroup_procs_write_start(buf, threadgroup, &locked);
> +       task =3D cgroup_procs_write_start(buf, threadgroup, &threadgroup_=
locked);
>         ret =3D PTR_ERR_OR_ZERO(task);
>         if (ret)
>                 goto out_unlock;
> @@ -5003,7 +5034,7 @@ static ssize_t __cgroup_procs_write(struct kernfs_o=
pen_file *of, char *buf,
>         ret =3D cgroup_attach_task(dst_cgrp, task, threadgroup);
>
>  out_finish:
> -       cgroup_procs_write_finish(task, locked);
> +       cgroup_procs_write_finish(task, threadgroup_locked);
>  out_unlock:
>         cgroup_kn_unlock(of->kn);
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 58aadfda9b8b3..1f3a55297f39d 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2289,7 +2289,7 @@ static void cpuset_attach(struct cgroup_taskset *ts=
et)
>         cgroup_taskset_first(tset, &css);
>         cs =3D css_cs(css);
>
> -       cpus_read_lock();
> +       lockdep_assert_cpus_held();     /* see cgroup_attach_lock() */
>         percpu_down_write(&cpuset_rwsem);
>
>         guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
> @@ -2343,7 +2343,6 @@ static void cpuset_attach(struct cgroup_taskset *ts=
et)
>                 wake_up(&cpuset_attach_wq);
>
>         percpu_up_write(&cpuset_rwsem);
> -       cpus_read_unlock();
>  }
>
>  /* The various types of files and directories in a cpuset file system */

I backported your patch. to kernel5.4 and kernel5.15, and just setting
cgroup_attach_lock/unlock(true) when there are conflicts.
And the deadlock has not occured.

Reported-and-tested-by: Xuewen Yan <xuewen.yan-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>

Thanks=EF=BC=81
