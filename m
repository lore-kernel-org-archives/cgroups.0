From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH memcg 0/1] false global OOM triggered by memcg-limited
 task
Date: Tue, 19 Oct 2021 09:30:18 +0300
Message-ID: <339ae4b5-6efd-8fc2-33f1-2eb3aee71cb2@virtuozzo.com>
References: <9d10df01-0127-fb40-81c3-cc53c9733c3e@virtuozzo.com>
 <YW04jWSv6pQb2Goe@dhcp22.suse.cz>
 <6b751abe-aa52-d1d8-2631-ec471975cc3a@virtuozzo.com>
 <YW1gRz0rTkJrvc4L@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=tI9gj9p8cg4CnX2QaPSuoyzqKweCoJS55yHjYE7xcKM=; b=is7WHUREKxBUK1eox
        a3i8e7lEICkLoC40q5DdZ9O1639miZT0QpjLzmTbey1KH61kzqfqNE46f3xVo3z+vEfv84cDtb3BC
        5uvyqf7GIL1gRY7JUEs8Zy0etcbnAGPB4cxnlKeeFvMMW0HehqKkIbzMNocCK8KtCM4Z+5ti9g7d8
        =;
In-Reply-To: <YW1gRz0rTkJrvc4L-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On 18.10.2021 14:53, Michal Hocko wrote:
> On Mon 18-10-21 13:05:35, Vasily Averin wrote:
>> On 18.10.2021 12:04, Michal Hocko wrote:
>>> On Mon 18-10-21 11:13:52, Vasily Averin wrote:
>>> [...]
>>>> How could this happen?
>>>>
>>>> User-space task inside the memcg-limited container generated a page fault,
>>>> its handler do_user_addr_fault() called handle_mm_fault which could not
>>>> allocate the page due to exceeding the memcg limit and returned VM_FAULT_OOM.
>>>> Then do_user_addr_fault() called pagefault_out_of_memory() which executed
>>>> out_of_memory() without set of memcg.
>>>>
>>>> Partially this problem depends on one of my recent patches, disabled unlimited
>>>> memory allocation for dying tasks. However I think the problem can happen
>>>> on non-killed tasks too, for example because of kmem limit.
>>>
>>> Could you be more specific on how this can happen without your patch? I
>>> have to say I haven't realized this side effect when discussing it.

>> If required I can try to search how try_charge_memcg() can reject page allocation 
>> of non-dying task too.
> 
> Yes.

Now I think that such failure was very unlikely (w/o my patch and kmem limit).
I cannot exclude it completely, because I did not finished this review and perhaps I missed something,
but I checked most part of code and found nothing.

With my patch ("memcg: prohibit unconditional exceeding the limit of dying tasks") try_charge_memcg() can fail:
a) due to fatal signal
b) when mem_cgroup_oom -> mem_cgroup_out_of_memory -> out_of_memory() returns false (when select_bad_process() found nothing)

To handle a) we can follow to your suggestion and skip excution of out_of_memory() in pagefault_out_of memory()
To handle b) we can go to retry: if mem_cgroup_oom() return OOM_FAILED.

However all these cases can be successfully handled by my new patch
"memcg: prevent false global OOM triggered by memcg limited task"
and I think it is better solution.

Thank you,
	Vasily Averin
