From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [RFC PATCH] mm: memcontrol: don't account swap failures not due
 to cgroup limits
Date: Tue, 7 Feb 2023 11:52:42 -0500
Message-ID: <Y+KB2lcAH3vhw0Xj@cmpxchg.org>
References: <20230202155626.1829121-1-hannes@cmpxchg.org>
 <Y91ZsDSIr2oFHu3E@P9FQF9L96D.corp.robot.car>
 <CAHbLzkpk+6+kzsxmJ_MK+708rpCEjB2njnarLkzfzXX-MUyG7g@mail.gmail.com>
 <Y91eRKKutWBZwmSG@P9FQF9L96D.corp.robot.car>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=90LXWSidw5JtQbA5QjDdZbPVfE/311Yqzr/kJ+sttOM=;
        b=pYf4Wm2yX5Db/EesL6WWX79wefRSPeDXmP+JdbgruotStM4aTAg2EEmqAmFcafVsOQ
         qVZWuUrBQcBVM89VJJ7Lg4bX/OLfvPC1JnVU38e0oEClpG1YyWHd0+1D5TuFyOmu9tci
         7MwIi4JbzEUI59mW7MaUZ/BNcb7O8lzbaqyOkMte4VWLeUgGN2267ypBgPNhYD5pWixE
         7FMX6ON/ZNDrK1hq08B5q/9FdOFoJ38kat9YP6xjerL7XjmkjB4pkTIVGToAAidXO5G/
         MQeEU/d9tJ/c2Ix5Z2oWzN6/Eq3r3KwCryG0x4+v8QGkNaxF/8oRrWFBcMl3Dd67WCf4
         AwwA==
Content-Disposition: inline
In-Reply-To: <Y91eRKKutWBZwmSG-+xijCwNIfdoLQcUKs7qKB+WAnPUfkyWGUBSOeVevoDU@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Fri, Feb 03, 2023 at 11:19:32AM -0800, Roman Gushchin wrote:
> On Fri, Feb 03, 2023 at 11:07:30AM -0800, Yang Shi wrote:
> > On Fri, Feb 3, 2023 at 11:00 AM Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
> > >
> > > On Thu, Feb 02, 2023 at 10:56:26AM -0500, Johannes Weiner wrote:
> > > > Christian reports the following situation in a cgroup that doesn't
> > > > have memory.swap.max configured:
> > > >
> > > >   $ cat memory.swap.events
> > > >   high 0
> > > >   max 0
> > > >   fail 6218
> > > >
> > > > Upon closer examination, this is an ARM64 machine that doesn't support
> > > > swapping out THPs.
> > >
> > > Do we expect it to be added any time soon or it's caused by some system
> > > limitations?
> > 
> > AFAIK, it has been supported since 6.0. See commit d0637c505f8a1
> 
> Great, thank you for the link!
> Then it looks like we have even fewer reasons to change the interface.

Yes, ARM supports it now. But the point wasn't necessarily to fix this
because of ARM. THP swap can fall back due to plenty of other reasons,
for example fragmentation. It always falls back on swapfiles since
they don't have the cluster allocator that bdevs have.

The broader point was that we show failures in the cgroup event
counter that have nothing to do with the cgroup's configuration.
