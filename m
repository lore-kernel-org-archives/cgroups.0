From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] kthread, cgroup: close race window where new
        kthreads can be migrated to non-root cgroups
Date: Thu, 16 Mar 2017 16:39:26 +0100
Message-ID: <20170316153925.GA26391@redhat.com>
References: <20170315231827.GA13656@htj.duckdns.org> <20170315231920.GB13656@htj.duckdns.org> <20170316150233.GB24478@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com A0FFAC208096
Content-Disposition: inline
In-Reply-To: <20170316150233.GB24478-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 03/16, Oleg Nesterov wrote:
>
> On 03/15, Tejun Heo wrote:
> >
> > --- a/kernel/cgroup/cgroup.c
> > +++ b/kernel/cgroup/cgroup.c
> > @@ -2425,11 +2425,13 @@ ssize_t __cgroup_procs_write(struct kern
> >  		tsk = tsk->group_leader;
> >
> >  	/*
> > -	 * Workqueue threads may acquire PF_NO_SETAFFINITY and become
> > -	 * trapped in a cpuset, or RT worker may be born in a cgroup
> > -	 * with no rt_runtime allocated.  Just say no.
> > +	 * kthreads may acquire PF_NO_SETAFFINITY during initialization.
> > +	 * If userland migrates such kthread to a non-root cgroup, it can
> > +	 * become trapped in a cpuset, or RT kthread may be born in a
> > +	 * cgroup with no rt_runtime allocated.  Just say no.
> >  	 */
> > -	if (tsk == kthreadd_task || (tsk->flags & PF_NO_SETAFFINITY)) {
> > +	if (tsk == kthreadd_task || (tsk->flags & PF_NO_SETAFFINITY) ||
> > +	    ((tsk->flags & PF_KTHREAD) && !kthread_initialized(tsk))) {
> >  		ret = -EINVAL;
>
> ...
>
> > +bool kthread_initialized(struct task_struct *k)
> > +{
> > +	struct kthread *kthread = to_kthread(k);
> > +
> > +	return kthread && test_bit(KTHREAD_INITIALIZED, &kthread->flags);
> > +}
>
> Not sure I understand...
>
> With this patch you can no longer migrate a kernel thread created by
> kernel_thread() ? Note that to_kthread() is NULL unless it was created
> by kthread_create().

Either way, I am wondering if we can do something really trivial like
the patch below. This way we can also remove the "tsk == kthreadd_task"
check, and we do not need the barriers.

Oleg.

--- x/kernel/kthread.c
+++ x/kernel/kthread.c
@@ -226,6 +226,7 @@
 	ret = -EINTR;
 	if (!test_bit(KTHREAD_SHOULD_STOP, &self->flags)) {
 		__kthread_parkme(self);
+		current->flags &= ~PF_IDONTLIKECGROUPS;
 		ret = threadfn(data);
 	}
 	do_exit(ret);
@@ -537,7 +538,7 @@
 	set_cpus_allowed_ptr(tsk, cpu_all_mask);
 	set_mems_allowed(node_states[N_MEMORY]);
 
-	current->flags |= PF_NOFREEZE;
+	current->flags |= (PF_NOFREEZE | PF_IDONTLIKECGROUPS);
 
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
--- x/kernel/cgroup/cgroup.c
+++ x/kernel/cgroup/cgroup.c
@@ -2429,7 +2429,7 @@
 	 * trapped in a cpuset, or RT worker may be born in a cgroup
 	 * with no rt_runtime allocated.  Just say no.
 	 */
-	if (tsk == kthreadd_task || (tsk->flags & PF_NO_SETAFFINITY)) {
+	if (tsk->flags & (PF_NO_SETAFFINITY | PF_IDONTLIKECGROUPS)) {
 		ret = -EINVAL;
 		goto out_unlock_rcu;
 	}
