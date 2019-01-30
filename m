From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 2/2] mm: Consider subtrees in memory.events
Date: Wed, 30 Jan 2019 17:50:58 +0100
Message-ID: <20190130165058.GA18811@dhcp22.suse.cz>
References: <20190128125151.GI18811@dhcp22.suse.cz>
 <20190128142816.GM50184@devbig004.ftw2.facebook.com>
 <20190128145210.GM18811@dhcp22.suse.cz>
 <20190128145407.GP50184@devbig004.ftw2.facebook.com>
 <20190128151859.GO18811@dhcp22.suse.cz>
 <20190128154150.GQ50184@devbig004.ftw2.facebook.com>
 <20190128170526.GQ18811@dhcp22.suse.cz>
 <20190128174905.GU50184@devbig004.ftw2.facebook.com>
 <20190129144306.GO18811@dhcp22.suse.cz>
 <20190129145240.GX50184@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190129145240.GX50184@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

On Tue 29-01-19 06:52:40, Tejun Heo wrote:
> Hello,
> 
> On Tue, Jan 29, 2019 at 03:43:06PM +0100, Michal Hocko wrote:
> > All memcg events are represented non-hierarchical AFAICS
> > memcg_memory_event() simply accounts at the level when it happens. Or do
> > I miss something? Or are you talking about .events files for other
> > controllers?
> 
> Yeah, cgroup.events and .stat files as some of the local stats would
> be useful too, so if we don't flip memory.events we'll end up with sth
> like cgroup.events.local, memory.events.tree and memory.stats.local,
> which is gonna be hilarious.

Why cannot we simply have memory.events_tree and be done with it? Sure
the file names are not goin to be consistent which is a minus but that
ship has already sailed some time ago.

> If you aren't willing to change your mind, the only option seems to be
> introducing a mount option to gate the flip and additions of local
> files.  Most likely, userspace will enable the option by default
> everywhere, so the end result will be exactly the same but I guess
> it'll better address your concern.

How does the consumer of the API learns about the mount type?
-- 
Michal Hocko
SUSE Labs
