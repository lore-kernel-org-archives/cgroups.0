From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 2/2] mm: Consider subtrees in memory.events
Date: Wed, 30 Jan 2019 21:05:59 +0100
Message-ID: <20190130200559.GI18811@dhcp22.suse.cz>
References: <20190124082252.GD4087@dhcp22.suse.cz>
 <20190124160009.GA12436@cmpxchg.org>
 <20190124170117.GS4087@dhcp22.suse.cz>
 <20190124182328.GA10820@cmpxchg.org>
 <20190125074824.GD3560@dhcp22.suse.cz>
 <20190125165152.GK50184@devbig004.ftw2.facebook.com>
 <20190125173713.GD20411@dhcp22.suse.cz>
 <20190125182808.GL50184@devbig004.ftw2.facebook.com>
 <20190128125151.GI18811@dhcp22.suse.cz>
 <20190130192345.GA20957@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190130192345.GA20957@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>, Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

On Wed 30-01-19 14:23:45, Johannes Weiner wrote:
> On Mon, Jan 28, 2019 at 01:51:51PM +0100, Michal Hocko wrote:
> > On Fri 25-01-19 10:28:08, Tejun Heo wrote:
> > > On Fri, Jan 25, 2019 at 06:37:13PM +0100, Michal Hocko wrote:
> > > > Please note that I understand that this might be confusing with the rest
> > > > of the cgroup APIs but considering that this is the first time somebody
> > > > is actually complaining and the interface is "production ready" for more
> > > > than three years I am not really sure the situation is all that bad.
> > > 
> > > cgroup2 uptake hasn't progressed that fast.  None of the major distros
> > > or container frameworks are currently shipping with it although many
> > > are evaluating switching.  I don't think I'm too mistaken in that we
> > > (FB) are at the bleeding edge in terms of adopting cgroup2 and its
> > > various new features and are hitting these corner cases and oversights
> > > in the process.  If there are noticeable breakages arising from this
> > > change, we sure can backpaddle but I think the better course of action
> > > is fixing them up while we can.
> > 
> > I do not really think you can go back. You cannot simply change semantic
> > back and forth because you just break new users.
> > 
> > Really, I do not see the semantic changing after more than 3 years of
> > production ready interface. If you really believe we need a hierarchical
> > notification mechanism for the reclaim activity then add a new one.
> 
> This discussion needs to be more nuanced.
> 
> We change interfaces and user-visible behavior all the time when we
> think nobody is likely to rely on it. Sometimes we change them after
> decades of established behavior - for example the recent OOM killer
> change to not kill children over parents.

That is an implementation detail of a kernel internal functionality.
Most of changes in the kernel tend to have user visible effects. This is
not what we are discussing here. We are talking about a change of user
visibile API semantic change. And that is a completely different story.

> The argument was made that it's very unlikely that we break any
> existing user setups relying specifically on this behavior we are
> trying to fix. I don't see a real dispute to this, other than a
> repetition of "we can't change it after three years".
> 
> I also don't see a concrete description of a plausible scenario that
> this change might break.
> 
> I would like to see a solid case for why this change is a notable risk
> to actual users (interface age is not a criterium for other changes)
> before discussing errata solutions.

I thought I have already mentioned an example. Say you have an observer
on the top of a delegated cgroup hierarchy and you setup limits (e.g. hard
limit) on the root of it. If you get an OOM event then you know that the
whole hierarchy might be underprovisioned and perform some rebalancing.
Now you really do not care that somewhere down the delegated tree there
was an oom. Such a spurious event would just confuse the monitoring and
lead to wrong decisions.
-- 
Michal Hocko
SUSE Labs
