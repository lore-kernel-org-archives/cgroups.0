From: Joel Savitz <jsavitz@redhat.com>
Subject: Re: [PATCH] cpuset: restore sanity to cpuset_cpus_allowed_fallback()
Date: Tue, 26 Mar 2019 13:32:59 -0400
Message-ID: <CAL1p7m6e8KgfM79+biL0HPRofnaghJmrUdX6zX4b0ef=cYbEdg@mail.gmail.com>
References: <1551920088-30685-1-git-send-email-jsavitz@redhat.com>
 <CAL1p7m5e6HwFQVur+XVKWnpoMRPg0qFs0QkJ_5mnkUoxG_gwMw@mail.gmail.com> <CAL1p7m7n7+wwHsrxywnUYpOKvT6N+5ewCjaZXLPLCsBk+t+oNw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAL1p7m7n7+wwHsrxywnUYpOKvT6N+5ewCjaZXLPLCsBk+t+oNw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org, Philip Auld <pauld@redhat.com>

Forgot to add cc's... my bad.

Best,
Joel Savitz

On Tue, Mar 26, 2019 at 1:31 PM Joel Savitz <jsavitz@redhat.com> wrote:
>
> Ping!
>
> Does anyone have any comments or concerns about this patch?
>
> Best,
> Joel Savitz
>
> Best,
> Joel Savitz
>
>
> On Thu, Mar 7, 2019 at 9:42 AM Joel Savitz <jsavitz@redhat.com> wrote:
> >
> > On Wed, Mar 6, 2019 at 7:55 PM Joel Savitz <jsavitz@redhat.com> wrote:
> > >
> > > If a process is limited by taskset (i.e. cpuset) to only be allowed to
> > > run on cpu N, and then cpu N is offlined via hotplug, the process will
> > > be assigned the current value of its cpuset cgroup's effective_cpus field
> > > in a call to do_set_cpus_allowed() in cpuset_cpus_allowed_fallback().
> > > This argument's value does not makes sense for this case, because
> > > task_cs(tsk)->effective_cpus is modified by cpuset_hotplug_workfn()
> > > to reflect the new value of cpu_active_mask after cpu N is removed from
> > > the mask. While this may make sense for the cgroup affinity mask, it
> > > does not make sense on a per-task basis, as a task that was previously
> > > limited to only be run on cpu N will be limited to every cpu _except_ for
> > > cpu N after it is offlined/onlined via hotplug.
> > >
> > > Pre-patch behavior:
> > >
> > >         $ grep Cpus /proc/$$/status
> > >         Cpus_allowed:   ff
> > >         Cpus_allowed_list:      0-7
> > >
> > >         $ taskset -p 4 $$
> > >         pid 19202's current affinity mask: f
> > >         pid 19202's new affinity mask: 4
> > >
> > >         $ grep Cpus /proc/self/status
> > >         Cpus_allowed:   04
> > >         Cpus_allowed_list:      2
> > >
> > >         # echo off > /sys/devices/system/cpu/cpu2/online
> > >         $ grep Cpus /proc/$$/status
> > >         Cpus_allowed:   0b
> > >         Cpus_allowed_list:      0-1,3
> > >
> > >         # echo on > /sys/devices/system/cpu/cpu2/online
> > >         $ grep Cpus /proc/$$/status
> > >         Cpus_allowed:   0b
> > >         Cpus_allowed_list:      0-1,3
> > >
> > > On a patched system, the final grep produces the following
> > > output instead:
> > >
> > >         $ grep Cpus /proc/$$/status
> > >         Cpus_allowed:   ff
> > >         Cpus_allowed_list:      0-7
> > >
> > > This patch changes the above behavior by instead simply resetting the mask
> > > to cpu_possible_mask.
> > >
> > > Signed-off-by: Joel Savitz <jsavitz@redhat.com>
> > > ---
> > >  kernel/cgroup/cpuset.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> > > index 479743db6c37..5f65a2167bdf 100644
> > > --- a/kernel/cgroup/cpuset.c
> > > +++ b/kernel/cgroup/cpuset.c
> > > @@ -3243,7 +3243,7 @@ void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
> > >  void cpuset_cpus_allowed_fallback(struct task_struct *tsk)
> > >  {
> > >         rcu_read_lock();
> > > -       do_set_cpus_allowed(tsk, task_cs(tsk)->effective_cpus);
> > > +       do_set_cpus_allowed(tsk, cpu_possible_mask);
> > >         rcu_read_unlock();
> > >
> > >         /*
> > > --
> > > 2.20.1
> > >
