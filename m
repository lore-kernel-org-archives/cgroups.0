From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH memcg 0/1] false global OOM triggered by memcg-limited
 task
Date: Mon, 18 Oct 2021 13:12:44 +0300
Message-ID: <4a6f801b-28d3-94d7-2e65-212ad8c5a412@virtuozzo.com>
References: <9d10df01-0127-fb40-81c3-cc53c9733c3e@virtuozzo.com>
 <YW04jWSv6pQb2Goe@dhcp22.suse.cz>
 <6b751abe-aa52-d1d8-2631-ec471975cc3a@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=RjQ2q0eEBKUC2hw/uFRyVd7II2frLBeK42RcVtr41GU=; b=YdtmgWLsg/9itCN0w
        gaNBRGfhIxNAIsOrvb79eZIkBpOZ7CZv91nsy63JFIByh51HEzOSr7LaoE/DPpCnbwVT7Fz6deWga
        3qvoCB+/JJird1u8Xkc8qoPNqN6hyBAQ+QqhpptZZesFoyaujeaovPqgzcP6IbmvsVDDwm/pBVKIQ
        =;
In-Reply-To: <6b751abe-aa52-d1d8-2631-ec471975cc3a-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On 18.10.2021 13:05, Vasily Averin wrote:
> On 18.10.2021 12:04, Michal Hocko wrote:
>> On Mon 18-10-21 11:13:52, Vasily Averin wrote:
>>> Partially this problem depends on one of my recent patches, disabled unlimited
>>> memory allocation for dying tasks. However I think the problem can happen
>>> on non-killed tasks too, for example because of kmem limit.
>>
>> Could you be more specific on how this can happen without your patch? I
>> have to say I haven't realized this side effect when discussing it.
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

btw. in OpenVZ kernels we trying to cleanup the memory in when task hit kmem limit,
therefore we moved kmem limit check into try_charge_memcg.

Are any improvements for kmem controller interesting for upstream?

Thank you,
	Vasily Averin
