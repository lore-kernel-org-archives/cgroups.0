From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] ipc: remove memcg accounting for sops objects in
 do_semtimedop()
Date: Mon, 13 Sep 2021 10:37:02 +0200
Message-ID: <YT8NrsaztWNDpKXk@dhcp22.suse.cz>
References: <90e254df-0dfe-f080-011e-b7c53ee7fd20@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631522227; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UKSu3yTv+TX0tXlcSUO37sd0/aOo8J1xv19A7FZ7+Ig=;
        b=ZMT+0AgcgH+hRJCL2ffTYbCzZn/BEVzdgyChbAJf+WYp+HMrwdkFDOqIR/wbhIEDQaJ3dS
        VDxQV9ERlW08pJz64yBgAYXVsCo2ljnNryj8wTbreIMQM32Ehb0ZAbbPkmtK1oYCdaCbCq
        22d+IBxpaQQO5LXBt5yF+0v5WHrDATY=
Content-Disposition: inline
In-Reply-To: <90e254df-0dfe-f080-011e-b7c53ee7fd20-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat 11-09-21 10:40:08, Vasily Averin wrote:
> Linus proposes to revert an accounting for sops objects in
> do_semtimedop() because it's really just a temporary buffer
> for a single semtimedop() system call.
> 
> This object can consume up to 2 pages, syscall is sleeping one,
> size and duration can be controlled by user, and this allocation
> can be repeated by many thread at the same time.

Is there any upper bound or is it just bounded by the number of
tasks/threads (that can be controlled by pid controller at least)?

> However Shakeel Butt pointed that there are much more popular objects
> with the same life time and similar memory consumption, the accounting
> of which was decided to be rejected for performance reasons.

Is there any measurable performance impact in this particular case?
 
> In addition, any usual task consumes much more accounted memory,
> so 2 pages of this temporal buffer can be safely ignored.
> 
> Link: https://patchwork.kernel.org/project/linux-fsdevel/patch/20171005222144.123797-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/
> 
> Fixes: 18319498fdd4 ("memcg: enable accounting of ipc resources")
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> ---
>  ipc/sem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/ipc/sem.c b/ipc/sem.c
> index f833238df1ce..6693daf4fe11 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -2238,7 +2238,7 @@ static long do_semtimedop(int semid, struct sembuf __user *tsops,
>  		return -EINVAL;
>  
>  	if (nsops > SEMOPM_FAST) {
> -		sops = kvmalloc_array(nsops, sizeof(*sops), GFP_KERNEL_ACCOUNT);
> +		sops = kvmalloc_array(nsops, sizeof(*sops), GFP_KERNEL);
>  		if (sops == NULL)
>  			return -ENOMEM;
>  	}
> -- 
> 2.25.1

-- 
Michal Hocko
SUSE Labs
