From: Chunyan Zhang <zhang.lyra@gmail.com>
Subject: Re: [PATCH] cpuset: adjust the lock sequence when rebuilding the
 sched domains.
Date: Thu, 5 Sep 2019 17:17:06 +0800
Message-ID: <CAAfSe-syJX-sF1HLxR5KsFzwbbL=LBGC=Y=aept+DBemY3ecPw@mail.gmail.com>
References: <20190905021808.25130-1-zhang.lyra@gmail.com> <20190905084326.GI5158@localhost.localdomain>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UEzW96NnDZLVFeOmLebkSAVAZHsop4TsUgaChKnNuos=;
        b=d7sadMNzByACQVKAUSpxwNbFK/fYCXuD4vsJjC8q/XwCp5JLelg1WyEHD25JSKkrZF
         si/fZJAJJipAJDZqMdzjzbvvw6C+D6uf3SkiT/2Ed+o9EiCNZlsvxBE5SpjuVsd6Hb78
         /Ux8A4GzAPBApKJQK4apxHbLcLkBTVACupR13D95H502r9sv+0JATcUd6Lluq21NS3cU
         /UqbkdWFvm5pmLLQiwFKFhny4vCZ/MdQOeNQ/NoxCs/SjhRrch7ewts2KfbCO3Iy4Dz5
         iElv0J8WNR0+gNyevOYd0yfsQJnnIqfXatTvLjxfIPCiinb6L9RW9X0/bezb7ERbbUYH
         cbXw==
In-Reply-To: <20190905084326.GI5158@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juri Lelli <juri.lelli@gmail.com>
Cc: Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Vincent Wang <vincent.wang@unisoc.com>, Peter Zijlstra <peterz@infradead.org>

On Thu, 5 Sep 2019 at 16:43, Juri Lelli <juri.lelli@gmail.com> wrote:
>
> Hi,
>
> On 05/09/19 10:18, Chunyan Zhang wrote:
> > From: Vincent Wang <vincent.wang@unisoc.com>
> >
> > A deadlock issue is found when executing a cpu hotplug stress test on
> > android phones with cpuset and scheduil enabled.
> >
> > When CPUx is plugged out, the hotplug thread that calls cpu_down()
> > will hold cpu_hotplug_lock and wait the thread cpuhp/x to finish
> > hotplug. If the core is the last one in a cluster, cpuhp/x have to
> > call cpuhp_cpufreq_offline() and the kernel thread sugov need to exit
> > for schedutil governor. The exit of sugov need to hold
> > cgroup_threadgroup_rwsem in exit_signals(). For example:
> >
> > PID: 150    TASK: ffffffc0b9cad080  CPU: 0   COMMAND: "sprdhotplug"
> >  #0 [ffffff8009fcb9d0] __switch_to at ffffff80080858f0
> >  #1 [ffffff8009fcb9f0] __schedule at ffffff80089f185c
> >  #2 [ffffff8009fcba80] schedule at ffffff80089f1b84
> >  #3 [ffffff8009fcbaa0] schedule_timeout at ffffff80089f5124
> >  #4 [ffffff8009fcbb40] wait_for_common at ffffff80089f2944
> >  #5 [ffffff8009fcbbe0] wait_for_completion at ffffff80089f29a4
> >  #6 [ffffff8009fcbc00] __cpuhp_kick_ap at ffffff80080ab030
> >  #7 [ffffff8009fcbc20] cpuhp_kick_ap_work at ffffff80080ab154
> >  #8 [ffffff8009fcbc70] _cpu_down at ffffff80089ee19c
> >  #9 [ffffff8009fcbcd0] cpu_down at ffffff80080ac144
> >
> > PID: 26     TASK: ffffffc0bbe22080  CPU: 3   COMMAND: "cpuhp/3"
> >  #0 [ffffff8009693a30] __switch_to at ffffff80080858f0
> >  #1 [ffffff8009693a50] __schedule at ffffff80089f185c
> >  #2 [ffffff8009693ae0] schedule at ffffff80089f1b84
> >  #3 [ffffff8009693b00] schedule_timeout at ffffff80089f5124
> >  #4 [ffffff8009693ba0] wait_for_common at ffffff80089f2944
> >  #5 [ffffff8009693c40] wait_for_completion at ffffff80089f29a4
> >  #6 [ffffff8009693c60] kthread_stop at ffffff80080ccd2c
> >  #7 [ffffff8009693c90] sugov_exit at ffffff8008102134
> >  #8 [ffffff8009693cc0] cpufreq_exit_governor at ffffff80086c03bc
> >  #9 [ffffff8009693ce0] cpufreq_offline at ffffff80086c0634
> >
> > PID: 13819  TASK: ffffffc0affb6080  CPU: 0   COMMAND: "sugov:3"
> >  #0 [ffffff800ee73c30] __switch_to at ffffff80080858f0
> >  #1 [ffffff800ee73c50] __schedule at ffffff80089f185c
> >  #2 [ffffff800ee73ce0] schedule at ffffff80089f1b84
> >  #3 [ffffff800ee73d00] rwsem_down_read_failed at ffffff80089f49d0
> >  #4 [ffffff800ee73d80] __percpu_down_read at ffffff8008102ebc
> >  #5 [ffffff800ee73da0] exit_signals at ffffff80080bbd24
> >  #6 [ffffff800ee73de0] do_exit at ffffff80080ae65c
> >  #7 [ffffff800ee73e60] kthread at ffffff80080cc550
> >
> > Sometimes cgroup_threadgroup_rwsem is hold by another thread, for
> > example Binder:681_2 on android, it wants to hold cpuset_mutex:
> >
> > PID: 732    TASK: ffffffc09668b080  CPU: 2   COMMAND: "Binder:681_2"
> >  #0 [ffffff800cb7b8c0] __switch_to at ffffff80080858f0
> >  #1 [ffffff800cb7b8e0] __schedule at ffffff80089f185c
> >  #2 [ffffff800cb7b970] schedule at ffffff80089f1b84
> >  #3 [ffffff800cb7b990] schedule_preempt_disabled at ffffff80089f205c
> >  #4 [ffffff800cb7b9a0] __mutex_lock at ffffff80089f3118
> >  #5 [ffffff800cb7ba40] __mutex_lock_slowpath at ffffff80089f3230
> >  #6 [ffffff800cb7ba60] mutex_lock at ffffff80089f3278
> >  #7 [ffffff800cb7ba80] cpuset_can_attach at ffffff8008152f84
> >  #8 [ffffff800cb7bae0] cgroup_migrate_execute at ffffff800814ada8
> >
> > On android, a thread kworker/3:0 will hold cpuset_mutex in
> > rebuild_sched_domains() and want to hold cpu_hotplug_lock which
> > is already hold by the hotplug thread.
> >
> > PID: 4847   TASK: ffffffc031a6a080  CPU: 3   COMMAND: "kworker/3:0"
> >  #0 [ffffff8016fd3ad0] __switch_to at ffffff80080858f0
> >  #1 [ffffff8016fd3af0] __schedule at ffffff80089f185c
> >  #2 [ffffff8016fd3b80] schedule at ffffff80089f1b84
> >  #3 [ffffff8016fd3ba0] rwsem_down_read_failed at ffffff80089f49d0
> >  #4 [ffffff8016fd3c20] __percpu_down_read at ffffff8008102ebc
> >  #5 [ffffff8016fd3c40] cpus_read_lock at ffffff80080aa59c
> >  #6 [ffffff8016fd3c50] rebuild_sched_domains_locked at ffffff80081522a8
> >
> > In order to fix the deadlock, this patch will adjust the lock sequence
> > when rebuilding sched domains. After stress tests, it works well.
> >
> > Signed-off-by: Vincent Wang <vincent.wang@unisoc.com>
> > Signed-off-by: Chunyan Zhang <zhang.lyra@gmail.com>
> > ---
> >  kernel/cgroup/cpuset.c | 9 ++++-----
> >  1 file changed, 4 insertions(+), 5 deletions(-)
> >
> > diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> > index 5aa37531ce76..ef10d276da22 100644
> > --- a/kernel/cgroup/cpuset.c
> > +++ b/kernel/cgroup/cpuset.c
> > @@ -912,7 +912,6 @@ static void rebuild_sched_domains_locked(void)
> >       int ndoms;
> >
> >       lockdep_assert_held(&cpuset_mutex);
> > -     get_online_cpus();
> >
> >       /*
> >        * We have raced with CPU hotplug. Don't do anything to avoid
> > @@ -921,19 +920,17 @@ static void rebuild_sched_domains_locked(void)
> >        */
> >       if (!top_cpuset.nr_subparts_cpus &&
> >           !cpumask_equal(top_cpuset.effective_cpus, cpu_active_mask))
> > -             goto out;
> > +             return;
> >
> >       if (top_cpuset.nr_subparts_cpus &&
> >          !cpumask_subset(top_cpuset.effective_cpus, cpu_active_mask))
> > -             goto out;
> > +             return;
> >
> >       /* Generate domain masks and attrs */
> >       ndoms = generate_sched_domains(&doms, &attr);
> >
> >       /* Have scheduler rebuild the domains */
> >       partition_sched_domains(ndoms, doms, attr);
> > -out:
> > -     put_online_cpus();
> >  }
> >  #else /* !CONFIG_SMP */
> >  static void rebuild_sched_domains_locked(void)
> > @@ -943,9 +940,11 @@ static void rebuild_sched_domains_locked(void)
> >
> >  void rebuild_sched_domains(void)
> >  {
> > +     get_online_cpus();
> >       mutex_lock(&cpuset_mutex);
> >       rebuild_sched_domains_locked();
> >       mutex_unlock(&cpuset_mutex);
> > +     put_online_cpus();
> >  }
>
> This looks a subset of d74b27d63a8b ("cgroup/cpuset: Change cpuset_rwsem
> and hotplug lock order") from
>
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched/core
>
> right?

Yes, seems that your patch is a more thorough solution :-)

>
> Cc-ing Peter for reference.
>
> Best,
>
> Juri
