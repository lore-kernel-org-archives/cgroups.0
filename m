From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Mon, 24 Aug 2015 17:12:38 -0400
Message-ID: <20150824211238.GI28944@mtj.duckdns.org>
References: <CAPM31RJTf0v=2v90kN6-HM9xUGab_k++upO0Ym=irmfO9+BbFw@mail.gmail.com>
 <CAPM31R+5=4bGQo++PrYoFuS86_7JqhhQ0OtPvCYooAzJsvhb=w@mail.gmail.com>
 <20150818203117.GC15739@mtj.duckdns.org>
 <CAPM31RJNy3jgG=DYe6GO=wyL4BPPxwUm1f2S6YXacQmo7viFZA@mail.gmail.com>
 <20150822182916.GE20768@mtj.duckdns.org>
 <55DB3C76.5010009@gmail.com>
 <20150824170427.GA27262@mtj.duckdns.org>
 <55DB77F1.5080802@gmail.com>
 <20150824202509.GF28944@mtj.duckdns.org>
 <CAPM31R+ckFO5vNG4L5+h-yokFaZQz6kHe5a+pkRCfbL0H+NjXg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=K43Wod62+iBG5YHMSRb2Sp8w4/hJjq/+9deY/HH+1jc=;
        b=JekFREJbxnIAPvawvx6p1iq3bZlrDnvMCfXrbcH+GY5sYF93b0ivjBtuzPk+WuOJUO
         4qeA2X4/aLLwoBCb6SBUfPtcsMlXtj9KN2AqMILIfgY+/TiI4kB7mHCv7eI1Qu1ugEqz
         kSSMkAJtK73Rf8Gz9z3ctZzQLZ1SD23Wsj5eGnaIYE8RInblfjf8aScBFtVlPEPEzoT/
         WXwQgvCRu3E9tc80zjLXzuDUuihfOC/P234C8jLq/N5dqvGnLYoMwxTK5QJmj6wHx7P3
         pi2Ov+WYvjeeneuWReq8PdelmbBLw4uqOVN5Q9wR4vmFDEACoqtvDaYy8Wn979+en01X
         awOQ==
Content-Disposition: inline
In-Reply-To: <CAPM31R+ckFO5vNG4L5+h-yokFaZQz6kHe5a+pkRCfbL0H+NjXg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello, Paul.

On Mon, Aug 24, 2015 at 02:00:54PM -0700, Paul Turner wrote:
> > Hmmm... I'm trying to understand the usecases where having hierarchy
> > inside a process are actually required so that we don't end up doing
> > something complex unnecessarily.  So far, it looks like an easy
> > alternative for qemu would be teaching it to manage priorities of its
> > threads given that the threads are mostly static - vcpus going up and
> > down are explicit operations which can trigger priority adjustments if
> > necessary, which is unlikely to begin with.
> 
> What you're proposing is both unnecessarily complex and imprecise.
> Arbitrating competition between groups of threads is exactly why we
> support sub-hierarchies within cpu.

Sure, and to make that behave half-way acceptable, we'll have to take
on significant amount of effort and likely complexity and I'm trying
to see whether the usecases are actually justifiable.  I get that
priority based solution will be less precise and more complex on the
application side but by how much and does the added precision enough
to justify the extra facilities to support that?  If it is, sure,
let's get to it but it'd be great if the concrete prolem cases are
properly identified and understood.  I'll continue on the other reply.

Thanks.

-- 
tejun
