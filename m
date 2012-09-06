From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2] memcg: first step towards hierarchical controller
Date: Thu, 6 Sep 2012 14:18:42 +0200
Message-ID: <20120906121842.GG22426@dhcp22.suse.cz>
References: <20120904143552.GB15683@dhcp22.suse.cz>
 <50461241.5010300@parallels.com>
 <20120904145414.GC15683@dhcp22.suse.cz>
 <50461610.30305@parallels.com>
 <20120904162501.GE15683@dhcp22.suse.cz>
 <504709D4.2010800@parallels.com>
 <20120905144942.GH5388@dhcp22.suse.cz>
 <20120905201238.GE13737@google.com>
 <20120906120623.GE22426@dhcp22.suse.cz>
 <50489270.7060108@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <50489270.7060108-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Thu 06-09-12 16:09:20, Glauber Costa wrote:
> On 09/06/2012 04:06 PM, Michal Hocko wrote:
> > On Wed 05-09-12 13:12:38, Tejun Heo wrote:
> >> Hello, Michal.
> >>
> >> On Wed, Sep 05, 2012 at 04:49:42PM +0200, Michal Hocko wrote:
> >>> Can we settle on the following 3 steps?
> >>> 1) warn about "flat" hierarchies (give it X releases) - I will push it
> >>>    to as many Suse code streams as possible (hope other distributions
> >>>    could do the same)
> >>
> >> I think I'm just gonna trigger WARN from cgroup core if anyone tries
> >> to create hierarchy with a controller which doesn't support full
> >> hierarchy.  WARN_ON_ONCE() at first and then WARN_ON() on each
> >> creation later on.
> > 
> > How do you find out that a controller is not fully hierarchical? Memory
> > controller can be both.
> > 
> >>> 2) flip the default on the root cgroup & warn when somebody tries to
> >>>    change it to 0 (give it another X releases) that the knob will be
> >>>    removed
> >>> 3) remove the knob and the whole nonsese
> >>> 4) revert 3 if somebody really objects
> >>
> >> If we can get to 3, I don't think 4 would be a problem.
> > 
> > Agreed.
> > 
> Just so I understand it:
> 
> Michal clearly objected before folding his patch with my Kconfig patch.
> But is there still opposition to merge both?

I do not find the config option very much useful but if others feel it
really is I won't block it.

> By having it default-n, only people that are either sure that this is
> safe for them, or have more clearly defined lifecycles could set it.
-- 
Michal Hocko
SUSE Labs
