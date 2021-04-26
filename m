From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/2] ipc: use kmalloc for msg_queue and shmid_kernel
Date: Mon, 26 Apr 2021 12:25:46 +0200
Message-ID: <YIaVKi+0VMrz5LGD@dhcp22.suse.cz>
References: <e67f2a95-4b01-9db2-fe47-0b2210f0b138@virtuozzo.com>
 <b0845b85-f4fe-601d-3328-d707d7db27f5@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619432747; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U68/Mp4uxWqOyj5YcF/rxWJX8wPgNMsVFMEhaLjW1C8=;
        b=f2narURWPrGMURZ9raTOHchRmFOpM2ZsAQTId9Cn1GqheCU0tDh6Ee51W/3cyxXt4DTVbC
        JZZImwoGeNztNB4IJwSc9JKaw0+T9SdUKT2OpHDgQCETxdLqu3FuXVMhFpobV57lYQR4fs
        ojuQgNU3J0wOe9ta3J+//XVZvXOv15U=
Content-Disposition: inline
In-Reply-To: <b0845b85-f4fe-601d-3328-d707d7db27f5-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dmitry Safonov <0x7f454c46-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Mon 26-04-21 13:18:14, Vasily Averin wrote:
> msg_queue and shmid_kernel are quite small objects, no need to use
> kvmalloc for them.

Both of them are 256B on most 64b systems.

> Previously these objects was allocated via ipc_alloc/ipc_rcu_alloc(),
> common function for several ipc objects. It had kvmalloc call inside().
> Later, this function went away and was finally replaced by direct
> kvmalloc call, and now we can use more suitable kmalloc/kfree for them.

This describes the history of the code but it doesn't really explain why
kvmalloc is a bad decision here. I would go with the following:
"
Using kvmalloc for sub page size objects is suboptimal because kmalloc
can easily fallback into vmalloc under memory pressure and smaller
objects would fragment memory. Therefore replace kvmalloc by a simple
kmalloc.
"
> 
> Reported-by: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

With a clarified changelog, feel free to add
Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks!

> ---
>  ipc/msg.c | 6 +++---
>  ipc/shm.c | 6 +++---
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/ipc/msg.c b/ipc/msg.c
> index 87898cb..79c6625 100644
> --- a/ipc/msg.c
> +++ b/ipc/msg.c
> @@ -130,7 +130,7 @@ static void msg_rcu_free(struct rcu_head *head)
>  	struct msg_queue *msq = container_of(p, struct msg_queue, q_perm);
>  
>  	security_msg_queue_free(&msq->q_perm);
> -	kvfree(msq);
> +	kfree(msq);
>  }
>  
>  /**
> @@ -147,7 +147,7 @@ static int newque(struct ipc_namespace *ns, struct ipc_params *params)
>  	key_t key = params->key;
>  	int msgflg = params->flg;
>  
> -	msq = kvmalloc(sizeof(*msq), GFP_KERNEL_ACCOUNT);
> +	msq = kmalloc(sizeof(*msq), GFP_KERNEL_ACCOUNT);
>  	if (unlikely(!msq))
>  		return -ENOMEM;
>  
> @@ -157,7 +157,7 @@ static int newque(struct ipc_namespace *ns, struct ipc_params *params)
>  	msq->q_perm.security = NULL;
>  	retval = security_msg_queue_alloc(&msq->q_perm);
>  	if (retval) {
> -		kvfree(msq);
> +		kfree(msq);
>  		return retval;
>  	}
>  
> diff --git a/ipc/shm.c b/ipc/shm.c
> index 7632d72..85da060 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -222,7 +222,7 @@ static void shm_rcu_free(struct rcu_head *head)
>  	struct shmid_kernel *shp = container_of(ptr, struct shmid_kernel,
>  							shm_perm);
>  	security_shm_free(&shp->shm_perm);
> -	kvfree(shp);
> +	kfree(shp);
>  }
>  
>  static inline void shm_rmid(struct ipc_namespace *ns, struct shmid_kernel *s)
> @@ -619,7 +619,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
>  			ns->shm_tot + numpages > ns->shm_ctlall)
>  		return -ENOSPC;
>  
> -	shp = kvmalloc(sizeof(*shp), GFP_KERNEL_ACCOUNT);
> +	shp = kmalloc(sizeof(*shp), GFP_KERNEL_ACCOUNT);
>  	if (unlikely(!shp))
>  		return -ENOMEM;
>  
> @@ -630,7 +630,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
>  	shp->shm_perm.security = NULL;
>  	error = security_shm_alloc(&shp->shm_perm);
>  	if (error) {
> -		kvfree(shp);
> +		kfree(shp);
>  		return error;
>  	}
>  
> -- 
> 1.8.3.1

-- 
Michal Hocko
SUSE Labs
