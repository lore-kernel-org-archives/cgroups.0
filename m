From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Date: Thu, 27 Sep 2012 10:46:05 -0700
Message-ID: <20120927174605.GA2713@localhost>
References: <20120926201629.GB20342@google.com>
 <50637298.2090904@parallels.com>
 <20120926221046.GA10453@mtj.dyndns.org>
 <506381B2.2060806@parallels.com>
 <20120926224235.GB10453@mtj.dyndns.org>
 <50638793.7060806@parallels.com>
 <20120926230807.GC10453@mtj.dyndns.org>
 <20120927142822.GG3429@suse.de>
 <20120927144942.GB4251@mtj.dyndns.org>
 <50646977.40300@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=2BDn6iEnNxZjoWnVYmaCj0UGlDjNdw1lhuXvikDdWvk=;
        b=HttLrHdL1FlRrgVuEXjcLWeex+8Xi9wLe2gd1Xwx+rzNemLcqJtqZiDUuILn5D1kEr
         1GzKSu7rrQtkEls4Oe+MH2hBvg53ku5hFPb+11OLFLIQ1sGUkbEZPsEO+TsuC8lz/2CB
         KD5EtvJipnguGCUFquZBGh+VYY0Jk8Ougyw54YpJbrC32SNtiw8cty85TUJPC2lZLe6s
         ggvc1mFnYPwSmzeH48ie1cbHFdhdrb669gicHwA43BSWpI7xkGKQIUauct7D3Ib66tkl
         W/iZ2n5e1s3EPpKqe/P2A7/GfJ8eFpDtHD7VV+uR0SNeI5Kp4R5CjwRXNSHPqotVxgl0
         i1Eg==
Content-Disposition: inline
In-Reply-To: <50646977.40300-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello,

On Thu, Sep 27, 2012 at 06:57:59PM +0400, Glauber Costa wrote:
> > Because we're not even trying to actually solve the problem but just
> > dumping it to userland.  If dentry/inode usage is the only case we're
> > being worried about, there can be better ways to solve it or at least
> > we should strive for that.
> 
> Not only it is not the only case we care about, this is not even touched
> in this series. (It is only touched in the next one). This one, for
> instance, cares about the stack. The reason everything is being dumped
> into "kmem", is precisely to make things simpler. I argue that at some
> point it makes sense to draw a line, and "kmem" is a much better line
> than any fine grained control - precisely because it is conceptually
> easier to grasp.

Can you please give other examples of cases where this type of issue
exists (plenty of shared kernel data structure which is inherent to
the workload at hand)?  Until now, this has been the only example for
this type of issues.

> > I think the cost isn't too prohibitive considering it's already using
> > memcg.  Charging / uncharging happens only as pages enter and leave
> > slab caches and the hot path overhead is essentially single
> > indirection.  Glauber's benchmark seemed pretty reasonable to me and I
> > don't yet think that warrants exposing this subtle tree of
> > configuration.
> 
> Only so we can get some numbers: the cost is really minor if this is all
> disabled. It this is fully enable, it can get to some 2 or 3 %, which
> may or may not be acceptable to an application. But for me this is not
> even about cost, and that's why I haven't brought it up so far

It seems like Mel's concern is mostly based on performance overhead
concerns tho.

> > The part I nacked is enabling kmemcg on a populated cgroup and then
> > starting accounting from then without any apparent indication that any
> > past allocation hasn't been considered.  You end up with numbers which
> > nobody can't tell what they really mean and there's no mechanism to
> > guarantee any kind of ordering between populating the cgroup and
> > configuring it and there's *no* way to find out what happened
> > afterwards neither.  This is properly crazy and definitely deserves a
> > nack.
> > 
> 
> Mel suggestion of not allowing this to happen once the cgroup has tasks
> takes care of this, and is something I thought of myself.

You mean Michal's?  It should also disallow switching if there are
children cgroups, right?

> This would remove this particular piece of objection, and maintain the
> per-subtree control.

Yeah, I don't see anything broken with that although I'll try to argue
for simpler one a bit more.

Thanks.

-- 
tejun
