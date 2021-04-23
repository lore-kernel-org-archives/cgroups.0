From: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 08/16] memcg: enable accounting of ipc resources
Date: Fri, 23 Apr 2021 15:16:54 +0300
Message-ID: <YIK6ttdnfjOo6XCN@localhost.localdomain>
References: <dddf6b29-debd-dcb5-62d0-74909d610edb@virtuozzo.com>
 <4ed65beb-bda3-1c93-fadf-296b760a32b2@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PP0ysUhYjdRjB3qzEj6pxo2eA4EOFmjxvGzVl7hdO64=;
        b=uK+jkwPaElZVorVWXDD4sC43dZn846Dl9yzOnsSJyfBmB9jPPX0t0pb16/OqyIws/i
         TBXB6rOc+TrBtKvb2pjUsuN0YKiE6l1SCnLKoUuT3nc+NgodmwpE2mTjXTrazdV4q735
         JZ2q44hvcYgrE344g5ziRSL3LVPwQa2aVS2iE90BDeZ587q9cIwFTYtAb5+El8m54V4b
         xstBXGETIAunVVZEjfR52xXcucQaZvnh/uF5OBHoU1pobiGmBZIhl3tLb7oEWyLWqVxl
         gcwlGqXo1AGs94EPpobKGApNOkSbKG9RRB1kPZf8ZgCrA0m3bytJMjKAzCBiqQYxVKcg
         W/pw==
Content-Disposition: inline
In-Reply-To: <4ed65beb-bda3-1c93-fadf-296b760a32b2-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dmitry Safonov <0x7f454c46-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Thu, Apr 22, 2021 at 01:37:02PM +0300, Vasily Averin wrote:
> When user creates IPC objects it forces kernel to allocate memory for
> these long-living objects.
> 
> It makes sense to account them to restrict the host's memory consumption
> from inside the memcg-limited container.
> 
> This patch enables accounting for IPC shared memory segments, messages
> semaphores and semaphore's undo lists.

> --- a/ipc/msg.c
> +++ b/ipc/msg.c
> @@ -147,7 +147,7 @@ static int newque(struct ipc_namespace *ns, struct ipc_params *params)
>  	key_t key = params->key;
>  	int msgflg = params->flg;
>  
> -	msq = kvmalloc(sizeof(*msq), GFP_KERNEL);
> +	msq = kvmalloc(sizeof(*msq), GFP_KERNEL_ACCOUNT);

Why this requires vmalloc? struct msg_queue is not big at all.

> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -619,7 +619,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
>  			ns->shm_tot + numpages > ns->shm_ctlall)
>  		return -ENOSPC;
>  
> -	shp = kvmalloc(sizeof(*shp), GFP_KERNEL);
> +	shp = kvmalloc(sizeof(*shp), GFP_KERNEL_ACCOUNT);

Same question.
Kmem caches can be GFP_ACCOUNT by default.
