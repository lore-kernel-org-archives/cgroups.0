From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/4] devcg: Store local settings for each device cgroup
Date: Fri, 16 Aug 2013 11:20:26 -0400
Message-ID: <20130816152025.GC7878@redhat.com>
References: <1376580854-30929-1-git-send-email-aris@redhat.com>
 <20130815195941.GA10977@mtj.dyndns.org>
 <20130815204804.GO7878@redhat.com>
 <20130815210937.GB10977@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130815210937.GB10977-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>

Hi Tejun,
On Thu, Aug 15, 2013 at 05:09:37PM -0400, Tejun Heo wrote:
> I think the configuration rules are too complex.  Without being privy
> to the implementation itself, the restrictions seem mostly arbitrary.
> The thing with this sort of greedy restrictions is that it might seem
> okay for a while after enough tweaking (the current state) but it gets
> weird as soon as the circumstance changes a bit and all the tweakings
> quickly become extra baggages to carry around.

Agreed.

> e.g. if a cgroup will be allowed to be moved to another position in
> the hierarchy, the cgroup shouldn't change its configuration across
> such migration, right?  If so, we'd be allowing creating a cgroup
> outside the hierarchy with any configuration moving it under another
> while disallowing creating it under there and creating the same
> configuration, which would be an outright buggy behavior.

Hm, then I think I got the requirements wrong. On my understanding you
cannot have a cgroup with more access than its parent. And the reason
for that is at that time the idea of having a container able to control
its own hierarchy was valid.
The way it is right now, when moved, a cgroup would have its active
rules re-checked for permission and it'd be made an attempt to apply
local rules if the new parent allows it.

> The thing is I really don't like specific config change triggering
> different actions.  It really should be "this chagned, recalculate all
> rules in this sub-hierarchy" rather than "this may affect XXX and YYY
> but not ZZZ so let's trigger this subpart".  The latter is way more
> tricky to fragile and difficult to follow and verify.  In addition, to
> support migration, it should be ready for any set of config changes in
> a go anyway.

IIRC it was to simplify the code. That can change of course.

> That's what cgroup_sane_behavior() is for.  It's essentially the next
> revision of cgroup interface.

Understood, I think after we get the internals sorted out (like going
for allow all or allow the listed) first

> The reason why I want to get rid of disallow w/ exceptions is that
> it's difficult to stack properly and ends up with this hodgepodge of
> restrictions which can serve a set of contorted requirements at the
> cost of overall consitent design which can be evolved and maintained
> in the long term.  If the majority of use cases are whitelisting, I
> think it'd be a better idea to just stick with whitelisting.

OK, will work on that

-- 
Aristeu
