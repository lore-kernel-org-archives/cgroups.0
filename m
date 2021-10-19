From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH memcg 0/1] false global OOM triggered by memcg-limited
 task
Date: Tue, 19 Oct 2021 10:49:37 +0200
Message-ID: <YW6GoZhFUJc1uLYr@dhcp22.suse.cz>
References: <9d10df01-0127-fb40-81c3-cc53c9733c3e@virtuozzo.com>
 <YW04jWSv6pQb2Goe@dhcp22.suse.cz>
 <6b751abe-aa52-d1d8-2631-ec471975cc3a@virtuozzo.com>
 <YW1gRz0rTkJrvc4L@dhcp22.suse.cz>
 <339ae4b5-6efd-8fc2-33f1-2eb3aee71cb2@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1634633380; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XPwmj/o6n9ykv9XbtNvWH5jIFBBxobggF5mrBJrzaOI=;
        b=CziZ8O745mlkeu314jrm3XHnf3nMStZFP21MvFp8qAH3CeVI8ZEssk6h4spttaOLGBn+V4
        GY4QKYFX8SBEAuigRErLE1YypTQh0h4wf6PGqCMFRKXhiAuj+syDyugIiT4DGDhvGfHz2r
        zVXG7CncMJv59I36BTIdl91S37t0zCY=
Content-Disposition: inline
In-Reply-To: <339ae4b5-6efd-8fc2-33f1-2eb3aee71cb2-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Tue 19-10-21 09:30:18, Vasily Averin wrote:
[...]
> With my patch ("memcg: prohibit unconditional exceeding the limit of dying tasks") try_charge_memcg() can fail:
> a) due to fatal signal
> b) when mem_cgroup_oom -> mem_cgroup_out_of_memory -> out_of_memory() returns false (when select_bad_process() found nothing)
> 
> To handle a) we can follow to your suggestion and skip excution of out_of_memory() in pagefault_out_of memory()
> To handle b) we can go to retry: if mem_cgroup_oom() return OOM_FAILED.

How is b) possible without current being killed? Do we allow remote
charging?

> However all these cases can be successfully handled by my new patch
> "memcg: prevent false global OOM triggered by memcg limited task"
> and I think it is better solution.

I have already replied to your approach in other email. Sorry our
replies have crossed.
-- 
Michal Hocko
SUSE Labs
