From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/4] cgroup: remove extra calls to find_existing_css_set
Date: Thu, 22 Dec 2011 10:44:39 +0100
Message-ID: <20111222094437.GO17668@somewhere>
References: <1324527518-24461-1-git-send-email-msb@chromium.org>
 <1324527518-24461-4-git-send-email-msb@chromium.org>
 <4EF2C536.7070408@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=hRG6sgrKN9G9Mj5gDn5SWj35GfXdWJSdFlA3x49NJRI=;
        b=RIhItL787/10XjCmHgxCNvUvE7fwWBbyfz8sWgafWMpGDVPHEVJ+Jgl1i6jN/8y3o9
         VyUNDIXGhEMVrA6Ues/GvexHaUKuyjlYpiW97f8CHVBlp2Lbe7h725Z9M+/Yj62Z6XJu
         yzfS1lFrVdRMlHrB6FJyDq1PJUA2VEYY1/QS0=
Content-Disposition: inline
In-Reply-To: <4EF2C536.7070408-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>

On Thu, Dec 22, 2011 at 01:50:46PM +0800, Li Zefan wrote:
> > @@ -2091,6 +2010,10 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
> >  	 * rcu or tasklist locked. instead, build an array of all threads in the
> >  	 * group - group_rwsem prevents new threads from appearing, and if
> >  	 * threads exit, this will just be an over-estimate.
> > +	 *
> > +	 * While creating the list, also make sure css_sets exist for all
> > +	 * threads to be migrated. we use find_css_set, which allocates a new
> > +	 * one if necessary.
> >  	 */
> >  	group_size = get_nr_threads(leader);
> >  	/* flex_array supports very large thread-groups better than kmalloc. */
> > @@ -2137,6 +2060,12 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
> >  		/* nothing to do if this task is already in the cgroup */
> >  		if (ent.cgrp == cgrp)
> >  			continue;
> > +		ent.cg = find_css_set(tsk->cgroups, cgrp);
> 
> unfortunately This won't work, because we are holding tasklist_lock.

I believe we can remove tasklist_lock now (in a seperate patch).

It was there in order to protect while_each_thread() against exec but
now we have threadgroup_lock().

I think we only need to use rcu_read_lock() to protect against concurrent
removal in exit.
 
> > +		if (!ent.cg) {
> > +			retval = -ENOMEM;
> > +			group_size = i;
> > +			goto out_list_teardown;
> > +		}
> >  		retval = flex_array_put(group, i, &ent, GFP_ATOMIC);
> >  		BUG_ON(retval != 0);
> >  		i++;
