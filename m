From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH memcg 0/1] false global OOM triggered by memcg-limited
 task
Date: Mon, 18 Oct 2021 13:53:43 +0200
Message-ID: <YW1gRz0rTkJrvc4L@dhcp22.suse.cz>
References: <9d10df01-0127-fb40-81c3-cc53c9733c3e@virtuozzo.com>
 <YW04jWSv6pQb2Goe@dhcp22.suse.cz>
 <6b751abe-aa52-d1d8-2631-ec471975cc3a@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1634558033; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z0UuFhyEIjaBwP5r+PsHqxA5xRPhuNYdcMZlskEMrGY=;
        b=ZjqWXdfXKMHPd/7dT3ZBbyBYZT0GvgAZ5uFgml9vKheBX4/odRHnrEAofs7gvFBKL4fXSS
        QqzjjM9mDqd1EmrGjEllilhLo4/Pl972XwkKlQ/ZZD5galvGZzeue6+WzkaFo16XZqbkRh
        O4YcNdXLvw0yWOgMbWzLZcivjA/nvDg=
Content-Disposition: inline
In-Reply-To: <6b751abe-aa52-d1d8-2631-ec471975cc3a-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Mon 18-10-21 13:05:35, Vasily Averin wrote:
> On 18.10.2021 12:04, Michal Hocko wrote:
> > On Mon 18-10-21 11:13:52, Vasily Averin wrote:
> > [...]
> >> How could this happen?
> >>
> >> User-space task inside the memcg-limited container generated a page fault,
> >> its handler do_user_addr_fault() called handle_mm_fault which could not
> >> allocate the page due to exceeding the memcg limit and returned VM_FAULT_OOM.
> >> Then do_user_addr_fault() called pagefault_out_of_memory() which executed
> >> out_of_memory() without set of memcg.
> >>
> >> Partially this problem depends on one of my recent patches, disabled unlimited
> >> memory allocation for dying tasks. However I think the problem can happen
> >> on non-killed tasks too, for example because of kmem limit.
> > 
> > Could you be more specific on how this can happen without your patch? I
> > have to say I haven't realized this side effect when discussing it.
> 
> We can reach obj_cgroup_charge_pages() for example via
> 
> do_user_addr_fault
> handle_mm_fault
> __handle_mm_fault
> p4d_alloc
> __p4d_alloc
> p4d_alloc_one
> get_zeroed_page
> __get_free_pages
> alloc_pages
> __alloc_pages
> __memcg_kmem_charge_page
> obj_cgroup_charge_pages
> 
> Here we call try_charge_memcg() that return success and approve the allocation,
> however then we hit into kmem limit and fail the allocation.

Just to make sure I understand this would be for the v1 kmem explicit
limit, correct?

> If required I can try to search how try_charge_memcg() can reject page allocation 
> of non-dying task too.

Yes.

> > I will be honest that I am not really happy about pagefault_out_of_memory.
> > I have tried to remove it in the past. Without much success back then,
> > unfortunately[1]. 
> > Maybe we should get rid of it finally. The OOM is always triggered from
> > inside the allocator where we have much more infromation about the
> > allocation context. A first step would be to skip pagefault_out_of_memory
> > for killed or exiting processes.
> 
> I like this idea, however it may be not enough, at least in scenario described above.

I original patch has removed the oom killer completely.

-- 
Michal Hocko
SUSE Labs
