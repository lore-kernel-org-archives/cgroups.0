From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH memcg 3/3] memcg: handle memcg oom failures
Date: Thu, 21 Oct 2021 13:49:29 +0200
Message-ID: <YXFPSvGFV539OcEk@dhcp22.suse.cz>
References: <YW/WoJDFM3ddHn7Y@dhcp22.suse.cz>
 <cover.1634730787.git.vvs@virtuozzo.com>
 <fb33f4bd-34cd-2187-eff4-7c1c11d5ae94@virtuozzo.com>
 <YXATW7KsUZzbbGHy@dhcp22.suse.cz>
 <d3b32c72-6375-f755-7599-ab804719e1f6@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1634816970; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wT70oYeZpHQ/Zw1q79aVg8xYlfn/XGItMyWdHMMq2mc=;
        b=dbvcoLBO60xANuysYbeygYlx/ufkfe8rO3pFHYiG4HhBwwrtVgXTY+w0JMwpn1U1Kn+CBz
        NPjWJBRPA8rgHaxlIj42LDmApYAY1ZTK5tYK6jF9phuFrOArW5jidBSQO35sz+MHqfjVsK
        CLNc706hSIYtGkr3yPfVVl0YCOt74TM=
Content-Disposition: inline
In-Reply-To: <d3b32c72-6375-f755-7599-ab804719e1f6-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Wed 20-10-21 18:46:56, Vasily Averin wrote:
> On 20.10.2021 16:02, Michal Hocko wrote:
> > On Wed 20-10-21 15:14:27, Vasily Averin wrote:
> >> mem_cgroup_oom() can fail if current task was marked unkillable
> >> and oom killer cannot find any victim.
> >>
> >> Currently we force memcg charge for such allocations,
> >> however it allow memcg-limited userspace task in to overuse assigned limits
> >> and potentially trigger the global memory shortage.
> > 
> > You should really go into more details whether that is a practical
> > problem to handle. OOM_FAILED means that the memcg oom killer couldn't
> > find any oom victim so it cannot help with a forward progress. There are
> > not that many situations when that can happen. Naming that would be
> > really useful.
> 
> I've pointed above: 
> "if current task was marked unkillable and oom killer cannot find any victim."
> This may happen when current task cannot be oom-killed because it was marked
> unkillable i.e. it have p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN
> and other processes in memcg are either dying, or are kernel threads or are marked unkillable 
> by the same way. Or when memcg have this process only.
> 
> If we always approve such kind of allocation, it can be misused.
> Process can mmap a lot of memory,
> ant then touch it and generate page fault and make overcharged memory allocations.
> Finally it can consume all node memory and trigger global memory shortage on the host.

Yes, this is true but a) OOM_SCORE_ADJ_MIN tasks are excluded from the
OOM handling so they have to be careful with the memory consumption and
b) is this a theoretical or a practical concern. 

This is mostly what I wanted to make sure you describe in the changelog.

> >> Let's fail the memory charge in such cases.
> >>
> >> This failure should be somehow recognised in #PF context,
> > 
> > explain why
> 
> When #PF cannot allocate memory (due to reason described above), handle_mm_fault returns VM_FAULT_OOM,
> then its caller executes pagefault_out_of_memory(). If last one cannot recognize the real reason of this fail,
> it expect it was global memory shortage and executed global out_ouf_memory() that can kill random process 
> or just crash node if sysctl vm.panic_on_oom is set to 1.
> 
> Currently pagefault_out_of_memory() knows about possible async memcg OOM and handles it correctly.
> However it is not aware that memcg can reject some other allocations, do not recognize the fault
> as memcg-related and allows to run global OOM.

Again something to be added to the changelog.

> >> so let's use current->memcg_in_oom == (struct mem_cgroup *)OOM_FAILED
> >>
> >> ToDo: what is the best way to notify pagefault_out_of_memory() about 
> >>     mem_cgroup_out_of_memory failure ?
> > 
> > why don't you simply remove out_of_memory from pagefault_out_of_memory
> > and leave it only with the blocking memcg OOM handling? Wouldn't that be a
> > more generic solution? Your first patch already goes that way partially.
> 
> I clearly understand that global out_of_memory should not be trggired by memcg restrictions.
> I clearly understand that dying task will release some memory soon and we can do not run global oom if current task is dying.
> 
> However I'm not sure that I can remove out_of_memory at all. At least I do not have good arguments to do it.

I do understand that handling a very specific case sounds easier but it
would be better to have a robust fix even if that requires some more
head scratching. So far we have collected several reasons why the it is
bad to trigger oom killer from the #PF path. There is no single argument
to keep it so it sounds like a viable path to pursue. Maybe there are
some very well hidden reasons but those should be documented and this is
a great opportunity to do either of the step.

Moreover if it turns out that there is a regression then this can be
easily reverted and a different, maybe memcg specific, solution can be
implemented.
-- 
Michal Hocko
SUSE Labs
