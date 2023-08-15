From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] mm: memcg: provide accurate stats for userspace reads
Date: Mon, 14 Aug 2023 14:14:18 -1000
Message-ID: <ZNrDWqfjXtAYhnvT@slm.duckdns.org>
References: <CAJD7tkbJ1fnMDudtsS2xubKn0RTWz7t0Hem=PSRQQp3sGf-iOw@mail.gmail.com>
 <ZNaLGVUtPu7Ua/jL@dhcp22.suse.cz>
 <CAJD7tkbF1tNi8v0W4Mnqs0rzpRBshOFepxFTa1SiSvmBEBUEvw@mail.gmail.com>
 <CALvZod55S3XeK-MquTq0mDuipq8j0vFymQeX_XnPb_HuPK+oGQ@mail.gmail.com>
 <CAJD7tkYZxjAHrodVDK=wmz-sULJrq2VhC_5ecRP7T-KiaOcTuw@mail.gmail.com>
 <CALvZod46Cz_=5UgiyAKM+VgKyk=KJCqDqXu91=9uHy7-2wk53g@mail.gmail.com>
 <CAJD7tkY-ezyYebvcs=8Z_zrw2UVW8jf2WvP1G8tu2rT=2sMnAA@mail.gmail.com>
 <CALvZod5fH9xu_+6x85K38f63GfKGWD1LqtD2R4d09xmDtLB7ew@mail.gmail.com>
 <ZNdEaw2nktq1NfmH@dhcp22.suse.cz>
 <CAJD7tkaFHgc3eN1K1wYsQFWMLu4+Frf9DJ-5HOja2nC20Es9Dw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692058461; x=1692663261;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y7Vt7fHEVDI/tRvKfSZv8+YY3N1pXVZVv5h9aG4SLow=;
        b=r1OXbsdN20Nql7iOCvB4NfyObEdbLsL9nlgrwnTfvnVKcQI8gbV1N+qgH0e/L9kBuF
         AqHduK6BI2OUMTB3ZdAvlTFd/GqDiKOtGfwj6Q02TPFRPnXludWFyiz8BzCgIe2F1Yxn
         WKWu5Gu8V+p/1fagMRlnXkmDQa/z9eBZnxzBovukpxrUEpOBtYSaxokm5ghScvcE2bEn
         vwa97+m4bECjS57nq5RzJmtH2sFwwVUzQI9LsfE4kENEQ4DiutXVWtPY4bbMGLpFfUGZ
         e1WvsibWuufO0DXirDHKDr1JqZNPO2tTAdygmXmBS4gtr5KiAUM0WMO/VvFhYOh+oVHk
         T5rg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <CAJD7tkaFHgc3eN1K1wYsQFWMLu4+Frf9DJ-5HOja2nC20Es9Dw@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeelb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

Hello,

On Sat, Aug 12, 2023 at 04:04:32AM -0700, Yosry Ahmed wrote:
> Taking a step back though, and considering there have been other
> complaints about unified flushing causing expensive reads from
> memory.stat [1], I am wondering if we should tackle the fundamental
> problem.
> 
> We have a single global rstat lock for flushing, which protects the
> global per-cgroup counters as far as I understand. A single lock means
> a lot of contention, which is why we implemented unified flushing on
> the memcg side in the first place, where we only let one flusher
> operate and everyone else skip, but that flusher needs to flush the
> entire tree.
> 
> This can be unnecessarily expensive (see [1]), and to avoid how
> expensive it is we sacrifice accuracy (what this patch is about). I am
> exploring breaking down that lock into per-cgroup locks, where a
> flusher acquires locks in a top down fashion. This allows for some
> concurrency in flushing, and makes unified flushing unnecessary. If we
> retire unified flushing we fix both accuracy and expensive reads at
> the same time, while not sacrificing performance for concurrent
> in-kernel flushers.
> 
> What do you think? I am prototyping something now and running some
> tests, it seems promising and simple-ish (unless I am missing a big
> correctness issue).

So, the original design used mutex for synchronize flushing with the idea
being that updates are high freq but reads are low freq and can be
relatively slow. Using rstats for mm internal operations changed this
assumption quite a bit and we ended up switching that mutex with a lock.

Here are some suggestions:

* Update-side, per-cpu lock should be fine. I don't think splitting them
  would buy us anything meaningful.

* Flush-side, maybe we can break flushing into per-cpu or whatnot but
  there's no avoiding the fact that flushing can take quite a while if there
  are a lot to flush whether locks are split or not. I wonder whether it'd
  be possible to go back to mutex for flushing and update the users to
  either consume the cached values or operate in a sleepable context if
  synchronous read is necessary, which is the right thing to do anyway given
  how long flushes can take.

Thanks.

-- 
tejun
