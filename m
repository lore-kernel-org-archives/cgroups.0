From: peterz@infradead.org
Subject: Re: [RFC PATCH 0/8] memcg: Enable fine-grained per process memory
 control
Date: Tue, 18 Aug 2020 12:04:44 +0200
Message-ID: <20200818100444.GN2674@hirez.programming.kicks-ass.net>
References: <20200817140831.30260-1-longman@redhat.com>
 <20200818091453.GL2674@hirez.programming.kicks-ass.net>
 <20200818092737.GA148695@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pE8vmQW7SZy0+JnQJV6um55H7ktisT4GBi3Ij24COKw=; b=Ec+Zcl4xLw+ZX6xKNyn+LxSmLG
        EZ0TRWdmzTaNznp3475KXmL3ObxYB8nifTSAaMXiLeZUks0Nj5dKNXO1Xn7KLLyXdVmocwwsjI4lS
        vle42FQMDNCGwBA718/gxyq2awU9AUycF2AWtY7YvO2anUpmOw2nxD9NNLylDwT1Y8AgDnFt0tIMK
        aXjKb+XCYELLhPQAQvh3b4tpgmLWW2qDfIU9Sookz16wBzOHVP9oWOoFLBkp/Z9O3ds+gd5jHL6Rv
        yKky0b51qKBgFHHFuKF0rKJf3lONp/eBNtXBzBQs52mYwF+8Rn0gH3SW7XRRift4xDJ6wOYiRrsi7
        klLCmhAg==;
Content-Disposition: inline
In-Reply-To: <20200818092737.GA148695@chrisdown.name>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris@chrisdown.name>
Cc: Waiman Long <longman@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Tue, Aug 18, 2020 at 10:27:37AM +0100, Chris Down wrote:
> peterz@infradead.org writes:
> > On Mon, Aug 17, 2020 at 10:08:23AM -0400, Waiman Long wrote:
> > > Memory controller can be used to control and limit the amount of
> > > physical memory used by a task. When a limit is set in "memory.high" in
> > > a v2 non-root memory cgroup, the memory controller will try to reclaim
> > > memory if the limit has been exceeded. Normally, that will be enough
> > > to keep the physical memory consumption of tasks in the memory cgroup
> > > to be around or below the "memory.high" limit.
> > > 
> > > Sometimes, memory reclaim may not be able to recover memory in a rate
> > > that can catch up to the physical memory allocation rate. In this case,
> > > the physical memory consumption will keep on increasing.
> > 
> > Then slow down the allocator? That's what we do for dirty pages too, we
> > slow down the dirtier when we run against the limits.
> 
> We already do that since v5.4. I'm wondering whether Waiman's customer is
> just running with a too-old kernel without 0e4b01df865 ("mm, memcg: throttle
> allocators when failing reclaim over memory.high") backported.

That commit is fundamentally broken, it doesn't guarantee anything.

Please go read how the dirty throttling works (unless people wrecked
that since..).
