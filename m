From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm: vmscan: do not share cgroup iteration between
 reclaimers
Date: Wed, 14 Aug 2019 10:11:55 +0200
Message-ID: <20190814081155.GQ17933@dhcp22.suse.cz>
References: <20190812192316.13615-1-hannes@cmpxchg.org>
 <20190813132938.GJ17933@dhcp22.suse.cz>
 <20190813171237.GA21743@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190813171237.GA21743@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue 13-08-19 13:12:37, Johannes Weiner wrote:
> On Tue, Aug 13, 2019 at 03:29:38PM +0200, Michal Hocko wrote:
> > On Mon 12-08-19 15:23:16, Johannes Weiner wrote:
[...]
> > > This change completely eliminates the OOM kills on our service, while
> > > showing no signs of overreclaim - no increased scan rates, %sys time,
> > > or abrupt free memory spikes. I tested across 100 machines that have
> > > 64G of RAM and host about 300 cgroups each.
> > 
> > What is the usual direct reclaim involvement on those machines?
> 
> 80-200 kb/s. In general we try to keep this low to non-existent on our
> hosts due to the latency implications. So it's fair to say that kswapd
> does page reclaim, and direct reclaim is a sign of overload.

Well, there are workloads which are much more direct reclaim heavier.
How much they rely on large memcg trees remains to be seen. Your
changelog should state that the above workload is very light on direct
reclaim, though, because the above paragraph suggests that a risk of
longer stalls is really non-issue while I think this is not really all
that clear.
-- 
Michal Hocko
SUSE Labs
