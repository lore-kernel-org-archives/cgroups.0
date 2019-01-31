From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 2/2] mm: Consider subtrees in memory.events
Date: Thu, 31 Jan 2019 09:58:08 +0100
Message-ID: <20190131085808.GO18811@dhcp22.suse.cz>
References: <20190124170117.GS4087@dhcp22.suse.cz>
 <20190124182328.GA10820@cmpxchg.org>
 <20190125074824.GD3560@dhcp22.suse.cz>
 <20190125165152.GK50184@devbig004.ftw2.facebook.com>
 <20190125173713.GD20411@dhcp22.suse.cz>
 <20190125182808.GL50184@devbig004.ftw2.facebook.com>
 <20190128125151.GI18811@dhcp22.suse.cz>
 <20190130192345.GA20957@cmpxchg.org>
 <20190130200559.GI18811@dhcp22.suse.cz>
 <20190130213131.GA13142@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190130213131.GA13142@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>, Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

On Wed 30-01-19 16:31:31, Johannes Weiner wrote:
> On Wed, Jan 30, 2019 at 09:05:59PM +0100, Michal Hocko wrote:
[...]
> > I thought I have already mentioned an example. Say you have an observer
> > on the top of a delegated cgroup hierarchy and you setup limits (e.g. hard
> > limit) on the root of it. If you get an OOM event then you know that the
> > whole hierarchy might be underprovisioned and perform some rebalancing.
> > Now you really do not care that somewhere down the delegated tree there
> > was an oom. Such a spurious event would just confuse the monitoring and
> > lead to wrong decisions.
> 
> You can construct a usecase like this, as per above with OOM, but it's
> incredibly unlikely for something like this to exist. There is plenty
> of evidence on adoption rate that supports this: we know where the big
> names in containerization are; we see the things we run into that have
> not been reported yet etc.
> 
> Compare this to real problems this has already caused for
> us. Multi-level control and monitoring is a fundamental concept of the
> cgroup design, so naturally our infrastructure doesn't monitor and log
> at the individual job level (too much data, and also kind of pointless
> when the jobs are identical) but at aggregate parental levels.
> 
> Because of this wart, we have missed problematic configurations when
> the low, high, max events were not propagated as expected (we log oom
> separately, so we still noticed those). Even once we knew about it, we
> had trouble tracking these configurations down for the same reason -
> the data isn't logged, and won't be logged, at this level.

Yes, I do understand that you might be interested in the hierarchical
accounting.

> Adding a separate, hierarchical file would solve this one particular
> problem for us, but it wouldn't fix this pitfall for all future users
> of cgroup2 (which by all available evidence is still most of them) and
> would be a wart on the interface that we'd carry forever.

I understand even this reasoning but if I have to chose between a risk
of user breakage that would require to reimplement the monitoring or an
API incosistency I vote for the first option. It is unfortunate but this
is the way we deal with APIs and compatibility.

> Adding a note in cgroup-v2.txt doesn't make up for the fact that this
> behavior flies in the face of basic UX concepts that underly the
> hierarchical monitoring and control idea of the cgroup2fs.
> 
> The fact that the current behavior MIGHT HAVE a valid application does
> not mean that THIS FILE should be providing it. It IS NOT an argument
> against this patch here, just an argument for a separate patch that
> adds this functionality in a way that is consistent with the rest of
> the interface (e.g. systematically adding .local files).
> 
> The current semantics have real costs to real users. You cannot
> dismiss them or handwave them away with a hypothetical regression.
> 
> I would really ask you to consider the real world usage and adoption
> data we have on cgroup2, rather than insist on a black and white
> answer to this situation.

Those users requiring the hierarchical beahvior can use the new file
without any risk of breakages so I really do not see why we should
undertake the risk and do it the other way around.
-- 
Michal Hocko
SUSE Labs
