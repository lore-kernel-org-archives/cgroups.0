From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [RFC PATCH v2] mm: Add nodes= arg to memory.reclaim
Date: Thu, 1 Dec 2022 21:32:02 +0000
Message-ID: <20221201213202.ycdaymwojd5plyrk@google.com>
References: <20221130020328.1009347-1-almasrymina@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IfDx/vZZhAqgLTBVAtZpOgxT3AMIFtwt/yJ9iwINIG4=;
        b=sbHSU0xyULWPTLXrm4btl81eBH5mc9EKqlCz8FBmg/OKAGvwye48d3zFEn0riuTVz+
         WI135Ntn79yhQRfKeyZF9J31eWKZKbKfBPuZ6/IMFzXeE7bgaaa2yAN6MEz3rn9BS3KN
         pNq4oLUFZmBCza5DExDhCrhY1gEBUmnnwuPGqI06j6cwAnmA9q0TDNzZ1mv8sSTIT1dN
         i7JlGJQmI3F0FeNp58IYU82p1+DN2kCgMsZWLPZ80EgvnJx/a3yI/cpU52DcBwD9efhB
         EZCOpNyNvSM5cmzqGWy8U39bvl1fJXnh98h4aU96DBsH01M0Va7s9KdyfDWD8Tiyn9Ie
         bEvw==
In-Reply-To: <20221130020328.1009347-1-almasrymina@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Mina Almasry <almasrymina@google.com>
Cc: Huang Ying <ying.huang@intel.com>, Yang Shi <yang.shi@linux.alibaba.com>, Yosry Ahmed <yosryahmed@google.com>, Tim Chen <tim.c.chen@linux.intel.com>, weixugc@google.com, gthelen@google.com, fvdl@google.com, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Tue, Nov 29, 2022 at 06:03:27PM -0800, Mina Almasry wrote:
[...]
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 7b8e8e43806b..23fc5b523764 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -6735,7 +6735,8 @@ unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
>  unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
>  					   unsigned long nr_pages,
>  					   gfp_t gfp_mask,
> -					   unsigned int reclaim_options)
> +					   unsigned int reclaim_options,
> +					   nodemask_t nodemask)

Can you please make this parameter a nodemask_t* and pass NULL instead
of NODE_MASK_ALL?
