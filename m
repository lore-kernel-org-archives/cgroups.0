From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH memcg 0/1] false global OOM triggered by memcg-limited
 task
Date: Thu, 21 Oct 2021 11:03:43 +0300
Message-ID: <496ed57e-61c6-023a-05fd-4ef21b0294cf@virtuozzo.com>
References: <9d10df01-0127-fb40-81c3-cc53c9733c3e@virtuozzo.com>
 <YW04jWSv6pQb2Goe@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=nC/QVr0jtd67Au3q+jnUAluZhpYLLVaIrvqIUdLTEDo=; b=Wtw08hMyX+W4NLre+
        n9xyyyWTQ+7yVckdtj4NgGGt3H07Uadf+aq/kXQ0s9YmKasnSl8h0WaWckzAzJbaxdJDikq3o2EtK
        PjakBSQeCbhcuQsyynQ5dQ/mJmVCGoPXQEHuzCe+/lntmiujD0qXlJrOGynXblB6Roux8XZG5w2DY
        =;
In-Reply-To: <YW04jWSv6pQb2Goe-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On 18.10.2021 12:04, Michal Hocko wrote:
> On Mon 18-10-21 11:13:52, Vasily Averin wrote:
> [...]
>> How could this happen?
>>
>> User-space task inside the memcg-limited container generated a page fault,
>> its handler do_user_addr_fault() called handle_mm_fault which could not
>> allocate the page due to exceeding the memcg limit and returned VM_FAULT_OOM.
>> Then do_user_addr_fault() called pagefault_out_of_memory() which executed
>> out_of_memory() without set of memcg.

> I will be honest that I am not really happy about pagefault_out_of_memory.
> I have tried to remove it in the past. Without much success back then,
> unfortunately[1]. 
> 
> [1] I do not have msg-id so I cannot provide a lore link but google
> pointed me to https://www.mail-archive.com/linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg1400402.html

I re-read this discussion and in general I support your position.
As far as I understand your opponents cannot explain why "random kill" is mandatory here,
they are just afraid that it might be useful here and do not want to remove it completely.

Ok, let's allow him to do it. Moreover I'm ready to keep it as default behavior.

However I would like to have some choice in this point.

In general we can:
- continue to use "random kill" and rely on the wisdom of the ancestors.
- do nothing, repeat #PF and rely on fate: "nothing bad will happen if we do it again".
- add some (progressive) killable delay, rely on good will of (unkillable) neighbors and wait for them to release required memory.
- mark the current task as cycled in #PF and somehow use this mark in allocator
- make sure that the current task is really cycled, have no progress, send him fatal signal to kill it and break the cycle.
- implement any better ideas,
- use any combination of previous points

We can select required strategy for example via sysctl.

For me "random kill" is worst choice, 
Why can't we just kill the looped process instead?
It can be marked as oom-unkillable, so OOM-killer was unable to select it.
However I doubt it means "never kill it", for me it is something like "last possible victim" priority.

Thank you,
	Vasily Averin
