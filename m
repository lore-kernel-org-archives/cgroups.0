From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] cgroup: remove tasklist_lock from cgroup_attach_proc
Date: Fri, 23 Dec 2011 03:41:24 +0100
Message-ID: <20111223024122.GC28309@somewhere.redhat.com>
References: <1324601873-20773-1-git-send-email-msb@chromium.org>
 <20111223022742.GA28309@somewhere.redhat.com>
 <4EF3EA1C.4000806@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=tP/zKFXcN/k+QASMMpD/AbM/YciYB0YUz6kHSCkZNBo=;
        b=ZWnvLbmpdDNXSR3tTZoBmqS0Alj3/vhvZd0SsgsLPDpedLsSpk6TfzTTZlZ2c1ib1Q
         HAvRQFFT6gh+m1I7Kz8lNvpBFFuowWzqzOLobQtBgc4WVDjnWT1/N0C9wXauLAfzJz+b
         oiUxyfBmbYeAg/KgPMaBOAO4oUcpgoJJMT61M=
Content-Disposition: inline
In-Reply-To: <4EF3EA1C.4000806-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>

On Fri, Dec 23, 2011 at 10:40:28AM +0800, Li Zefan wrote:
> >> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> >> index 1042b3c..032139d 100644
> >> --- a/kernel/cgroup.c
> >> +++ b/kernel/cgroup.c
> >> @@ -2102,21 +2102,6 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
> >>  	if (retval)
> >>  		goto out_free_group_list;
> >>  
> >> -	/* prevent changes to the threadgroup list while we take a snapshot. */
> >> -	read_lock(&tasklist_lock);
> >> -	if (!thread_group_leader(leader)) {
> >> -		/*
> >> -		 * a race with de_thread from another thread's exec() may strip
> >> -		 * us of our leadership, making while_each_thread unsafe to use
> >> -		 * on this task. if this happens, there is no choice but to
> >> -		 * throw this task away and try again (from cgroup_procs_write);
> >> -		 * this is "double-double-toil-and-trouble-check locking".
> >> -		 */
> >> -		read_unlock(&tasklist_lock);
> >> -		retval = -EAGAIN;
> >> -		goto out_free_group_list;
> >> -	}
> >> -
> >>  	tsk = leader;
> >>  	i = 0;
> >>  	do {
> >> @@ -2145,7 +2130,6 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
> >>  	group_size = i;
> >>  	tset.tc_array = group;
> >>  	tset.tc_array_len = group_size;
> >> -	read_unlock(&tasklist_lock);
> > 
> > You still need rcu_read_lock()/rcu_read_unlock() around
> > 	do {
> > 
> > 	} while_each_thread()
> > 
> > because threadgroup_lock() doesn't lock the part that remove a thread from
> > its group on exit.
> > 
> 
> and inside rcu critical section, you can't call kmalloc(GFP_KERNEL)!!

Good point. Well it's still worth replacing tasklist_lock by rcu though :)
