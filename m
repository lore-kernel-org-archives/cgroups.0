From: Mina Almasry <almasrymina@google.com>
Subject: Re: [RFC PATCH v2] mm: Add nodes= arg to memory.reclaim
Date: Thu, 1 Dec 2022 14:10:37 -0800
Message-ID: <CAHS8izOn3Kr8vqxHYxEoGVoCXKmysRKNsvXpJ2EumxDU6JfSDQ@mail.gmail.com>
References: <20221130020328.1009347-1-almasrymina@google.com> <20221201213202.ycdaymwojd5plyrk@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Rf84obAKN/8ruolDjM0pM28OtudVnfPduob08XaAHeM=;
        b=C5A/tE+OvI+/icvXdhe39VigA0TTbTY4PJd9mnXEXbnfkr0SrvZc1sS0BhKGJ9tFbH
         VrlF6IzPg1aqf/aWu55hvBF9KZc12XIGaiyBaaWM8tzg9pEnKuCYLKsOWIO9iIRoq6fN
         h+9U6WOdvTl4++/BjtWYxzFMTOs+g5fd6qJ/zeLOaxZ5HqfmU3EFndAxTDwLIhOvufRg
         lz9HYLOosZUavj+NWHAmwUBmjsPobyVqbSeR7xoIPkhsfX+u6FQFeFXf4lUXDXHETkX+
         aOg84lpe1797MkZHvW3Z/yK8LBKC0vRON342vgsQ0hEFEvXwFpzRCnmNE0JkU96V1fXe
         hHqw==
In-Reply-To: <20221201213202.ycdaymwojd5plyrk@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Huang Ying <ying.huang@intel.com>, Yang Shi <yang.shi@linux.alibaba.com>, Yosry Ahmed <yosryahmed@google.com>, Tim Chen <tim.c.chen@linux.intel.com>, weixugc@google.com, gthelen@google.com, fvdl@google.com, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Thu, Dec 1, 2022 at 1:32 PM Shakeel Butt <shakeelb@google.com> wrote:
>
> On Tue, Nov 29, 2022 at 06:03:27PM -0800, Mina Almasry wrote:
> [...]
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 7b8e8e43806b..23fc5b523764 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -6735,7 +6735,8 @@ unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
> >  unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
> >                                          unsigned long nr_pages,
> >                                          gfp_t gfp_mask,
> > -                                        unsigned int reclaim_options)
> > +                                        unsigned int reclaim_options,
> > +                                        nodemask_t nodemask)
>
> Can you please make this parameter a nodemask_t* and pass NULL instead
> of NODE_MASK_ALL?

Thank you very much for the review. I sure can in the next version. To
be honest I thought about that and made the parameter nodemask_t
because I thought the call sites would be more readable. I.e. this:

    try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
MEMCG_RECLAIM_MAY_SWAP,  NODE_MASK_ALL);

Would be more readable than this:

    try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
MEMCG_RECLAIM_MAY_SWAP,  NULL);

But the tradeoff is that the callers need include/linux/nodemask.h.
But yes I can fix in the next version.
