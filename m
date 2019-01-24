From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 2/2] mm: Consider subtrees in memory.events
Date: Thu, 24 Jan 2019 09:22:52 +0100
Message-ID: <20190124082252.GD4087@dhcp22.suse.cz>
References: <20190123223144.GA10798@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190123223144.GA10798@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

On Wed 23-01-19 17:31:44, Chris Down wrote:
> memory.stat and other files already consider subtrees in their output,
> and we should too in order to not present an inconsistent interface.
> 
> The current situation is fairly confusing, because people interacting
> with cgroups expect hierarchical behaviour in the vein of memory.stat,
> cgroup.events, and other files. For example, this causes confusion when
> debugging reclaim events under low, as currently these always read "0"
> at non-leaf memcg nodes, which frequently causes people to misdiagnose
> breach behaviour. The same confusion applies to other counters in this
> file when debugging issues.
> 
> Aggregation is done at write time instead of at read-time since these
> counters aren't hot (unlike memory.stat which is per-page, so it does it
> at read time), and it makes sense to bundle this with the file
> notifications.

I do not think we can do that for two reasons. It breaks the existing
semantic userspace might depend on and more importantly this is not a
correct behavior IMO.

You have to realize that stats are hierarchical because that is how we
account. Events represent a way to inform that something has happened at
the specific level of the tree though. If you do not setup low/high/max
limit then you simply cannot expect to be informed those get hit because
they cannot by definition. Or put it other way, if you are waiting for
those events you really want to know the (sub)tree they happened and if
you propagate the event up the hierarchy you have hard time to tell that
(you would basically have to exclude all but the lowest one and that is
an awkward semantic at best.

Maybe we want to document this better but I do not see we are going to
change the behavior.

> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

btw. I do not see this patch posted anywhere yet it already comes with
an ack. Have I just missed a previous version?
-- 
Michal Hocko
SUSE Labs
