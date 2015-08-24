From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Mon, 24 Aug 2015 16:25:09 -0400
Message-ID: <20150824202509.GF28944@mtj.duckdns.org>
References: <20150805091036.GT25159@twins.programming.kicks-ass.net>
 <20150805143132.GK17598@mtj.duckdns.org>
 <CAPM31RJTf0v=2v90kN6-HM9xUGab_k++upO0Ym=irmfO9+BbFw@mail.gmail.com>
 <CAPM31R+5=4bGQo++PrYoFuS86_7JqhhQ0OtPvCYooAzJsvhb=w@mail.gmail.com>
 <20150818203117.GC15739@mtj.duckdns.org>
 <CAPM31RJNy3jgG=DYe6GO=wyL4BPPxwUm1f2S6YXacQmo7viFZA@mail.gmail.com>
 <20150822182916.GE20768@mtj.duckdns.org>
 <55DB3C76.5010009@gmail.com>
 <20150824170427.GA27262@mtj.duckdns.org>
 <55DB77F1.5080802@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=YUFMVvN58+02UzmfVo5Y753x5MNEHPBuaiD2R5WbXEE=;
        b=NxIpBmVibVJ9EmoEQC8eLdCmyaAQr8/VJGDDxU2I5RaA34Tm1FbYj4h4Nyuk352St8
         ga7oM8vXwkHH/sTrJ+keOeNFzYcioHU3VeecItd8yBWFkAEBpGbs2mWKqSvRvm+3lTdS
         gsk6gUX0Wri3Mhl0D7sbkATFnXc/qRaqzBUgn3Ks1FjQgtbrFs5qOM/k3ELt5DJOFrbG
         Coj5u+TmcBS8BWLO5b9eeF2kIcUwsq9QlsjVhbAZE7JvxWV8UGEh0pIa1ovWn6/th2WI
         p7mt9Rs4C7YbjkQK0LOEplEqWmRYMraje9f2jJvIUJNQOj15FidI6S2XX2Ns+kKeVoPl
         Y7fQ==
Content-Disposition: inline
In-Reply-To: <55DB77F1.5080802-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello, Austin.

On Mon, Aug 24, 2015 at 04:00:49PM -0400, Austin S Hemmelgarn wrote:
> >That alone doesn't require hierarchical resource distribution tho.
> >Setting nice levels reasonably is likely to alleviate most of the
> >problem.
>
> In the cases I've dealt with this myself, nice levels didn't cut it, and I
> had to resort to SCHED_RR with particular care to avoid priority inversions.

I wonder why.  The difference between -20 and 20 is around 2500x in
terms of weight.  That should have been enough for expressing whatever
precedence the vcpus should have over other threads.

> >I don't know.  "Someone running one or two VM's on a laptop under
> >QEMU" doesn't really sound like the use case which absolutely requires
> >hierarchical cpu cycle distribution.
>
> It depends on the use case.  I never have more than 2 VM's running on my
> laptop (always under QEMU, setting up Xen is kind of pointless ona quad core
> system with only 8G of RAM), and I take extensive advantage of the cpu
> cgroup to partition resources among various services on the host.

Hmmm... I'm trying to understand the usecases where having hierarchy
inside a process are actually required so that we don't end up doing
something complex unnecessarily.  So far, it looks like an easy
alternative for qemu would be teaching it to manage priorities of its
threads given that the threads are mostly static - vcpus going up and
down are explicit operations which can trigger priority adjustments if
necessary, which is unlikely to begin with.

Thanks.

-- 
tejun
