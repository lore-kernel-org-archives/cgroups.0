From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH memcg 1/3] mm: do not firce global OOM from inside dying
 tasks
Date: Wed, 20 Oct 2021 14:33:43 +0200
Message-ID: <YXAMpxjuV/h2awqG@dhcp22.suse.cz>
References: <YW/WoJDFM3ddHn7Y@dhcp22.suse.cz>
 <cover.1634730787.git.vvs@virtuozzo.com>
 <2c13c739-7282-e6f4-da0a-c0b69e68581e@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1634733227; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3UnTu9zwwf8NSgpDXIex/EQbixB3GG5nxeC27rFUoo4=;
        b=hwW3FoF7Q9xQQ6c9C6pXKQVXDvbM5O97PBXyMbMq/0FtzqbRYEDMmNIeYhYMEUaH3bEmzm
        e2K72qTnlyNHrXAyZr3ANBJ4k6blJ6/7Ec3Cat8TdGd6Dwmgwtco8FNx3KQ/ipePD4qRPB
        QWwPiXvrmlfaVryc15mzcCx4y1j93vs=
Content-Disposition: inline
In-Reply-To: <2c13c739-7282-e6f4-da0a-c0b69e68581e-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

s@firce@force@

On Wed 20-10-21 15:12:19, Vasily Averin wrote:
> There is no sense to force global OOM if current task is dying.

This really begs for much more information. Feel free to get an
inspiration from my previous attempt to achieve something similar.
In minimum it is important to mention that the OOM killer is already
handled at the page allocator level for the global OOM and at the
charging level for the memcg one. Both have much more information
about the scope of allocation/charge request. This means that either the
OOM killer has been invoked properly and didn't lead to the allocation
success or it has been skipped because it couldn't have been invoked.
In both cases triggering it from here is pointless and even harmful.

Another argument is that it is more reasonable to let killed task die
rather than hit the oom killer and retry the allocation.

> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> ---
>  mm/oom_kill.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 831340e7ad8b..1deef8c7a71b 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -1137,6 +1137,9 @@ void pagefault_out_of_memory(void)
>  	if (mem_cgroup_oom_synchronize(true))
>  		return;
>  
> +	if (fatal_signal_pending(current))
> +		return;
> +
>  	if (!mutex_trylock(&oom_lock))
>  		return;
>  	out_of_memory(&oc);
> -- 
> 2.32.0

-- 
Michal Hocko
SUSE Labs
