From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cgroup attach task - slogging cpu
Date: Thu, 10 Oct 2013 13:11:10 +0200
Message-ID: <20131010111110.GB22827@redhat.com>
References: <CALPf4Tz+Gf_Q7wKKBufCc1mtV1qVPVrOW0S1qhHxfOv6pJa2Kg@mail.gmail.com> <20131004130207.GA9338@redhat.com> <20131007184507.GD27396@htj.dyndns.org> <20131008145833.GA15600@redhat.com> <5254EB2A.7090803@huawei.com> <20131009133047.GA12414@redhat.com> <20131009140551.GA15849@redhat.com> <CAChhN7RerxpSadqyosUeSKFg+qcOpO4d-maEKBZ0rvOQGvN27g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAChhN7RerxpSadqyosUeSKFg+qcOpO4d-maEKBZ0rvOQGvN27g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Anjana V Kumar <anjanavk12-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, anjana vk <anjanvk12-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Anjana,

> On 10/10, Anjana V Kumar wrote:
> >
> >
> Problem:
> Issue when attaching a single thread to a cgroup if the thread was alredy in the
> cgroup. The check if the thread is already in cgroup in the above case,
> continues to the next thread instead of exciting.

Yes. Thanks.

> @@ -2047,7 +2047,7 @@ static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
>  		ent.cgrp = task_cgroup_from_root(tsk, root);
>  		/* nothing to do if this task is already in the cgroup */
>  		if (ent.cgrp == cgrp)
> -			continue;
> +			goto next_thread;
>  		/*
>  		 * saying GFP_ATOMIC has no effect here because we did prealloc
>  		 * earlier, but it's good form to communicate our expectations.
> @@ -2055,7 +2055,7 @@ static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
>  		retval = flex_array_put(group, i, &ent, GFP_ATOMIC);
>  		BUG_ON(retval != 0);
>  		i++;
> -
> +next_thread:

Yes, but you forgot to fix another "continue" after "ent.cgrp == cgrp" ;)

Oleg.
