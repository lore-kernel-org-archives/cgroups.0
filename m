From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 8/9] sched/psi: add kernel cmdline parameter
 psi_inner_cgroup
Date: Tue, 26 Jul 2022 07:54:34 -1000
Message-ID: <YuAqWprKd6NsWs7C@slm.duckdns.org>
References: <20220721040439.2651-1-zhouchengming@bytedance.com>
 <20220721040439.2651-9-zhouchengming@bytedance.com>
 <Yt7KQc0nnOypB2b2@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=DFgeZNTjRjBYgNmkhdouEdidU0qh0nBq3Cx2lZF1bjo=;
        b=CwrXMvt6/2k2vhgXq2Vb5DoxMilL8fBFiWso9p0CwMybnJwusgl9XqfCmfL15TCl/f
         YO5t7j9otoleOuTxlsKptSB13ABGonnW0GPUIS+uJYv/KPEJI3j4aJ/DtNBD8Pm0JAxr
         dBjWNczvJno4T49bQoez0qCGdPbHxMN/MSz3IvTKlsDq6A/StReJkCFryjZ9J/mjme06
         sXd0PRLlqo6DYc57xeeYIBSiV6psMdtqGem+lhK6UtyvHa1s2UFzW3Y2xnRvTScWajy1
         qVHrNKaL1jqhqbmuoEooMh2JbJgjKpWnzfD58J0gqQf58R3RPlcvmbjpNbpRi+zPEh/H
         29Xg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <Yt7KQc0nnOypB2b2@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <zhouchengming@bytedance.com>, surenb@google.com, mingo@redhat.com, peterz@infradead.org, corbet@lwn.net, akpm@linux-foundation.org, rdunlap@infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com, cgroups@vger.kernel.org

Hello,

On Mon, Jul 25, 2022 at 12:52:17PM -0400, Johannes Weiner wrote:
> On Thu, Jul 21, 2022 at 12:04:38PM +0800, Chengming Zhou wrote:
> > PSI accounts stalls for each cgroup separately and aggregates it
> > at each level of the hierarchy. This may case non-negligible overhead
> > for some workloads when under deep level of the hierarchy.
> > 
> > commit 3958e2d0c34e ("cgroup: make per-cgroup pressure stall tracking configurable")
> > make PSI to skip per-cgroup stall accounting, only account system-wide
> > to avoid this each level overhead.
> > 
> > For our use case, we also want leaf cgroup PSI accounted for userspace
> > adjustment on that cgroup, apart from only system-wide management.
> 
> I hear the overhead argument. But skipping accounting in intermediate
> levels is a bit odd and unprecedented in the cgroup interface. Once we
> do this, it's conceivable people would like to do the same thing for
> other stats and accounting, like for instance memory.stat.
> 
> Tejun, what are your thoughts on this?

Given that PSI requires on-the-spot recursive accumulation unlike other
stats, it can add quite a bit of overhead, so I'm sympathetic to the
argument because PSI can't be made cheaper by kernel being better (or at
least we don't know how to yet).

That said, "leaf-only" feels really hacky to me. My memory is hazy but
there's nothing preventing any cgroup from being skipped over when updating
PSI states, right? The state count propagation is recursive but it's each
task's state being propagated upwards not the child cgroup's, so we can skip
over any cgroup arbitrarily. ie. we can at least turn off PSI reporting on
any given cgroup without worrying about affecting others. Am I correct?

Assuming the above isn't wrong, if we can figure out how we can re-enable
it, which is more difficult as the counters need to be resynchronized with
the current state, that'd be ideal. Then, we can just allow each cgroup to
enable / disable PSI reporting dynamically as they see fit.

Thanks.

-- 
tejun
