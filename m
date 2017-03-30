From: Tim Murray <timmurray@google.com>
Subject: Re: [RFC 0/1] add support for reclaiming priorities per mem cgroup
Date: Thu, 30 Mar 2017 12:40:32 -0700
Message-ID: <CAEe=SxmpXD=f9N_i+xe6gFUKKUefJYvBd8dSwxSM+7rbBBTniw@mail.gmail.com>
References: <20170317231636.142311-1-timmurray@google.com> <20170330155123.GA3929@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=/xMV0wuKRFiE+5sxQBnmgp4Jm39uld3aS+9qP1fwCfA=;
        b=FTqfUHxZwWAsE0mwObOssP1F+BtIINucV+xDpYLx86JvOR/KlOzy19gHCrc6Bt4yOD
         5jq5sJXT+j+xjX8SmxxvW5+FLyP5c/3QRMJmt4kjw4ZyvoKa63S/PRpz/JuQNC3hx2HY
         nOox0u2SzEAP1TfeumyAqBpFn7P5zmGsR91cNMnHF6apHFkjwiiS1kMxQXpkdRAaiE6j
         O4rFAc1pL/rtS1X9YxvDDR+IFgh0UuOlewvDt1fZ7M6o8m0DfK6BTUTUEFtPPqKq3XEv
         8XxNWB6wT9hwFYZLf9rq/34Op/1inpmGk9aT+kTiexK+fnmVPrNYa23KijlkswfCA65i
         uq+A==
In-Reply-To: <20170330155123.GA3929@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, LKML <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, Linux-MM <linux-mm@kvack.org>, Suren Baghdasaryan <surenb@google.com>, Patrik Torstensson <totte@google.com>, Android Kernel Team <kernel-team@android.com>

On Thu, Mar 30, 2017 at 8:51 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> In cgroup2, we've added a memory.low knob, where groups within their
> memory.low setting are not reclaimed.
>
> You can set that knob on foreground groups to the amount of memory
> they need to function properly, and set it to 0 on background groups.
>
> Have you tried doing that?

I have not, but I'm trying to get that working now to evaluate it on Android.

However, based on other experiences, I don't think it will work well.
We've experimented a lot with different limits in different places
(Java heap limits, hard_reclaim, soft_reclaim) at different times in
the process lifecycle, and the problem has always been that there's no
way for us to know what limit is reasonable. memory.low will have the
same problem. If memory.low is higher than the actual working set of a
foreground process, the system wastes memory (eg, file pages loaded
during app startup that are never used again won't be reclaimed under
pressure). If memory.low is less than the actual working set,
foreground processes will still get hit by thrashing.

Another issue is that the working set varies tremendously from app to
app. An email client's working set may be 1/10 or 1/20 of a camera
running a computational photography pipeline with multiple captures in
flight. I can imagine a case where it makes sense for a foreground
application to take 50-75% of a device's physical memory (the camera
case or something similar), but I hope that's an extreme outlier
compared to most apps on the system. However, high-memory apps are
often the most performance-sensitive, so reclaim is more likely to
cause problems.

As a result, I think there's still a need for relative priority
between mem cgroups, not just an absolute limit.

Does that make sense?

> Both vmpressure and priority levels are based on reclaim efficiency,
> which is problematic on solid state storage because page reads have
> very low latency. It's rare that pages are still locked from the
> read-in by the time reclaim gets to them on the LRU, so efficiency
> tends to stay at 100%, until the system is essentially livelocked.
>
> On solid state storage, the bigger problem when you don't have enough
> memory is that you can reclaim just fine but wait a significant amount
> of time to refault the recently evicted pages, i.e. on thrashing.
>
> A more useful metric for memory pressure at this point is quantifying
> that time you spend thrashing: time the job spends in direct reclaim
> and on the flipside time the job waits for recently evicted pages to
> come back. Combined, that gives you a good measure of overhead from
> memory pressure; putting that in relation to a useful baseline of
> meaningful work done gives you a portable scale of how effictively
> your job is running.

This sounds fantastic, and it matches the behavior I've seen around
pagecache thrashing on Android.

On Android, I think there are three different times where userspace
would do something useful for memory:

1. scan priority is creeping up, scanned/reclaim ratio is getting
worse, system is exhibiting signs of approaching severe memory
pressure. userspace should probably kill something if it's got
something it can kill cheaply.
2. direct reclaim is happening, system is thrashing, things are bad.
userspace should aggressively kill non-critical processes because
performance has already gotten worse.
3. something's gone horribly wrong, oom_killer is imminent: userspace
should kill everything it possibly can to keep the system stable.

My vmpressure experiments have focused on #1 because it integrates
nicely with memcg priorities. However, it doesn't seem like a good
approach for #2 or #3. Time spent thrashing sounds ideal for #2. I'm
not sure what to do for #3. The current critical vmpressure event
hasn't been that successful in avoiding oom-killer (on 3.18, at
least)--I've been able to get oom-killer to trigger without a
vmpressure event.

Assuming that memcg priorities are reasonable, would you be open to
using scan priority info as a vmpressure signal for a low amount of
memory pressure?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
