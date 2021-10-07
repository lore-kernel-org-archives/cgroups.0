From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH mm v2] vmalloc: back off when the current task is
 OOM-killed
Date: Thu, 7 Oct 2021 12:47:53 +0200
Message-ID: <YV7QWYO0MwHzXya7@dhcp22.suse.cz>
References: <YVGmMSJ3NrQZjLP8@dhcp22.suse.cz>
 <83efc664-3a65-2adb-d7c4-2885784cf109@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1633603677; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mcWJYTrnWNl9H+OH2VlIp+D8YPfOLYhVh6/tuPxFG6E=;
        b=XLa1+jaF+yRNiuxXt1smb033r6qPpmsLlMjdHa2HtGvwNEuK5fBVKAPThwB7m1bk/Vi7dT
        BZszrjex1rujp9HJ6R4DaGydGClIQPMBl2Dv4sFPEbaM6g9lRavt9Cywa9zVGxqqlQogRE
        vEL107lCkhZivdYEgi/rxv64AAdFOmU=
Content-Disposition: inline
In-Reply-To: <83efc664-3a65-2adb-d7c4-2885784cf109-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Tue 05-10-21 16:52:40, Vasily Averin wrote:
> Huge vmalloc allocation on heavy loaded node can lead to a global
> memory shortage. Task called vmalloc can have worst badness and
> be selected by OOM-killer, however taken fatal signal does not
> interrupt allocation cycle. Vmalloc repeat page allocaions
> again and again, exacerbating the crisis and consuming the memory
> freed up by another killed tasks.
> 
> After a successful completion of the allocation procedure, a fatal
> signal will be processed and task will be destroyed finally.
> However it may not release the consumed memory, since the allocated
> object may have a lifetime unrelated to the completed task.
> In the worst case, this can lead to the host will panic
> due to "Out of memory and no killable processes..."
> 
> This patch allows OOM-killer to break vmalloc cycle, makes OOM more
> effective and avoid host panic. It does not check oom condition directly,
> however, and breaks page allocation cycle when fatal signal was received.

This will allow also interrupting a user space requist which happens to
trigger a large vmalloc, hence the reason for going for
fatal_signal_pending rather than oom specific condition.

> This may trigger some hidden problems, when caller does not handle
> vmalloc failures, or when rollaback after failed vmalloc calls own
> vmallocs inside. However all of these scenarios are incorrect:
> vmalloc does not guarantee successful allocation, it has never been called
> with __GFP_NOFAIL and threfore either should not be used for any rollbacks
> or should handle such errors correctly and not lead to critical
> failures.

__GFP_NOFAIL semantic is explicitly not supported for vmalloc.

> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

I would keep it sitting in the linux-next for some time to sort out
potential fallouts and have them fixed before this one gets merged.

Thanks!
> ---
> v2: tsk_is_oom_victim() check replaced by fatal_signal_pending(current),
>     removed check inside __alloc_pages_bulk(),
>     according to feedback from mhocko@.
>     Updated patch description.
> ---
>  mm/vmalloc.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index d77830ff604c..71706f5447f0 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2860,6 +2860,9 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  		struct page *page;
>  		int i;
>  
> +		if (fatal_signal_pending(current))
> +			break;
> +
>  		page = alloc_pages_node(nid, gfp, order);
>  		if (unlikely(!page))
>  			break;
> -- 
> 2.31.1

-- 
Michal Hocko
SUSE Labs
