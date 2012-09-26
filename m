From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Date: Wed, 26 Sep 2012 15:42:35 -0700
Message-ID: <20120926224235.GB10453@mtj.dyndns.org>
References: <20120926180124.GA12544@google.com>
 <50634FC9.4090609@parallels.com>
 <20120926193417.GJ12544@google.com>
 <50635B9D.8020205@parallels.com>
 <20120926195648.GA20342@google.com>
 <50635F46.7000700@parallels.com>
 <20120926201629.GB20342@google.com>
 <50637298.2090904@parallels.com>
 <20120926221046.GA10453@mtj.dyndns.org>
 <506381B2.2060806@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=vhLRE2JU+pc6MZ+aHV+RVMAR+ATaVETA4M3+JUIsB2w=;
        b=t0wFnKR3T4tPSqJbl1mWjvYOywgkCY5A/Cr2JOD19UIAyclByjpXvygKLWsMOvRXI9
         4z24vv3mHoS66nlacE9ZMHAs+JRFENyFWv9I5FX93AopXAjwB/Duh0DPBDs0AEr21tV2
         oDr3TzU3aS3rsz5XdtdnHpEFWsUUV3oDHLOokxVGtmtzvhG3MGkpK7qjRpJs7tkzFvbY
         j1E0Eoc6KerxYscNfHd51EVV8tceUYixSLU4zvjSfg4sZdbr8c9ZFqZtXe9mW/MY/va0
         lIb7pdQ7z+7NYJ6x09/vcS4Vjur7yh+FRM3bkGlmx6zQoA+m08CfYmviudDl6kI7P9yo
         kZ7g==
Content-Disposition: inline
In-Reply-To: <506381B2.2060806-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello, Glauber.

On Thu, Sep 27, 2012 at 02:29:06AM +0400, Glauber Costa wrote:
> And then what? If you want a different behavior you need to go kill all
> your services that are using memcg so you can get the behavior you want?
> And if they happen to be making a specific flag choice by design, you
> just say "you really can't run A + B together" ?
> 
> I myself think global switches are an unnecessary complication. And let
> us not talk about use_hierarchy, please. If it becomes global, it is
> going to be as part of a phase out plan anyway. The problem with that is
> not that it is global, is that it shouldn't even exist.

I would consider it more of a compatibility thing which is set during
boot and configurable by sysadmin.  Let the newer systems enable it by
default on boot and old configs / special ones disable it as
necessary.

> > Backward compatibility is covered with single switch and I really
> > don't think "you can enable limits for kernel memory anytime but we
> > don't keep track of whatever happened before it was flipped the first
> > time because the first time is always special" is a sane thing to
> > expose to userland.  Or am I misunderstanding the proposed behavior
> > again?
> 
> You do keep track. Before you switch it for the first time, it all
> belongs to the root memcg.

Well, that's really playing with words.  Limit is per cgroup and
before the limit is set for the first time, everything is accounted to
something else.  How is that keeping track?

The proposed behavior seems really crazy to me.  Do people really
think this is a good idea?

Thanks.

-- 
tejun
