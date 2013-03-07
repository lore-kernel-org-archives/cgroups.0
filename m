From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: lockdep trace from prepare_bprm_creds
Date: Thu, 7 Mar 2013 20:12:42 +0100
Message-ID: <20130307191242.GA18265@redhat.com>
References: <20130306223657.GA7392@redhat.com> <20130307172545.GA10353@redhat.com> <20130307180139.GD29601@htj.dyndns.org> <20130307180332.GE29601@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130307180332.GE29601-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 03/07, Tejun Heo wrote:
>
> > > Or perhaps we can? It doesn't need to sleep under ->group_rwsem, we only
> > > need it around ->group_leader changing. Otherwise cgroup_attach_proc()
> > > can rely on do_exit()->threadgroup_change_begin() ?
> >
> > Using cred_guard_mutex was mostly to avoid adding another locking in
> > de_thread() path as it already had one.

Well yes, I agree. I think that perfomance-wise threadgroup_change_begin()
in de_thread() is fine, and perhaps it is even more clean because we are
going to do the thread-group change. The scope of cred_guard_mutex is huge,
it doesn't look very nice in threadgroup_lock().

But we should avoid the cgroup-specific hooks as much as possible, so I
like your patch more.

> +	if (threadgroup && !thread_group_leader(tsk)) {
> +		/*
> +		 * a race with de_thread from another thread's exec() may
> +		 * strip us of our leadership, if this happens, there is no
> +		 * choice but to throw this task away and try again; this
> +		 * is "double-double-toil-and-trouble-check locking".
> +		 */
> +		threadgroup_unlock(tsk);
> +		put_task_struct(tsk);
> +		goto retry_find_task;
> +	}
>
> +	ret = -ENODEV;
> +	if (cgroup_lock_live_group(cgrp)) {
> +		if (threadgroup)
> +			ret = cgroup_attach_proc(cgrp, tsk);

Offtopic, but with or without this change I do not understand the
thread_group_leader/retry_find_task logic.

Why do we actually need to restart? We do not really care if it is leader
or not, we only need to ensure we can safely use while_each_thread() to
find all !PF_EXITING threads.

And ignoring the fact that while_each_thread() itself can race with
exec (but this should be fixed anyway), cgroup_attach_proc() could
simply check pid_alive() under rcu_read_lock().

IOW, I no longer understand why do we need ->cred_guard_mutex.
I must have missed something...

Oleg.
