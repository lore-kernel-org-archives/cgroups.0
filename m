From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 0/8] memcg: Enable fine-grained per process memory
 control
Date: Thu, 20 Aug 2020 16:11:12 +1000
Message-ID: <20200820061112.GA7728@dread.disaster.area>
References: <20200817140831.30260-1-longman@redhat.com>
 <20200818091453.GL2674@hirez.programming.kicks-ass.net>
 <20200818092737.GA148695@chrisdown.name>
 <20200818100444.GN2674@hirez.programming.kicks-ass.net>
 <20200818125559.GP17456@casper.infradead.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200818125559.GP17456@casper.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: peterz@infradead.org, Chris Down <chris@chrisdown.name>, Waiman Long <longman@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Tue, Aug 18, 2020 at 01:55:59PM +0100, Matthew Wilcox wrote:
> On Tue, Aug 18, 2020 at 12:04:44PM +0200, peterz@infradead.org wrote:
> > On Tue, Aug 18, 2020 at 10:27:37AM +0100, Chris Down wrote:
> > > peterz@infradead.org writes:
> > > > On Mon, Aug 17, 2020 at 10:08:23AM -0400, Waiman Long wrote:
> > > > > Memory controller can be used to control and limit the amount of
> > > > > physical memory used by a task. When a limit is set in "memory.high" in
> > > > > a v2 non-root memory cgroup, the memory controller will try to reclaim
> > > > > memory if the limit has been exceeded. Normally, that will be enough
> > > > > to keep the physical memory consumption of tasks in the memory cgroup
> > > > > to be around or below the "memory.high" limit.
> > > > > 
> > > > > Sometimes, memory reclaim may not be able to recover memory in a rate
> > > > > that can catch up to the physical memory allocation rate. In this case,
> > > > > the physical memory consumption will keep on increasing.
> > > > 
> > > > Then slow down the allocator? That's what we do for dirty pages too, we
> > > > slow down the dirtier when we run against the limits.
> > > 
> > > We already do that since v5.4. I'm wondering whether Waiman's customer is
> > > just running with a too-old kernel without 0e4b01df865 ("mm, memcg: throttle
> > > allocators when failing reclaim over memory.high") backported.
> > 
> > That commit is fundamentally broken, it doesn't guarantee anything.
> > 
> > Please go read how the dirty throttling works (unless people wrecked
> > that since..).
> 
> Of course they did.
> 
> https://lore.kernel.org/linux-mm/ce7975cd-6353-3f29-b52c-7a81b1d07caa@kernel.dk/

Different thing. That's memory reclaim throttling, not dirty page
throttling.  balance_dirty_pages() still works just fine as it does
not look at device congestion. page cleaning rate is accounted in
test_clear_page_writeback(), page dirtying rate is accounted
directly in balance_dirty_pages(). That feedback loop has not been
broken...

And I compeltely agree with Peter here - the control theory we
applied to the dirty throttling problem is still 100% valid and so
the algorithm still just works all these years later. I've only been
saying that allocation should use the same feedback model for
reclaim throttling since ~2011...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
