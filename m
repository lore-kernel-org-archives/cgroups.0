From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: lockdep trace from prepare_bprm_creds
Date: Thu, 7 Mar 2013 11:38:20 -0800
Message-ID: <20130307193820.GB3209@htj.dyndns.org>
References: <20130306223657.GA7392@redhat.com>
 <20130307172545.GA10353@redhat.com>
 <20130307180139.GD29601@htj.dyndns.org>
 <20130307180332.GE29601@htj.dyndns.org>
 <20130307191242.GA18265@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=qQlO7V3z++l98P5e261SFhYyKjYwkTjtRVxZ4I4GiAo=;
        b=svQga+qXlLpCHyU59KeHp0prcCAlrUiUIZFYaxtm0uqswb7eSRcHFZwHK0b6/jJveO
         ffTOo4UXkP07bS50/4OgM0r5b6hcAMFaiNR+rRR+L+uotA6NKVRU5klFf0KYdUGamuLF
         AmC+r55D8JjKZJnLGM+XNHwnR3wvprL/f49CvoP8sxDnN6dnk4sbWriP43/mzgDHWLbc
         OsOJmmckFuZ/ywtCw44SAmzfdfs3oetCpiqGOzhUoleIXwsjhf78k8vN3QbnZA4ku+Ag
         ZxH35zLpMlxzA3Z3Tl+Q+PQiRTnwq7ncK5Bz8TM27vPIZ886lXR+ghvPKCavEZ4JEOUF
         c47A==
Content-Disposition: inline
In-Reply-To: <20130307191242.GA18265-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Thu, Mar 07, 2013 at 08:12:42PM +0100, Oleg Nesterov wrote:
> Well yes, I agree. I think that perfomance-wise threadgroup_change_begin()
> in de_thread() is fine, and perhaps it is even more clean because we are
> going to do the thread-group change. The scope of cred_guard_mutex is huge,
> it doesn't look very nice in threadgroup_lock().
> 
> But we should avoid the cgroup-specific hooks as much as possible, so I
> like your patch more.

I don't really mind how it's done but while my approach seems to limit
itself to cgroup proper, threadgroup locking is actually more invasive
by meddling with cred_mutex.  As you said, yours is the cleaner and
probably more permanent one here.

> > +	if (threadgroup && !thread_group_leader(tsk)) {
> > +		/*
> > +		 * a race with de_thread from another thread's exec() may
> > +		 * strip us of our leadership, if this happens, there is no
> > +		 * choice but to throw this task away and try again; this
> > +		 * is "double-double-toil-and-trouble-check locking".
> > +		 */
> > +		threadgroup_unlock(tsk);
> > +		put_task_struct(tsk);
> > +		goto retry_find_task;
> > +	}
> >
> > +	ret = -ENODEV;
> > +	if (cgroup_lock_live_group(cgrp)) {
> > +		if (threadgroup)
> > +			ret = cgroup_attach_proc(cgrp, tsk);
> 
> Offtopic, but with or without this change I do not understand the
> thread_group_leader/retry_find_task logic.
> 
> Why do we actually need to restart? We do not really care if it is leader
> or not, we only need to ensure we can safely use while_each_thread() to
> find all !PF_EXITING threads.

If my memory serves me right (which BTW often fails), it's cgroup API
thing.  cgroup wants to guarantee to the controllers that if multiple
tasks are migrated together, they always constitute a threadgroup and
the first one is the leader.  ISTR a controller callback which depends
on the first one being the leader.

Thanks.

-- 
tejun
