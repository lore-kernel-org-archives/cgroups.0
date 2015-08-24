From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Mon, 24 Aug 2015 17:40:00 -0400
Message-ID: <20150824214000.GL28944@mtj.duckdns.org>
References: <20150818203117.GC15739@mtj.duckdns.org>
 <CAPM31RJNy3jgG=DYe6GO=wyL4BPPxwUm1f2S6YXacQmo7viFZA@mail.gmail.com>
 <20150822182916.GE20768@mtj.duckdns.org>
 <55DB3C76.5010009@gmail.com>
 <20150824170427.GA27262@mtj.duckdns.org>
 <CAPM31RJi07qs42YsH=4JQSbZ+J-zCLv8e7yELb3tF_qAZmLqRA@mail.gmail.com>
 <20150824210223.GH28944@mtj.duckdns.org>
 <CAPM31R+i7BD8x9h_6wZVTa0zCB7XP0SGL5dSA-n6h9PTeAEhug@mail.gmail.com>
 <20150824211707.GJ28944@mtj.duckdns.org>
 <CAPM31R+vt1oAPCB-q6570RqZtJVBu5MH=gcQD2m9mjauStV7MA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=9MzuFncU7SGnDvHNWWlCZxHlk19Awol54Bv+SCOWxzk=;
        b=BnV/neXkXmSfh1o3nWulOBK+C4KgGYi/dV6SPaHI97dlMa3ycjvEXyScB+bZTHPfTx
         PUh12WJX1nh5GN3cdhxqT9WXQxc51IxXvBEIIUKvLXPQ8ZwOL4vLwwCMOQZs/5fBBYJq
         9Cm7/f1GHk7z0tSFSfUGk4G/dDF+hDDL2Zfe3/qY+ExVXGAnaBrpQwXc97+K/UCPphSP
         aNttVKYfvWvrrbxeKQkKd1YwLZFc00cRIEcE1d+KSR9z0VC6j3YszpHV7C9o5I+7hSAb
         f2P87fR8aWtyFyJIiWJ+UTEMoMQ5b9+J8Dm/pYuj5nRVqN/DDHa8DBNsoIakjxkIY0Cd
         5J2g==
Content-Disposition: inline
In-Reply-To: <CAPM31R+vt1oAPCB-q6570RqZtJVBu5MH=gcQD2m9mjauStV7MA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Mon, Aug 24, 2015 at 02:19:29PM -0700, Paul Turner wrote:
> > Would it be possible for you to give realistic and concrete examples?
> > I'm not trying to play down the use cases but concrete examples are
> > usually helpful at putting things in perspective.
> 
> I don't think there's anything that's not realistic or concrete about
> the example above.  The "suppose" parts were only for qualifying the
> pool sizes for vcpu and non-vcpu threads above since discussion of
> implementation using nice is dependent on knowing these counts.

Hmm... I was hoping for an actual configurations and usage scenarios.
Preferably something people can set up and play with.  I take that the
CPU intensive helper threads are usually IO workers?  Is the scenario
where the VM is set up with a lot of IO devices and different ones may
consume large amount of CPU cycles at any given point?

Thanks.

-- 
tejun
