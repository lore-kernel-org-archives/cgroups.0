From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cgroup attach task - slogging cpu
Date: Fri, 4 Oct 2013 15:02:07 +0200
Message-ID: <20131004130207.GA9338@redhat.com>
References: <CALPf4Tz+Gf_Q7wKKBufCc1mtV1qVPVrOW0S1qhHxfOv6pJa2Kg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALPf4Tz+Gf_Q7wKKBufCc1mtV1qVPVrOW0S1qhHxfOv6pJa2Kg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: anjana vk <anjanvk12-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello Anjana,

On 10/04, anjana vk wrote:
>
> I saw an issue of CPU slogging posted in
> https://lkml.org/lkml/2013/8/28/283, and require your valuable
> suggestion on a very similar issue I am facing.

Not sure I understand, but just in case: yes the lockless
while_each_thread() is buggy and should be fixed (it should actually
die eventually). And a lot of current users of while_each_thread()
are themselves buggy and need the fixes no matter what we do with
while_each_thread.

Oh. and just in case... I am (slowly) working on this, but didn't
finish it yet, sorry.

But I do not really understand cgroup_attach_task(), and I am not
sure you observed the same problem. Add Tejun.

> We are facing the issue of cpu slogging in the function
>     cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
> bool threadgroup)
> in the do-while loop which iterates over the threadgroup.
>
>  rcu_read_lock();
>  do {
>  struct task_and_cgroup ent;
>
>  /* @tsk either already exited or can't exit until the end */
>  if (tsk->flags & PF_EXITING)
>  continue;
>
>  /* as per above, nr_threads may decrease, but not increase. */
>  BUG_ON(i >=3D group_size);
>  ent.task =3D tsk;
>  ent.cgrp =3D task_cgroup_from_root(tsk, root);
>  /* nothing to do if this task is already in the cgroup */
>  if (ent.cgrp =3D=3D cgrp)
>  continue;
>  /*
>  * saying GFP_ATOMIC has no effect here because we did prealloc
>  * earlier, but it's good form to communicate our expectations.
>  */
>  retval =3D flex_array_put(group, i, &ent, GFP_ATOMIC);
>  BUG_ON(retval !=3D 0);
>  i++;
>
>  if (!threadgroup)
>  break;
>  } while_each_thread(leader, tsk);
>
> Problem Observed:
> In this loop, in case of a single thread, and argument =E2=80=9Cbool
> threadgroup=E2=80=9D as =E2=80=9Cfalse=E2=80=9D and
> if(ent.cgrp =3D=3D cgrp) is true
> we will continue to the next thread instead of breaking out of the lo=
op.

But in this case the loop should be terminated by while_each_thread's
check?

Again, again, while_each_thread() is wrong, and we need

	--- x/kernel/cgroup.c
	+++ x/kernel/cgroup.c
	@@ -2034,7 +2034,7 @@ static int cgroup_attach_task(struct cgr
		 * take an rcu_read_lock.
		 */
		rcu_read_lock();
	-	do {
	+	for_each_thread(leader->signal, task) {
			struct task_and_cgroup ent;
	=20
			/* @tsk either already exited or can't exit until the end */
	@@ -2058,7 +2058,7 @@ static int cgroup_attach_task(struct cgr
	=20
			if (!threadgroup)
				break;
	-	} while_each_thread(leader, tsk);
	+	}
		rcu_read_unlock();
		/* remember the number of threads in the array for later. */
		group_size =3D i;

after we add for_each_thread/etc. But I am not sure we need another
"threadgroup" check.

> Possible Solution and Doubt:
> When a break condition was added as shown in the patch attached, the
> cpu sluggishness was not occurring.
> Can you please provide your suggestions, if this is the right way to
> fix the above mentioned issue.
> Also, if a fix is already in for this, can you please guide me to tha=
t.
>
> Thanks and Regards
> Anjana
>
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 1f53387..cae8416 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2002,7 +2002,9 @@ static int cgroup_attach_task(struct cgroup *cg=
rp, struct task_struct *tsk,
>  		ent.task =3D tsk;
>  		ent.cgrp =3D task_cgroup_from_root(tsk, root);
>  		/* nothing to do if this task is already in the cgroup */
> -		if (ent.cgrp =3D=3D cgrp)
> +		if (ent.cgrp =3D=3D cgrp && !threadgroup)
> +			break;
> +		else if(ent.cgrp =3D=3D cgrp)
>  			continue;
>  		/*
>  		 * saying GFP_ATOMIC has no effect here because we did prealloc
> @@ -2199,7 +2201,6 @@ retry_find_task:
>  	ret =3D cgroup_attach_task(cgrp, tsk, threadgroup);
> =20
>  	threadgroup_unlock(tsk);
> -
>  	put_task_struct(tsk);
>  out_unlock_cgroup:
>  	mutex_unlock(&cgroup_mutex);
