From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH memcg 0/1] false global OOM triggered by memcg-limited
 task
Date: Tue, 19 Oct 2021 13:54:41 +0200
Message-ID: <YW6yAeAO+TeS3OdB@dhcp22.suse.cz>
References: <9d10df01-0127-fb40-81c3-cc53c9733c3e@virtuozzo.com>
 <YW04jWSv6pQb2Goe@dhcp22.suse.cz>
 <6b751abe-aa52-d1d8-2631-ec471975cc3a@virtuozzo.com>
 <YW1gRz0rTkJrvc4L@dhcp22.suse.cz>
 <339ae4b5-6efd-8fc2-33f1-2eb3aee71cb2@virtuozzo.com>
 <YW6GoZhFUJc1uLYr@dhcp22.suse.cz>
 <687bf489-f7a7-5604-25c5-0c1a09e0905b@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1634644482; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kjUTORhMXSDVDvRms+kcqq6S1tclrHNa5RDL4eI+HuY=;
        b=ZmH1pqyD7BkKSJl7yYLpQEnGlTjj70gOVzsOJHYIdgNSd2zzONjFac9hDbtdtUw389EkQc
        jeUbkHgPM5fwPIJBNvug1/6S07uPjuxtovZ0Rij5pUXDx1fijf2SNc3pN86ca6utdTFaSe
        Rv/kFcZoGCSZaHr78PXkwDnoIj+W8Ec=
Content-Disposition: inline
In-Reply-To: <687bf489-f7a7-5604-25c5-0c1a09e0905b-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Tue 19-10-21 13:30:06, Vasily Averin wrote:
> On 19.10.2021 11:49, Michal Hocko wrote:
> > On Tue 19-10-21 09:30:18, Vasily Averin wrote:
> > [...]
> >> With my patch ("memcg: prohibit unconditional exceeding the limit of dying tasks") try_charge_memcg() can fail:
> >> a) due to fatal signal
> >> b) when mem_cgroup_oom -> mem_cgroup_out_of_memory -> out_of_memory() returns false (when select_bad_process() found nothing)
> >>
> >> To handle a) we can follow to your suggestion and skip excution of out_of_memory() in pagefault_out_of memory()
> >> To handle b) we can go to retry: if mem_cgroup_oom() return OOM_FAILED.
> 
> > How is b) possible without current being killed? Do we allow remote
> > charging?
> 
> out_of_memory for memcg_oom
>  select_bad_process
>   mem_cgroup_scan_tasks
>    oom_evaluate_task
>     oom_badness
> 
>         /*
>          * Do not even consider tasks which are explicitly marked oom
>          * unkillable or have been already oom reaped or the are in
>          * the middle of vfork
>          */
>         adj = (long)p->signal->oom_score_adj;
>         if (adj == OOM_SCORE_ADJ_MIN ||
>                         test_bit(MMF_OOM_SKIP, &p->mm->flags) ||
>                         in_vfork(p)) {
>                 task_unlock(p);
>                 return LONG_MIN;
>         }
> 
> This time we handle userspace page fault, so we cannot be kenrel thread,
> and cannot be in_vfork().
> However task can be marked as oom unkillable, 
> i.e. have p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN

You are right. I am not sure there is a way out of this though. The task
can only retry for ever in this case. There is nothing actionable here.
We cannot kill the task and there is no other way to release the memory.

-- 
Michal Hocko
SUSE Labs
