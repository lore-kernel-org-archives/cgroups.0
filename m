From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 2/2] mm, memcg: add memory.oom_control notification for
 system oom
Date: Mon, 18 Nov 2013 17:25:13 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1311181722380.4292@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1310301838300.13556@chino.kir.corp.google.com> <20131031054942.GA26301@cmpxchg.org> <alpine.DEB.2.02.1311131416460.23211@chino.kir.corp.google.com> <20131113233419.GJ707@cmpxchg.org> <alpine.DEB.2.02.1311131649110.6735@chino.kir.corp.google.com>
 <20131114032508.GL707@cmpxchg.org> <alpine.DEB.2.02.1311141447160.21413@chino.kir.corp.google.com> <alpine.DEB.2.02.1311141525440.30112@chino.kir.corp.google.com> <alpine.DEB.2.02.1311141526300.30112@chino.kir.corp.google.com>
 <20131118185213.GA12923@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=8vslPdlVvtAwu2BDaP3PLpJFrpGTqA4lzvqgDhc2V8Y=;
        b=oUBzfEKBK0GvjCdyPsxGdRyetT5CuMS48dK46pBgt3SL/dla277XDw9hEowN9h9sX2
         0O2IOfxTMxFYPC6V6XtJgcB3qjkPp/Kqo6srOVrnGIztZk4UhQmL+rElGav9w7IXOms0
         x+t8ihbMp92MKDdvrFO9jLe82qCL3lLzIVY6E1uDAT7OYSmYMYjRiHyPZTPZzAnqaRSc
         Z+HGmd4SA3Ld5AJbjSNxphwwSK0Y7umuirMRGng1Bebb59Tohax8/tvh9aikfQlgH1J8
         z7pQQKzzQvoWphVXITin/TlNFhOG2CU9okG7LpZVtueYnNX3TCWbkDFd6+GHoTgWwn8x
         FE7w==
In-Reply-To: <20131118185213.GA12923-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 18 Nov 2013, Michal Hocko wrote:

> > A subset of applications that wait on memory.oom_control don't disable
> > the oom killer for that memcg and simply log or cleanup after the kernel
> > oom killer kills a process to free memory.
> > 
> > We need the ability to do this for system oom conditions as well, i.e.
> > when the system is depleted of all memory and must kill a process.  For
> > convenience, this can use memcg since oom notifiers are already present.
> 
> Using the memcg interface for "read-only" interface without any plan for
> the "write" is only halfway solution. We want to handle global OOM in a
> more user defined ways but we have to agree on the proper interface
> first. I do not want to end up with something half baked with memcg and
> a different interface to do the real thing just because memcg turns out
> to be unsuitable.
> 

This patch isn't really a halfway solution, you can still determine if the 
open(O_WRONLY) succeeds or not to determine if that feature has been 
implemented.  I'm concerned about disabling the oom killer entirely for 
system oom conditions, though, so I didn't implement it to be writable.  I 
don't think we should be doing anything special in terms of "write" 
behavior for the root memcg memory.oom_control, so I'd argue against doing 
anything other than disabling the oom killer.  That's scary.
