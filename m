From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 8/9] sched/psi: add kernel cmdline parameter
 psi_inner_cgroup
Date: Wed, 3 Aug 2022 15:22:16 -0400
Message-ID: <YurK6MXdJPrV2VYS@cmpxchg.org>
References: <20220721040439.2651-1-zhouchengming@bytedance.com>
 <20220721040439.2651-9-zhouchengming@bytedance.com>
 <Yt7KQc0nnOypB2b2@cmpxchg.org>
 <YuAqWprKd6NsWs7C@slm.duckdns.org>
 <5a3410d6-428d-9ad1-3e5a-01ca805ceeeb@bytedance.com>
 <Yuq3Q6Y9dRnjjcPt@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=c0anUqpP2C7sKweDNx6tz5eeeYeeCajDunQoGL7Ybz0=;
        b=nLaoCQbdkBOJTfuCR3nvXQ6rGDdylxjmz1jZ8Tm+nJhB6uRVEzkJe9J4YvGiaLZJIB
         eWPFrU1LaDhgB2s2lw2eeu9wk/emPqRLAABUjCEPpahzxkyec1saBHzutYUk9LjwCn1W
         NDD4glL0si9CYF94gTQapu1l/uknEiTgOX1JK7P0ZfPvWAntrY41DosPltyCmtNzocQd
         u0y+VnjfLoLyPQNDeLJGLo35kTLX8U7m3Md4z4tb8wRmVQCEoDIBm+JIZRe1M2hFceis
         Nk7XsPtsik05vCUxaU21b6nk/4AzADB2kCAMEgmcUghE3x5ypb3WJtPKnhrzaNTK6OU0
         cJHA==
Content-Disposition: inline
In-Reply-To: <Yuq3Q6Y9dRnjjcPt@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Chengming Zhou <zhouchengming@bytedance.com>, surenb@google.com, mingo@redhat.com, peterz@infradead.org, corbet@lwn.net, akpm@linux-foundation.org, rdunlap@infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com, cgroups@vger.kernel.org

On Wed, Aug 03, 2022 at 07:58:27AM -1000, Tejun Heo wrote:
> Hello,
> 
> On Wed, Aug 03, 2022 at 08:17:22PM +0800, Chengming Zhou wrote:
> > > Assuming the above isn't wrong, if we can figure out how we can re-enable
> > > it, which is more difficult as the counters need to be resynchronized with
> > > the current state, that'd be ideal. Then, we can just allow each cgroup to
> > > enable / disable PSI reporting dynamically as they see fit.
> > 
> > This method is more fine-grained but more difficult like you said above.
> > I think it may meet most needs to disable PSI stats in intermediate cgroups?
> 
> So, I'm not necessarily against implementing something easier but we at
> least wanna get the interface right, so that if we decide to do the full
> thing later we can easily expand on the existing interface. ie. let's please
> not be too hacky. I don't think it'd be that difficult to implement
> per-cgroup disable-only operation that we can later expand to allow
> re-enabling, right?

It should be relatively straight-forward to disable and re-enable
state aggregation, time tracking, averaging on a per-cgroup level, if
we can live with losing history from while it was disabled. I.e. the
avgs will restart from 0, total= will have gaps - should be okay, IMO.

Where it gets trickier is also stopping the tracking of task counts in
a cgroup. For re-enabling afterwards, we'd have to freeze scheduler
and cgroup state and find all tasks of interest across all CPUs for
the given cgroup to recreate the counts. I'm not quite sure whether
that's feasible, and if so, whether it's worth the savings.

It might be good to benchmark the two disabling steps independently.
Maybe stopping aggregation while keeping task counts is good enough,
and we can commit to a disable/re-enable interface from the start.

Or maybe it's all in the cachelines and iteration, and stopping the
aggregation while still writing task counts isn't saving much. In that
case we'd have to look closer at reconstructing task counts, to see if
later re-enabling is actually a practical option or whether a one-off
kill switch is more realistic.

Chengming, can you experiment with disabling: record_times(), the
test_state() loop and state_mask construction, and the averaging
worker - while keeping the groupc->tasks updates?
