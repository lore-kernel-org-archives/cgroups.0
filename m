From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroup attach task - slogging cpu
Date: Mon, 7 Oct 2013 14:45:07 -0400
Message-ID: <20131007184507.GD27396@htj.dyndns.org>
References: <CALPf4Tz+Gf_Q7wKKBufCc1mtV1qVPVrOW0S1qhHxfOv6pJa2Kg@mail.gmail.com>
 <20131004130207.GA9338@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=KsR/lfdOQubU2KcNli5VY6oLaeZPGdH6fZ//B4T5O5Y=;
        b=CZ55bsOeSS8HniCuDgX5X3sZ7MIWdE8WreYPfqSte+Qsq0iOOKe4vw8NCqLci8oxCQ
         e+qLWqekPACP5OluB3d0pcXhjFX+ccRhxCOPF7cW+96bjOnWgveanBy2iwr6FwPqCe0P
         +13b3o0RfymAIelm5AiBOIEPeJvPYecKXgXxoCYrPEQYZkbf+fKBZ7JiR4Mbg0O41Qnn
         usha/oABVvz407eg4YFqReMMpYSCvddKesEILcd6mbJd+rgKc5GVr1JvYoSccZK4V7MQ
         fZFo4xam3PvfFCAgYWNx7kjCLtz+B1SDolnqK/lROraY85qeYDNzObi94+cXg7RcQasT
         nPcQ==
Content-Disposition: inline
In-Reply-To: <20131004130207.GA9338-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: anjana vk <anjanvk12-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hey,

On Fri, Oct 04, 2013 at 03:02:07PM +0200, Oleg Nesterov wrote:
> Not sure I understand, but just in case: yes the lockless
> while_each_thread() is buggy and should be fixed (it should actually
> die eventually). And a lot of current users of while_each_thread()
> are themselves buggy and need the fixes no matter what we do with
> while_each_thread.
> 
> Oh. and just in case... I am (slowly) working on this, but didn't
> finish it yet, sorry.

Is there anything I can do to make the hang go away in the meantime?

> But I do not really understand cgroup_attach_task(), and I am not
> sure you observed the same problem. Add Tejun.

Sounds like the same problem to me.

> 	--- x/kernel/cgroup.c
> 	+++ x/kernel/cgroup.c
> 	@@ -2034,7 +2034,7 @@ static int cgroup_attach_task(struct cgr
> 		 * take an rcu_read_lock.
> 		 */
> 		rcu_read_lock();
> 	-	do {
> 	+	for_each_thread(leader->signal, task) {
> 			struct task_and_cgroup ent;
> 	 
> 			/* @tsk either already exited or can't exit until the end */
> 	@@ -2058,7 +2058,7 @@ static int cgroup_attach_task(struct cgr
> 	 
> 			if (!threadgroup)
> 				break;
> 	-	} while_each_thread(leader, tsk);
> 	+	}
> 		rcu_read_unlock();
> 		/* remember the number of threads in the array for later. */
> 		group_size = i;
> 
> after we add for_each_thread/etc. But I am not sure we need another
> "threadgroup" check.

...
> > diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> > index 1f53387..cae8416 100644
> > --- a/kernel/cgroup.c
> > +++ b/kernel/cgroup.c
> > @@ -2002,7 +2002,9 @@ static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
> >  		ent.task = tsk;
> >  		ent.cgrp = task_cgroup_from_root(tsk, root);
> >  		/* nothing to do if this task is already in the cgroup */
> > -		if (ent.cgrp == cgrp)
> > +		if (ent.cgrp == cgrp && !threadgroup)
> > +			break;
> > +		else if(ent.cgrp == cgrp)
> >  			continue;

I have no idea know how this would make any difference.  Hmm...

Thanks.

-- 
tejun
