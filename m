From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [BUG] cgroup/workques/fork: deadlock when moving cgroups
Date: Fri, 15 Apr 2016 09:06:01 +0200
Message-ID: <20160415070601.GA32377@dhcp22.suse.cz>
References: <20160413094216.GC5774@pathway.suse.cz>
 <20160413183309.GG3676@htj.duckdns.org>
 <20160413192313.GA30260@dhcp22.suse.cz>
 <20160414175055.GA6794@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160414175055.GA6794@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>, Petr Mladek <pmladek@suse.com>, cgroups@vger.kernel.org, Cyril Hrubis <chrubis@suse.cz>, linux-kernel@vger.kernel.org

On Thu 14-04-16 13:50:55, Johannes Weiner wrote:
> On Wed, Apr 13, 2016 at 09:23:14PM +0200, Michal Hocko wrote:
> > I think we can live without lru_add_drain_all() in the migration path.
> 
> Agreed. Michal, would you care to send a patch to remove it?

Now that I am looking closer I am not sure this would help though.
mem_cgroup_move_charge needs to take mmap_sem for read and keeps looping
until it gets it. What if the mmap_sem holder for write depends on the
work queue code in the same way lru_add_drain_all does? I mean this all
is really fragile.
Tejun was proposing to do the migration async (move the whole
mem_cgroup_move_charge into the work item). This would solve the problem
of course. I haven't checked whether this would be safe but it at least
sounds doable (albeit far from trivial). It would also be a user visible
change because the new memcg will not contain the moved charges after we
return to user space. I think this would be acceptable but if somebody
really relies on the previous behavior I guess we can solve it with a
post_move cgroup callback which would be called from a lockless context.

Anyway, before we go that way, can we at least consider the possibility
of removing the kworker creation dependency on the global rwsem? AFAIU
this locking was added because of the pid controller. Do we even care
about something as volatile as kworkers in the pid controller?

Anyway one way or another I will be travelling until next Friday and
will have only limited time to look into this.
-- 
Michal Hocko
SUSE Labs
