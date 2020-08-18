From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC PATCH 0/8] memcg: Enable fine-grained per process memory
 control
Date: Tue, 18 Aug 2020 13:55:59 +0100
Message-ID: <20200818125559.GP17456@casper.infradead.org>
References: <20200817140831.30260-1-longman@redhat.com>
 <20200818091453.GL2674@hirez.programming.kicks-ass.net>
 <20200818092737.GA148695@chrisdown.name>
 <20200818100444.GN2674@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Mnr9o5vomenMnjGSwOgADsZNSiDQs16XxuJQkA6pw7A=; b=pUGj2IxnkHV9vZueIpbwqji2Jz
        4osZe4zjTl6vy8j4O1GqSzuht1xZTlDq/nyo7Zt88MLI0EF3+bRsp7khSHVkul6jXPUt6jbUcGgqX
        wB2TcbFBTZRD44Iz4OBsNLp9tT2pWHDXZxgDCYE1sqJxFC8/2qUdR7Gr5kHMA+fihdG3Xd3EPQgs3
        1Yi3ukQgtyCHWgNKqxRmqGQFa7YJ77FBhxgwcSBJ0sTftYxwm0Zr5Kz0hFwQ+NrV3N+Gfdg3tiPoG
        TFHH6wJpI5/01cnU9Z5jhHgml1eM1Aji19CV+ORA8lxPNw/zaz+KJse0bAZLt4mKIZPP3ziA3p9kW
        bOdS3v4g==;
Content-Disposition: inline
In-Reply-To: <20200818100444.GN2674-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Aug 18, 2020 at 12:04:44PM +0200, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org wrote:
> On Tue, Aug 18, 2020 at 10:27:37AM +0100, Chris Down wrote:
> > peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org writes:
> > > On Mon, Aug 17, 2020 at 10:08:23AM -0400, Waiman Long wrote:
> > > > Memory controller can be used to control and limit the amount of
> > > > physical memory used by a task. When a limit is set in "memory.high" in
> > > > a v2 non-root memory cgroup, the memory controller will try to reclaim
> > > > memory if the limit has been exceeded. Normally, that will be enough
> > > > to keep the physical memory consumption of tasks in the memory cgroup
> > > > to be around or below the "memory.high" limit.
> > > > 
> > > > Sometimes, memory reclaim may not be able to recover memory in a rate
> > > > that can catch up to the physical memory allocation rate. In this case,
> > > > the physical memory consumption will keep on increasing.
> > > 
> > > Then slow down the allocator? That's what we do for dirty pages too, we
> > > slow down the dirtier when we run against the limits.
> > 
> > We already do that since v5.4. I'm wondering whether Waiman's customer is
> > just running with a too-old kernel without 0e4b01df865 ("mm, memcg: throttle
> > allocators when failing reclaim over memory.high") backported.
> 
> That commit is fundamentally broken, it doesn't guarantee anything.
> 
> Please go read how the dirty throttling works (unless people wrecked
> that since..).

Of course they did.

https://lore.kernel.org/linux-mm/ce7975cd-6353-3f29-b52c-7a81b1d07caa-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org/
