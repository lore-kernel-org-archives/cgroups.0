From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 2/2] mm: Consider subtrees in memory.events
Date: Tue, 29 Jan 2019 15:43:06 +0100
Message-ID: <20190129144306.GO18811@dhcp22.suse.cz>
References: <20190125173713.GD20411@dhcp22.suse.cz>
 <20190125182808.GL50184@devbig004.ftw2.facebook.com>
 <20190128125151.GI18811@dhcp22.suse.cz>
 <20190128142816.GM50184@devbig004.ftw2.facebook.com>
 <20190128145210.GM18811@dhcp22.suse.cz>
 <20190128145407.GP50184@devbig004.ftw2.facebook.com>
 <20190128151859.GO18811@dhcp22.suse.cz>
 <20190128154150.GQ50184@devbig004.ftw2.facebook.com>
 <20190128170526.GQ18811@dhcp22.suse.cz>
 <20190128174905.GU50184@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190128174905.GU50184@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

On Mon 28-01-19 09:49:05, Tejun Heo wrote:
> Hello, Michal.
> 
> On Mon, Jan 28, 2019 at 06:05:26PM +0100, Michal Hocko wrote:
> > Yeah, that is quite clear. But it also assumes that the hierarchy is
> > pretty stable but cgroups might go away at any time. I am not saying
> > that the aggregated events are not useful I am just saying that it is
> > quite non-trivial to use and catch all potential corner cases. Maybe I
> 
> It really isn't complicated and doesn't require stable subtree.
> 
> > am overcomplicating it but one thing is quite clear to me. The existing
> > semantic is really useful to watch for the reclaim behavior at the
> > current level of the tree. You really do not have to care what is
> > happening in the subtree when it is clear that the workload itself
> > is underprovisioned etc. Considering that such a semantic already
> > existis, somebody might depend on it and we likely want also aggregated
> > semantic then I really do not see why to risk regressions rather than
> > add a new memory.hierarchy_events and have both.
> 
> The problem then is that most other things are hierarchical including
> some fields in .events files, so if we try to add local stats and
> events, there's no good way to add them.

All memcg events are represented non-hierarchical AFAICS
memcg_memory_event() simply accounts at the level when it happens. Or do
I miss something? Or are you talking about .events files for other
controllers?
-- 
Michal Hocko
SUSE Labs
