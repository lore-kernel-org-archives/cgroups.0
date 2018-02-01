From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4.15-rc9] sched, cgroup: Don't reject lower cpu.max on
 ancestors
Date: Thu, 1 Feb 2018 11:57:10 -0800
Message-ID: <20180201195710.GK1121507@devbig577.frc2.facebook.com>
References: <20180122192618.GA1771050@devbig577.frc2.facebook.com>
 <20180130102156.GS2249@hirez.programming.kicks-ass.net>
 <20180130145639.GD1121507@devbig577.frc2.facebook.com>
 <20180201164942.GC2249@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=td4Xw+Jx+QBPhGsdJWnpwVg8KxYeZafZs3/013WfPBE=;
        b=BBCRKbzG3cRl1q/BWzHB29ius2PHPe4aGqMgSUzPP7UVNTNpqF4QYw1yUNIQFtGU8V
         +rt5P+QZI8/5FvMWy/cjRl4cgxkc4YpMJ4xrMe+DohFrYj2kOMkQ2u/m/4AU/qj+dMjj
         M5wh1UvqWJH65AFhGfG/gXp/ukHekLlIbCpyRpckRXhM55wPNvIiFXdm1KbFcYC4Z0Ow
         lBYVN+Qf3DXZdZzwhKXOp6b6HV2X63FOx8w8KOaaYIIQpsC9N6wBszVlz4LehGOa1qQi
         BLfUjb2s504ktL66DqaPjdP3OWO9AA6UZNwKKDfU4NROVAd194ReQZP+8sRiWB4DOOgT
         ODeg==
Content-Disposition: inline
In-Reply-To: <20180201164942.GC2249-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello,

On Thu, Feb 01, 2018 at 05:49:42PM +0100, Peter Zijlstra wrote:
> > Well, they're upper limits, not strict allocations.  The current
> > behavior implemented by cpu isn't either a strict allocation or upper
> > limits.  It disallows a child from having a value higher than the
> > parent (allocation-ish) but the sum of the children is allowed to
> > exceed the parent's (limit-ish).
> 
> True; but its still weird to have the parent 'promise' something and
> then retract that 'promise' later.

Yeah, depending on how you look at it, it can feel weird.  It's just
that viewing these absolute resource limits (cpu.max,
memory.{high,max}, io.max, pids.max) as upper bounds seems to be the
best abstraction in terms of capturing what they do and making uses of
them in a robust way.

> > We had this sort of input validations in different controllers all in
> > their own ways.  In most cases, these aren't well thought out and we
> > can't support things like delegation without aligning controller
> > behaviors.
> 
> I suppose.. 
> 
> Acked-by: Peter Zijlstra (Intel) <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Will route it through cgroup fixes branch in a week or so.

Thanks a lot.

-- 
tejun
