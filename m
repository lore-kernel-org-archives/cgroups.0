From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Mon, 24 Aug 2015 17:02:23 -0400
Message-ID: <20150824210223.GH28944@mtj.duckdns.org>
References: <20150805091036.GT25159@twins.programming.kicks-ass.net>
 <20150805143132.GK17598@mtj.duckdns.org>
 <CAPM31RJTf0v=2v90kN6-HM9xUGab_k++upO0Ym=irmfO9+BbFw@mail.gmail.com>
 <CAPM31R+5=4bGQo++PrYoFuS86_7JqhhQ0OtPvCYooAzJsvhb=w@mail.gmail.com>
 <20150818203117.GC15739@mtj.duckdns.org>
 <CAPM31RJNy3jgG=DYe6GO=wyL4BPPxwUm1f2S6YXacQmo7viFZA@mail.gmail.com>
 <20150822182916.GE20768@mtj.duckdns.org>
 <55DB3C76.5010009@gmail.com>
 <20150824170427.GA27262@mtj.duckdns.org>
 <CAPM31RJi07qs42YsH=4JQSbZ+J-zCLv8e7yELb3tF_qAZmLqRA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=pW/flvJwO1/XVBnXtIYDILhDrtJHFLF3ptB20eiJm8I=;
        b=WzXjJymmECAgQAZR782iizTpSADN5ql/W7Dk94Irc3n0uQe/qIQxuLq3HzpvY+67CH
         7yqM5CKynw7i2+GiIy9bk9cojjibdPMXEQF6ydW88F6KfkALxJ0GzMzMDwweVZR+8Fq+
         FJK6vNx6uJBm8J2uk+JiO1fYprf+7Jt9etwxnz7W6gRZZZ3zHKhYlDgDCcfn6ePRqddu
         HStnsV1wHCgY5wxi6dy1vShDvuW/ynhygy7RyOMGNJyfwExaR89tqcz7UdII58x+GMK5
         bMne0ZkaDJcGY/wM3vgRCp/3NWBIVCf5JrESmgJiiOjhvAMsNtIVvIFBuKCyykx6Lx5R
         qwqA==
Content-Disposition: inline
In-Reply-To: <CAPM31RJi07qs42YsH=4JQSbZ+J-zCLv8e7yELb3tF_qAZmLqRA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello,

On Mon, Aug 24, 2015 at 01:54:08PM -0700, Paul Turner wrote:
> > That alone doesn't require hierarchical resource distribution tho.
> > Setting nice levels reasonably is likely to alleviate most of the
> > problem.
> 
> Nice is not sufficient here.  There could be arbitrarily many threads
> within the hypervisor that are not actually hosting guest CPU threads.
> The only way to have this competition occur at a reasonably fixed
> ratio is a sub-hierarchy.

I get that having hierarchy of threads would be nicer but am having a
bit of difficulty seeing why adjusting priorities of threads wouldn't
be sufficient.  It's not like threads of the same process competing
with each other is a new problem.  People have been dealing with it
for ages.  Hierarchical management can be a nice plus but we want the
problem and proposed solution to be justifiable.

Thanks.

-- 
tejun
