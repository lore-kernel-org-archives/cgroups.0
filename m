From: Muchun Song <muchun.song@linux.dev>
Subject: Re: [RFC PATCH v2] mm: Add nodes= arg to memory.reclaim
Date: Fri, 2 Dec 2022 14:04:45 +0800
Message-ID: <F2917C72-A6F4-4969-B044-211F0D3856F1@linux.dev>
References: <20221130020328.1009347-1-almasrymina@google.com>
 <20221201213202.ycdaymwojd5plyrk@google.com>
 <CAHS8izOn3Kr8vqxHYxEoGVoCXKmysRKNsvXpJ2EumxDU6JfSDQ@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.200.110.1.12\))
Content-Transfer-Encoding: 8BIT
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <CAHS8izOn3Kr8vqxHYxEoGVoCXKmysRKNsvXpJ2EumxDU6JfSDQ@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina@google.com>
Cc: Shakeel Butt <shakeelb@google.com>, Huang Ying <ying.huang@intel.com>, Yang Shi <yang.shi@linux.alibaba.com>, Yosry Ahmed <yosryahmed@google.com>, Tim Chen <tim.c.chen@linux.intel.com>, weixugc@google.com, gthelen@google.com, fvdl@google.com, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, Linux Doc Mailing List <linux-doc@vger.kernel.org>, linux-kernel@vger.kernel.org, Linux Memory Management List <linux-mm@kvack.org>



> On Dec 2, 2022, at 06:10, Mina Almasry <almasrymina@google.com> wrote:
> 
> On Thu, Dec 1, 2022 at 1:32 PM Shakeel Butt <shakeelb@google.com> wrote:
>> 
>> On Tue, Nov 29, 2022 at 06:03:27PM -0800, Mina Almasry wrote:
>> [...]
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index 7b8e8e43806b..23fc5b523764 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>> @@ -6735,7 +6735,8 @@ unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
>>> unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
>>>                                         unsigned long nr_pages,
>>>                                         gfp_t gfp_mask,
>>> -                                        unsigned int reclaim_options)
>>> +                                        unsigned int reclaim_options,
>>> +                                        nodemask_t nodemask)
>> 
>> Can you please make this parameter a nodemask_t* and pass NULL instead
>> of NODE_MASK_ALL?
> 
> Thank you very much for the review. I sure can in the next version. To
> be honest I thought about that and made the parameter nodemask_t
> because I thought the call sites would be more readable. I.e. this:
> 
>    try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
> MEMCG_RECLAIM_MAY_SWAP,  NODE_MASK_ALL);

nodemask_t is an array, which can be large depending on CONFIG_NODES_SHIFT.
I don't think passing a big array is an efficient way. So I agree with Shakeel.

Thanks.

> 
> Would be more readable than this:
> 
>    try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
> MEMCG_RECLAIM_MAY_SWAP,  NULL);
> 
> But the tradeoff is that the callers need include/linux/nodemask.h.
> But yes I can fix in the next version.
> 

