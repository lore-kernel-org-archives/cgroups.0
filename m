From: Eric Biggers <ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/1] psi: Fix uaf issue when psi trigger is destroyed
 while being polled
Date: Mon, 10 Jan 2022 19:12:12 -0800
Message-ID: <Ydz1jAp6RW3t0owj@sol.localdomain>
References: <20220111025138.1071848-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641870734;
        bh=yYT1LgS1YCJPnQWbemQOZnqx45HA1VBzrJhciandTU8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HUXrUoFP6R3CJx/Ib/3qu47iDvuaaRGJNwYX80sOqloUkmz76LfY+3QHhKWfliSEy
         ZbYEsgeB1EBPfUnDNpYKxUC39wlQT/Ctn+C8XYFgo7WSw8gnn14mtNBTKY62XdFutw
         +uXpipZ5RjJmX1nxwcJoZcEW1K2uSZiGsHBQuiZMNMJDnqYQ5MB63+VNOhxFPU5pzQ
         JJLqGOuplulj0YKl2rlbckrJtFr4O9P200MMT7JeRcf6Pwdh41hBBLwRDuvBMe0iXF
         +mgXujdecHk362sg4YhNad4HBp6miWXc2dSQFFnv6F2Daxky4Lxu/m65x5ZJWafNzO
         9SuIoI2NxOz3g==
Content-Disposition: inline
In-Reply-To: <20220111025138.1071848-1-surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, syzbot+cdb5dd11c97cc532efad-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org

On Mon, Jan 10, 2022 at 06:51:38PM -0800, Suren Baghdasaryan wrote:
> With write operation on psi files replacing old trigger with a new one,
> the lifetime of its waitqueue is totally arbitrary. Overwriting an
> existing trigger causes its waitqueue to be freed and pending poll()
> will stumble on trigger->event_wait which was destroyed.
> Fix this by disallowing to redefine an existing psi trigger. If a write
> operation is used on a file descriptor with an already existing psi
> trigger, the operation will fail with EBUSY error.
> Also bypass a check for psi_disabled in the psi_trigger_destroy as the
> flag can be flipped after the trigger is created, leading to a memory
> leak.
> 
> Reported-by: syzbot+cdb5dd11c97cc532efad-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
> Analyzed-by: Eric Biggers <ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Suggested-by: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Please include Fixes and Cc stable tags.

> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index cafb8c114a21..e6878238fb19 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -3642,6 +3642,12 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
>  	cgroup_get(cgrp);
>  	cgroup_kn_unlock(of->kn);
>  
> +	/* Allow only one trigger per file descriptor */
> +	if (READ_ONCE(ctx->psi.trigger)) {
> +		cgroup_put(cgrp);
> +		return -EBUSY;
> +	}
> +

Doesn't the task have exclusive access to the file at this point?  READ_ONCE()
is only needed instead of a plain load when the field can be concurrently
changed by another thread.

> diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
> index 1652f2bb54b7..882bf62cc247 100644
> --- a/kernel/sched/psi.c
> +++ b/kernel/sched/psi.c
> @@ -1151,7 +1151,6 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
>  	t->event = 0;
>  	t->last_event_time = 0;
>  	init_waitqueue_head(&t->event_wait);
> -	kref_init(&t->refcount);
>  
>  	mutex_lock(&group->trigger_lock);
>  
> @@ -1180,15 +1179,21 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
>  	return t;
>  }
>  
> -static void psi_trigger_destroy(struct kref *ref)
> +void psi_trigger_destroy(void **trigger_ptr)
>  {
> -	struct psi_trigger *t = container_of(ref, struct psi_trigger, refcount);
> -	struct psi_group *group = t->group;
> +	struct psi_trigger *t;
> +	struct psi_group *group;
>  	struct task_struct *task_to_destroy = NULL;
>  
> -	if (static_branch_likely(&psi_disabled))
> +	/*
> +	 * We do not check psi_disabled since it might have been disabled after
> +	 * the trigger got created.
> +	 */
> +	t = xchg(trigger_ptr, NULL);
> +	if (!t)
>  		return;

Likewise, doesn't the task have exclusive access to the file at this point?
This is only called during ->release().

And why does this take a pointer to a pointer instead of just the pointer?

> @@ -1305,14 +1289,24 @@ static ssize_t psi_write(struct file *file, const char __user *user_buf,
>  
>  	buf[buf_size - 1] = '\0';
>  
> -	new = psi_trigger_create(&psi_system, buf, nbytes, res);
> -	if (IS_ERR(new))
> -		return PTR_ERR(new);
> -
>  	seq = file->private_data;
> +
>  	/* Take seq->lock to protect seq->private from concurrent writes */
>  	mutex_lock(&seq->lock);
> -	psi_trigger_replace(&seq->private, new);
> +
> +	/* Allow only one trigger per file descriptor */
> +	if (READ_ONCE(seq->private)) {
> +		mutex_unlock(&seq->lock);
> +		return -EBUSY;
> +	}

Likewise, what does this race against that would require the use of READ_ONCE()?

- Eric
