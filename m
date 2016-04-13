From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [BUG] cgroup/workques/fork: deadlock when moving cgroups
Date: Wed, 13 Apr 2016 21:48:21 +0200
Message-ID: <20160413194820.GC30260@dhcp22.suse.cz>
References: <20160413094216.GC5774@pathway.suse.cz>
 <20160413183309.GG3676@htj.duckdns.org>
 <20160413192313.GA30260@dhcp22.suse.cz>
 <20160413193734.GC20142@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160413193734.GC20142@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>, cgroups@vger.kernel.org, Cyril Hrubis <chrubis@suse.cz>, linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>

On Wed 13-04-16 15:37:34, Tejun Heo wrote:
> Hello, Michal.
> 
> On Wed, Apr 13, 2016 at 09:23:14PM +0200, Michal Hocko wrote:
> > I think we can live without lru_add_drain_all() in the migration path.
> > We are talking about 4 pagevecs so 56 pages. The charge migration is
> 
> Ah, nice.
> 
> > racy anyway. What concerns me more is how all this is fragile. It sounds
> > just too easy to add a dependency on per-cpu sync work later and
> > reintroduce this issue which is quite hard to detect.
> > Cannot we come up with something more robust?  Or at least warn when we
> > try to use per-cpu workers with problematic locks held?
> 
> Yeah, workqueue does limited lockdep annotation but it doesn't
> integrate fully with the rest of dependency tracking.  It'd be nice to
> have that.  Don't know how to tho.

I was thinking about something like flush_per_cpu_work() which would
assert on group_threadgroup_rwsem held for write. But this still sounds
suboptimal to me. Do we really have to do
cgroup_threadgroup_change_begin for kworker threads? They are
PF_NO_SETAFFINITY so they cannot be moved AFAIR. Or am I missing
something?

-- 
Michal Hocko
SUSE Labs
