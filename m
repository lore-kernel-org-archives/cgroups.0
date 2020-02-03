From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v2 1/3] mm: memcontrol: fix memory.low proportional
 distribution
Date: Mon, 3 Feb 2020 13:38:47 -0800
Message-ID: <20200203213847.GC6781@xps.dhcp.thefacebook.com>
References: <20191219200718.15696-1-hannes@cmpxchg.org>
 <20191219200718.15696-2-hannes@cmpxchg.org>
 <20200130114929.GT24244@dhcp22.suse.cz>
 <20200203212136.GC6380@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=z8vaPmr1J/X4HytSD9N8H1eOBNjqroXNsZTca+fabFA=;
 b=ZJ32gcKJsylxcLCrwNW61ytuECYC7DEFHmErJPEKKSaXnxS1cON0QgScjqlRGo3vx7Ge
 IIyCao3+H1z5TRsUEsnnAPjinlzUNf2hYZlkdrfFMSnRWz9JPhbdifN2E/lOiKUQ4cMC
 DsCdK7Avkdn+Dt9nYVTWu478gdlZox0zW7s= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z8vaPmr1J/X4HytSD9N8H1eOBNjqroXNsZTca+fabFA=;
 b=SVQPYrnGz3eqv0qKmSV+29OOP26Gbrh0mJEfb84yT5WMAPcLGf1Br7yRdyXezB2wlpFrlQgSHbC+t7Q+4pzRaRxW2wFbdzT23p1T7yP2QblX7T3u2Hzb7cA4g1iPKqflWt6A3lTLRN8g19miqppKb8sOYpgU+Mz8eRImhRir+cI=
Content-Disposition: inline
In-Reply-To: <20200203212136.GC6380-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon, Feb 03, 2020 at 04:21:36PM -0500, Johannes Weiner wrote:
> On Thu, Jan 30, 2020 at 12:49:29PM +0100, Michal Hocko wrote:
> > On Thu 19-12-19 15:07:16, Johannes Weiner wrote:
> > > When memory.low is overcommitted - i.e. the children claim more
> > > protection than their shared ancestor grants them - the allowance is
> > > distributed in proportion to how much each sibling uses their own
> > > declared protection:
> > 
> > Has there ever been any actual explanation why do we care about
> > overcommitted protection? I have got back to email threads when
> > the effective hierarchical protection has been proposed.
> > http://lkml.kernel.org/r/20180320223353.5673-1-guro-b10kYP2dOMg@public.gmane.org talks about
> > some "leaf memory cgroups are more valuable than others" which sounds ok
> > but it doesn't explain why children have to overcommit parent in the
> > first place. Do we have any other documentation to explain the usecase?
> 
> I don't think we properly documented it, no. Maybe Roman can elaborate
> on that a bit more since he added it.

There is simple no way to prevent it. Cgroup v2 UI allows to set any values,
and they are never changed automatically on e.g. parent's value change.

So the system has to perform reasonably for all possible configurations.

Before introducing of effective protections it was way too defensive:
it was super easy to disable the protection by exceeding the protection
value on some level. So it wasn't possible to rely on it in production.

So disabling the protection in case of over-commitment isn't a good option
too.

Thanks!
