From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Wed, 19 Aug 2015 09:41:13 -0700
Message-ID: <20150819164113.GB20716@mtj.duckdns.org>
References: <1438641689-14655-1-git-send-email-tj@kernel.org>
 <1438641689-14655-4-git-send-email-tj@kernel.org>
 <20150804090711.GL25159@twins.programming.kicks-ass.net>
 <20150804151017.GD17598@mtj.duckdns.org>
 <20150805091036.GT25159@twins.programming.kicks-ass.net>
 <20150805143132.GK17598@mtj.duckdns.org>
 <CAPM31RJTf0v=2v90kN6-HM9xUGab_k++upO0Ym=irmfO9+BbFw@mail.gmail.com>
 <CAPM31R+5=4bGQo++PrYoFuS86_7JqhhQ0OtPvCYooAzJsvhb=w@mail.gmail.com>
 <20150818203117.GC15739@mtj.duckdns.org>
 <1439954620.3479.30.camel@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=hDNTFUTT0Ock9WaLHTLWlGA1XkYBKx0aaqE2b8dqzgU=;
        b=Q8iw7+Rr0nYaBxE4mc+mdUZSKU7Rdu1Yvw2c91qUgPg6inWnTFcX7wR+FEY7jLI5KR
         KZoQR3bOaGaeNkKPFRBX8y5kmqsYXl9w2no5xopt8s44niN5ny7eWLfGWunxi0Z4SZv8
         9f7NFiH8n1CgmEBiePRIJd7l3Gvp1wpcGWyCmrEjnKJBcnk9U/7YLY5J1HRTIgTBT59T
         WaWqWPGpp2ukTO4e0KgA9qBBK7J0/yk6qWu/RVM21FmzOYPKKitsgo/fKvoySCXaZjrH
         3UGH57eAK7QrZCFq4i1dbWAqtPsa84KpQ2B1c2tPx4Cs75jP/TixCl7ynFkiac6JDfba
         D1JA==
Content-Disposition: inline
In-Reply-To: <1439954620.3479.30.camel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello, Mike.

On Wed, Aug 19, 2015 at 05:23:40AM +0200, Mike Galbraith wrote:
> Hm.  I know of a big data outfit to which attach/detach performance was
> important enough for them to have plucked an old experimental overhead
> reduction hack (mine) off lkml, and shipped it.  It must have mattered a
> LOT for them (not suicidal crash test dummies) to have done that.

There haven't been any guidelines on cgroup usage.  Of course people
have been developing in all directions.  It's a natural learning
process and there are use cases which can be served by migrating
processes back and forth.  Nobody is trying to prevent that; however,
if one examines how resources and their associations need to be
tracked for accounting and control, it's evident that there are
inherent trade-offs between migration and the stuff which happens
while not migrating and it's clear which side is more important.

Most problems can be solved in different ways and I'm doubtful that
e.g. bouncing jobs to worker threads would be more expensive than
migrating the worker back and forth in a lot of cases.  If migrating
threads around floats somebody's boat, that's fine but that has never
been and can't be the focus of design and optimization, not at the
cost of the actual hot paths.

Thanks.

-- 
tejun
