From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v1 3/9] memcg: do not flush stats in irq context
Date: Tue, 28 Mar 2023 13:43:39 -0400
Message-ID: <ZCMnS8LWXQ4I6vYD@cmpxchg.org>
References: <20230328061638.203420-1-yosryahmed@google.com>
 <20230328061638.203420-4-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112; t=1680025420;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9pG4ykKXTPasFcUZIf/e8S9vCCN31pN+vneMGpJbP4o=;
        b=56M5bOM/pNtngeUWBHnxJY71NBq4XowDWZ8RCfQNb/yCxXYYMrgyYMqobQXbL4C2JB
         RGGu/tdd2jHQlnibWvl6Yl2Z+V9C6/sqQqYlpBk4QH75MtYWG0vntrQt7EbpI3qbQira
         FHF9oSn85isHlRZq305s1ZjPBaMG8ngitCC5W0QK+URXlKcrqGLcbNcKDtVwKwQLiwbR
         WMQuohmUWWq5bvjuyfeOZWbD0dG18QNgGsHHriTK1OT4ETrZ393Glp5m0QCwsT84vxCX
         wa9EQLvH3eVpihWS8y/qQIMRwHoKRu5ba4FiqWeWAVMZkZoYdAYv+LAzhrhkCBMtOsOj
         R8JA==
Content-Disposition: inline
In-Reply-To: <20230328061638.203420-4-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Tue, Mar 28, 2023 at 06:16:32AM +0000, Yosry Ahmed wrote:
> Currently, the only context in which we can invoke an rstat flush from
> irq context is through mem_cgroup_usage() on the root memcg when called
> from memcg_check_events(). An rstat flush is an expensive operation that
> should not be done in irq context, so do not flush stats and use the
> stale stats in this case.
> 
> Arguably, usage threshold events are not reliable on the root memcg
> anyway since its usage is ill-defined.
> 
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Suggested-by: Shakeel Butt <shakeelb@google.com>
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

Excellent, thanks!

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
