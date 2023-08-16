From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] mm: memcg: provide accurate stats for userspace reads
Date: Wed, 16 Aug 2023 09:08:26 -1000
Message-ID: <ZN0eqq4hLRYQPHCI@slm.duckdns.org>
References: <CAJD7tkYBFz-gZ2QsHxUMT=t0KNXs66S-zzMPebadHx9zaG0Q3w@mail.gmail.com>
 <ZNrITZVTf2EILRJq@slm.duckdns.org>
 <CAJD7tkaXwoF-faApweAmm7Db7jAuS3EO7hVvdyVtqW_rE+T9Vg@mail.gmail.com>
 <ZNrLO5PAEZw4yjI9@slm.duckdns.org>
 <CAJD7tkYgCySTX28zK9GZiWwsabR4nv7M2hQ57y12si-fqtv7zg@mail.gmail.com>
 <CALvZod6KRxiDzrppCgx+=SHg2+96nFE5crwXCKwe9PZbWM_6cQ@mail.gmail.com>
 <CAJD7tkaUzhvZPohpo1F8TUKRPuXH7bjDeg9VCzN2CbywQbRutQ@mail.gmail.com>
 <CALvZod6HUtYhDaXiwXSrcwfxLSrZ37sZhKY1Mg4kmpDFk13aYw@mail.gmail.com>
 <CAJD7tkYzr2cg-aQ899vfqB4jR7iP83t8f-Z4AH8d9iW-yw-nnQ@mail.gmail.com>
 <CALvZod441xBoXzhqLWTZ+xnqDOFkHmvrzspr9NAr+nybqXgS-A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692212909; x=1692817709;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oW5kqtKHBtVyg+Cd9YlZqPw+sEx2elEdwRVNVT4N6wk=;
        b=Gxeh8t9SikI1Mq11KBvKw76Om5qOdzGfIoltkKpAUl4vymSeUkeUy3KcgEcVZONd0o
         ijkR7PG61Z3sSrP7FjFfnMxlSJnkX2ePVH7AQ/YnoJZk/wJ0+/kOSMWT9ggracNjb5eN
         9/0yGwRSVDsvyu6XWfUmnQrNW51C2xDY45mYkllYGl1OMVGJ7vYfJHzRFZWVscJ9AByi
         mKkgeGOShggi0VSnfUbEIE/7BE1SnYI2G1ygiW4yJikjYAJj7oYP7/9G9zUwSBqTezyO
         YubAzVgBcAKx9ORYgcSg6yQUbIJ6DHYMTz3+erxAwxF2kyTXRzbjI6VOswRPo9JyTyB4
         FZig==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <CALvZod441xBoXzhqLWTZ+xnqDOFkHmvrzspr9NAr+nybqXgS-A@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Ivan Babrou <ivan@cloudflare.com>

Hello,

On Wed, Aug 16, 2023 at 10:11:20AM -0700, Shakeel Butt wrote:
> These options are not white and black and there can be something in
> between but let me be very clear on what I don't want and would NACK.

I'm not a big fan of interfaces with hidden states. What you're proposing
isn't strictly that but it's still a bit nasty. So, if we can get by without
doing that, that'd be great.

> I don't want a global sleepable lock which can be taken by potentially
> any application running on the system. We have seen similar global
> locks causing isolation and priority inversion issues in production.
> So, not another lock which needs to be taken under extreme condition
> (reading stats under OOM) by a high priority task (node controller)
> and might be held by a low priority task.

Yeah, this is a real concern. Those priority inversions do occur and can be
serious but causing serious problems under memory pressure usually requires
involving memory allocations and IOs. Here, it's just all CPU. So, at least
in OOM conditions, this shouldn't be in the way (the system wouldn't have
anything else to do anyway).

It is true that this still can lead to priority through CPU competition tho.
However, that problem isn't necessarily solved by what you're suggesting
either unless you want to restrict explicit flushing based on permissions
which is another can of worms.

My preference is not exposing this in user interface. This is mostly arising
from internal implementation details and isn't what users necessarily care
about. There are many things we can do on the kernel side to make trade-offs
among overhead, staleness and priority inversions. If we make this an
explicit userland interface behavior, we get locked into that semantics
which we'll likely regret in some future.

Thanks.

-- 
tejun
