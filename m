From: Michal Hocko <mhocko@suse.com>
Subject: Re: [RFC PATCH 0/8] memcg: Enable fine-grained per process memory
 control
Date: Tue, 18 Aug 2020 12:30:59 +0200
Message-ID: <20200818103059.GP28270@dhcp22.suse.cz>
References: <20200817140831.30260-1-longman@redhat.com>
 <20200818091453.GL2674@hirez.programming.kicks-ass.net>
 <20200818092617.GN28270@dhcp22.suse.cz>
 <20200818095910.GM2674@hirez.programming.kicks-ass.net>
 <20200818100516.GO28270@dhcp22.suse.cz>
 <20200818101844.GO2674@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200818101844.GO2674@hirez.programming.kicks-ass.net>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peterz@infradead.org
Cc: Waiman Long <longman@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Tue 18-08-20 12:18:44, Peter Zijlstra wrote:
> On Tue, Aug 18, 2020 at 12:05:16PM +0200, Michal Hocko wrote:
> > > But then how can it run-away like Waiman suggested?
> > 
> > As Chris mentioned in other reply. This functionality is quite new.
> >  
> > > /me goes look... and finds MEMCG_MAX_HIGH_DELAY_JIFFIES.
> > 
> > We can certainly tune a different backoff delays but I suspect this is
> > not the problem here.
> 
> Tuning? That thing needs throwing out, it's fundamentally buggered. Why
> didn't anybody look at how the I/O drtying thing works first?
> 
> What you need is a feeback loop against the rate of freeing pages, and
> when you near the saturation point, the allocation rate should exactly
> match the freeing rate.
> 
> But this thing has nothing what so ever like that.

Existing usecases seem to be doing fine with the existing
implementation. If we find out that this is insufficient then we can
work on that but I believe this is tangent to this email thread. There
are no indications that the current implementation doesn't throttle
enough. The proposal also aims at much richer interface to define the
oom behavior.
-- 
Michal Hocko
SUSE Labs
