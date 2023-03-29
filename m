From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 1/7] cgroup: rstat: only disable interrupts for the
 percpu lock
Date: Wed, 29 Mar 2023 08:53:02 -1000
Message-ID: <ZCSJDpPPOVvBYfOy@slm.duckdns.org>
References: <20230323040037.2389095-1-yosryahmed@google.com>
 <20230323040037.2389095-2-yosryahmed@google.com>
 <ZBz/V5a7/6PZeM7S@slm.duckdns.org>
 <CAJD7tkYNZeEytm_Px9_73Y-AYJfHAxaoTmmnO71HW5hd1B5tPg@mail.gmail.com>
 <ZB5UalkjGngcBDEJ@slm.duckdns.org>
 <CAJD7tkYhyMkD8SFf8b8L1W9QUrLOdw-HJ2NUbENjw5dgFnH3Aw@mail.gmail.com>
 <CALvZod6rF0D21hcV7xnqD+oRkn=x5NLi5GOkPpyaPa859uDH+Q@mail.gmail.com>
 <CAJD7tkY_ESpMYMw72bsATpp6tPphv8qS6VbfEUjpKZW6vUqQSQ@mail.gmail.com>
 <CALvZod41ecuCKmuFBNtAjoKJjQgWYzoe4_B8zRK37HYk-rYDkA@mail.gmail.com>
 <CAJD7tkZrp=4zWvjE9_010TAG1T_crCbf9P64UzJABspgcrGPKg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680115984;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Iy+lCmVSfuCqZYe5m364REzCKXPfLlS/vXZ6Sv33Scc=;
        b=mOxPMiQc+w/5rfTRi9mFKJkmmWrWC+fsE86SxcySPbUJ/wuSW6AldTRs3OGXZtwHWv
         n75hgfb8Jx+JCDbIxrNwCNhfHbchPfWDoQgDmRZL3hRgD1A1QjHOFPi/idbqob30n3+o
         RfxqdtblWXtXCCQwP77ubsHpTykfAuRiiY2lmCEIRhp/1xZEWZJAWmKKb366YikERsZy
         b49+3GyAT5iO8CVbUWnbgaKvTSxLC1ZUui2x/A7empu+BSJ09ps4+rHLpazMy4Z/WTbC
         7GovkOPkWDIYzMqS73vSWspbX6vZMVT+mWaCOhZRpJ0uPCggyCfuI4KlNvWHIo+z094h
         3zKA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <CAJD7tkZrp=4zWvjE9_010TAG1T_crCbf9P64UzJABspgcrGPKg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Shakeel Butt <shakeelb@google.com>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

Hello, Yosry.

On Mon, Mar 27, 2023 at 04:23:13PM -0700, Yosry Ahmed wrote:
> Tejun, if having the lock be non-irq is a non-starter for you, I can

This is an actual hazard. We see in prod these unprotected locks causing
very big spikes in tail latencies and they can be tricky to root cause too
and given the way rstat lock is used it's highly likely to be involved in
those scenarios with the proposed change, so it's gonna be a nack from my
end.

> send a patch that instead gives up the lock and reacquires it at every
> CPU boundary unconditionally -- or perhaps every N CPU boundaries to
> avoid excessively releasing and reacquiring the lock.

I'd just do the simple thing and see whether there's any perf penalty before
making it complicated. I'd be pretty surprised if unlocking and relocking
the same spinlock adds any noticeable overhead here.

Thanks.

-- 
tejun
