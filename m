From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cgroup attach task - slogging cpu
Date: Tue, 8 Oct 2013 16:58:33 +0200
Message-ID: <20131008145833.GA15600@redhat.com>
References: <CALPf4Tz+Gf_Q7wKKBufCc1mtV1qVPVrOW0S1qhHxfOv6pJa2Kg@mail.gmail.com> <20131004130207.GA9338@redhat.com> <20131007184507.GD27396@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131007184507.GD27396-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: anjana vk <anjanvk12-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 10/07, Tejun Heo wrote:
>
> Hey,
>
> On Fri, Oct 04, 2013 at 03:02:07PM +0200, Oleg Nesterov wrote:
> > Not sure I understand, but just in case: yes the lockless
> > while_each_thread() is buggy and should be fixed (it should actually
> > die eventually). And a lot of current users of while_each_thread()
> > are themselves buggy and need the fixes no matter what we do with
> > while_each_thread.
> >
> > Oh. and just in case... I am (slowly) working on this, but didn't
> > finish it yet, sorry.
>
> Is there anything I can do to make the hang go away in the meantime?

well, probably tasklist, or pid_alive() check... note that this code
rcu/while_each_thread() logic looks wrong even if while_each_thread()
was fine. Will try to makes a patch today.

But! Anjana! I am so sorry!! I simply can't understand how I managed
to misunderstand (and confuse!) you.

Tejun, could you please look at the patch from Anjana again?


> > > --- a/kernel/cgroup.c
> > > +++ b/kernel/cgroup.c
> > > @@ -2002,7 +2002,9 @@ static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
> > >  		ent.task = tsk;
> > >  		ent.cgrp = task_cgroup_from_root(tsk, root);
> > >  		/* nothing to do if this task is already in the cgroup */
> > > -		if (ent.cgrp == cgrp)
> > > +		if (ent.cgrp == cgrp && !threadgroup)
> > > +			break;
> > > +		else if(ent.cgrp == cgrp)
> > >  			continue;
>
> I have no idea know how this would make any difference.  Hmm...

I guess the patch needs a cleanup, but this code looks indeed wrong
even if we forget about rcu/while_each_thread? Really, we should not
"continue" if threadgroup == T, in this case we miss the last

		if (!threadgroup)
			break;

check in the main loop. So Anjana was right (sorry again!), and we
should probably do

		ent.cgrp = task_cgroup_from_root(...);
		if (ent.cgrp != cgrp) {
			retval = flex_array_put(...);
			...
		}

		if (!threadgroup)
			break;

Or I am wrong again?

Oleg.
