From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH memcg 0/1] false global OOM triggered by memcg-limited
 task
Date: Mon, 18 Oct 2021 11:04:13 +0200
Message-ID: <YW04jWSv6pQb2Goe@dhcp22.suse.cz>
References: <9d10df01-0127-fb40-81c3-cc53c9733c3e@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1634547853; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z/vHFPDVM8hZbz3viTK/C8vH4oGvJ8bN8OaWpPhCHZA=;
        b=mlAFk61d8h+oSQO3dORG+kD0uapYz7LR8uzHrxUR/4h6gZrn6tBqFtGaJdXynpE3yHSMNK
        YL/qsLMTyZgoJD3G7YFKI5VAm27szaLmBj00FcNqg+eOlKtgZ08zzUOrgj0iNDSRFxZ6tc
        8kq79DeG+dWHL856++NmRKI+2yWvH40=
Content-Disposition: inline
In-Reply-To: <9d10df01-0127-fb40-81c3-cc53c9733c3e-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Mon 18-10-21 11:13:52, Vasily Averin wrote:
[...]
> How could this happen?
> 
> User-space task inside the memcg-limited container generated a page fault,
> its handler do_user_addr_fault() called handle_mm_fault which could not
> allocate the page due to exceeding the memcg limit and returned VM_FAULT_OOM.
> Then do_user_addr_fault() called pagefault_out_of_memory() which executed
> out_of_memory() without set of memcg.
> 
> Partially this problem depends on one of my recent patches, disabled unlimited
> memory allocation for dying tasks. However I think the problem can happen
> on non-killed tasks too, for example because of kmem limit.

Could you be more specific on how this can happen without your patch? I
have to say I haven't realized this side effect when discussing it.

I will be honest that I am not really happy about pagefault_out_of_memory.
I have tried to remove it in the past. Without much success back then,
unfortunately[1]. 
Maybe we should get rid of it finally. The OOM is always triggered from
inside the allocator where we have much more infromation about the
allocation context. A first step would be to skip pagefault_out_of_memory
for killed or exiting processes.

[1] I do not have msg-id so I cannot provide a lore link but google
pointed me to https://www.mail-archive.com/linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg1400402.html
-- 
Michal Hocko
SUSE Labs
