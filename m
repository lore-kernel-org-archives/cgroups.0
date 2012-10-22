From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/7] cgroup_freezer: allow moving tasks in and out of a
	frozen cgroup
Date: Mon, 22 Oct 2012 21:25:06 +0200
Message-ID: <20121022192506.GA27163@redhat.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org> <1350426526-14254-6-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1350426526-14254-6-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: rjw-KKrjLPT3xs0@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Tha last question ;)

On 10/16, Tejun Heo wrote:
>
> @@ -190,12 +201,12 @@ static void freezer_fork(struct task_struct *task)
>  		goto out;
>
>  	spin_lock_irq(&freezer->lock);
> -	BUG_ON(freezer->state == CGROUP_FROZEN);
> -
> -	/* Locking avoids race with FREEZING -> THAWED transitions. */
> -	if (freezer->state == CGROUP_FREEZING)
> +	/*
> +	 * @task might have been just migrated into a FROZEN cgroup.

Confused. If it was migrated, then freezer_attach() should take care
do freeze_task?

IOW,

> Test
> +	 * equality with THAWED.  Read the comment in freezer_attach().
> +	 */
> +	if (freezer->state != CGROUP_THAWED)
>  		freeze_task(task);
> -

This can only happen in the "normal" case, when a CGROUP_FREEZING task
forks the new child. So we could even do BUG_ON(state = CGROUP_FROZEN).

Or there could be another reason?

Oleg.
