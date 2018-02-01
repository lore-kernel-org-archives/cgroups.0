From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v4.15-rc9] sched, cgroup: Don't reject lower cpu.max on
 ancestors
Date: Thu, 1 Feb 2018 17:49:42 +0100
Message-ID: <20180201164942.GC2249@hirez.programming.kicks-ass.net>
References: <20180122192618.GA1771050@devbig577.frc2.facebook.com>
 <20180130102156.GS2249@hirez.programming.kicks-ass.net>
 <20180130145639.GD1121507@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=K3r6wu+b75ZcYD+PRbHqphV61siPK9Oe3M6tvvLYhHs=; b=RagDktTqUDbHwLx5//z16pqaA
        UqfBnA8PbY505T6+mRheFrw/ZZ0bc44qarUQX04dxtTHdr4uXxd3E/uONvtNuPBK8G2HFxYA5Z6Qx
        +kMOhRCaQPr/NvcRGddyOcKwVQmP0BWk3sVrV/DEFoECJNlpIOt2NCTy92n5yGvabfAHtDyigwelX
        RqzVjmbplDn/rd6e5Tm1S8M5B8BxOGm9dx5bwhMQAAh6vWd3dIr6/N71o868dc0q4cyTDzSz0Q/S5
        9NUmkHMegNoqNJPxx5NZH5BdvwKasqpWNMBx6z0zQM3XklkeBedZb85CChuXffZRTUFfgLxAfSxVQ
      
Content-Disposition: inline
In-Reply-To: <20180130145639.GD1121507-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Tue, Jan 30, 2018 at 06:56:39AM -0800, Tejun Heo wrote:
> Hello,
> 
> On Tue, Jan 30, 2018 at 11:21:56AM +0100, Peter Zijlstra wrote:
> > afaiu the existing code does exactly the opposite, it forces the
> > descendants to configure less than the parent allows.
> > 
> > You're taking out an error condition and silently allowing descentant
> > misconfiguration. How does that make sense?
> 
> Well, they're upper limits, not strict allocations.  The current
> behavior implemented by cpu isn't either a strict allocation or upper
> limits.  It disallows a child from having a value higher than the
> parent (allocation-ish) but the sum of the children is allowed to
> exceed the parent's (limit-ish).

True; but its still weird to have the parent 'promise' something and
then retract that 'promise' later.

> The combination is rather arbitrary and makes it impossible to
> delegate safely (a delegatee can block the delegator from reducing the
> amount resource allocated to the delegatee) while not really
> protecting against overcommit from descendants either.
> 
> We had this sort of input validations in different controllers all in
> their own ways.  In most cases, these aren't well thought out and we
> can't support things like delegation without aligning controller
> behaviors.

I suppose.. 

Acked-by: Peter Zijlstra (Intel) <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
