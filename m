From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC PATCH 0/8] memcg: Enable fine-grained per process memory
 control
Date: Fri, 21 Aug 2020 21:37:16 +0200
Message-ID: <20200821193716.GU3982@worktop.programming.kicks-ass.net>
References: <20200817140831.30260-1-longman@redhat.com>
 <20200818091453.GL2674@hirez.programming.kicks-ass.net>
 <20200818092617.GN28270@dhcp22.suse.cz>
 <20200818095910.GM2674@hirez.programming.kicks-ass.net>
 <20200818100516.GO28270@dhcp22.suse.cz>
 <20200818101844.GO2674@hirez.programming.kicks-ass.net>
 <20200818134900.GA829964@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=N3ZGTcGJdfl/OTaIgJwrIkHSk+AkqKBFZGMv7k7JAjc=; b=ggzc/B/8OBjbLuwpgTkXf/pU42
        +EOW+Btl5c58I6tA9Tz1DotvxKyQlEce8eaHFx5uPaj+FAJO5eNeSstr8eK32iVfkZX9BRWclAhwZ
        OToYv7Axe6/UemxFJFZtndQZLIFCKFhxZ+MicIpQ8D2ApWwHovB9Qo8srTIBnFpw3chOTGT/K2CGp
        QDl7EaMCU/DeA8Ba3GZGENthYYt7qc6MSlkzrz8gl43DMD/4tUAsV3LVKmPDXUozBTfBOHQo3pvCS
        Lx7OuGNZE83kZvcZUsnl0RTEslw9K9K9Qom8MsixP0YIQpoLJF5WMetdTe20APCXCS1WvfV1v90Sq
        /JStoxmg==;
Content-Disposition: inline
In-Reply-To: <20200818134900.GA829964-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Aug 18, 2020 at 09:49:00AM -0400, Johannes Weiner wrote:
> On Tue, Aug 18, 2020 at 12:18:44PM +0200, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org wrote:
> > What you need is a feeback loop against the rate of freeing pages, and
> > when you near the saturation point, the allocation rate should exactly
> > match the freeing rate.
> 
> IO throttling solves a slightly different problem.
> 
> IO occurs in parallel to the workload's execution stream, and you're
> trying to take the workload from dirtying at CPU speed to rate match
> to the independent IO stream.
> 
> With memory allocations, though, freeing happens from inside the
> execution stream of the workload. If you throttle allocations, you're

For a single task, but even then you're making the argument that we need
to allocate memory to free memory, and we all know where that gets us.

But we're actually talking about a cgroup here, which is a collection of
tasks all doing things in parallel.

> most likely throttling the freeing rate as well. And you'll slow down
> reclaim scanning by the same amount as the page references, so it's
> not making reclaim more successful either. The alloc/use/free
> (im)balance is an inherent property of the workload, regardless of the
> speed you're executing it at.

Arguably seeing the rate drop to near 0 is a very good point to consider
running cgroup-OOM.
