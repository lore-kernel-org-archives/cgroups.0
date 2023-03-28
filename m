From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v1 8/9] vmscan: memcg: sleep when flushing stats during
 reclaim
Date: Tue, 28 Mar 2023 14:49:07 -0400
Message-ID: <ZCM2o8zgNhtgdhij@cmpxchg.org>
References: <20230328061638.203420-1-yosryahmed@google.com>
 <20230328061638.203420-9-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112; t=1680029349;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MHTXhpf5WdLfr15cViMQdFbTg30x0rT0B0hTFtHLctQ=;
        b=A+bhfvmqTQqrdmC67+EygQyWGShN3KOSkBIckR39BPvNI8GfURZ1gozY1+nQ8g2e0m
         jwALDtiRqqvy7Dl6sjQAE+x4uZOoeCwvcdvpQMAFmHxFO9KQeg/CqH4tpOYfL1gF7py3
         B+n9C6BMcKyPaz7fjY1oMPBMIPiwkgZJD2o1gtyoR0aVn76NuZ3ODcG/dQlbntZyKyq6
         Xp7hkl1M8VCln1cL+sIq11V/s6ekKJ+lkdBoRdQoAwlxN14hlHAny4tZFSms6XFgMKTS
         V06rgFWRb/PQ2lg3EQ2mbe6dpaAnFDwTh6qWLNe59V5mvbJ8uoQwqImOyZBKI4BAmbGJ
         bMTQ==
Content-Disposition: inline
In-Reply-To: <20230328061638.203420-9-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Tue, Mar 28, 2023 at 06:16:37AM +0000, Yosry Ahmed wrote:
> Memory reclaim is a sleepable context. Allow sleeping when flushing
> memcg stats to avoid unnecessarily performing a lot of work without
> sleeping. This can slow down reclaim code if flushing stats is taking
> too long, but there is already multiple cond_resched()'s in reclaim
> code.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

Forget what I said about this in the previous patch. :)

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
