From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Tue, 21 Feb 2023 15:26:33 -0400
Message-ID: <Y/Ua6VcNe/DFh7X4@nvidia.com>
References: <Y+GcJQRhvjqFaaSp@mtj.duckdns.org>
 <Y+0rxoM4w9nilUMZ@dhcp22.suse.cz>
 <Y+0tWZxMUx/NZ3Ne@nvidia.com>
 <Y+3jcw9vo4ml5p0M@dhcp22.suse.cz>
 <Y+4lcq4Fge27TQIn@nvidia.com>
 <Y/T2pNQ70eMAl1sX@slm.duckdns.org>
 <Y/T+pw25oGmKqz1k@nvidia.com>
 <Y/T/bkcYc9Krw4rE@slm.duckdns.org>
 <Y/UEkNn0O65Pfi4e@nvidia.com>
 <Y/UIURDjR9pv+gzx@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qJoetxTueRdwFyG7muRq2iwGc/+2jwQdIe1eeQ2yk2w=;
 b=pCO+Q6umjo/+QS+sxMVcUAonGFKpTnHbjq5/jueZF1XWNYdx/k4T62YUpNARyMyjZy5KAQyGHlIsYpnZHAMD4sJZ8m9fwzu3OLUexUcsN4ua3zRAzzHdiCG/UXjfSz+r5Sb8pYt057W2S1uH63WknLc2yjE+drxFV1x9ZyT/qPlzIZb90Cbw8cYEFInLYGLzbady1RgW+woipbPzCracqGCaNJUElag8o2u2rF+XqljScpdXbQ7lvDkyLBJ0ifJiGm9v9xdnpWGZUejmREFEdGXcOpekVlQGeCwAiLby/coavhLN1tCfFoSL3CxLtrtoSQ0Qb35l+a/Q5ojDr/CvmQ==
Content-Disposition: inline
In-Reply-To: <Y/UIURDjR9pv+gzx-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Tue, Feb 21, 2023 at 08:07:13AM -1000, Tejun Heo wrote:
> > AFAIK there are few real use cases to establish a pin on MAP_SHARED
> > mappings outside your cgroup. However, it is possible, the APIs allow
> > it, and for security sandbox purposes we can't allow a process inside
> > a cgroup to triger a charge on a different cgroup. That breaks the
> > sandbox goal.
> 
> It seems broken anyway. Please consider the following scenario:

Yes, this is broken like this already today - memcg doesn't work
entirely perfectly for MAP_SHARED scenarios, IMHO.

> > > for whatever reason is determining the pinning ownership or should the page
> > > ownership be attributed the same way too? If they indeed need to differ,
> > > that probably would need pretty strong justifications.
> > 
> > It is inherent to how pin_user_pages() works. It is an API that
> > establishs pins on existing pages. There is nothing about it that says
> > who the page's memcg owner is.
> > 
> > I don't think we can do anything about this without breaking things.
> 
> That's a discrepancy in an internal interface and we don't wanna codify
> something like that into userspace interface. Semantially, it seems like if
> pin_user_pages() wanna charge pinning to the cgroup associated with an fd
> (or whatever), it should also claim the ownership of the pages
> themselves.

Multiple cgroup can pin the same page, so it is not as simple as just
transfering ownership, we need multi-ownership and to really fix the
memcg limitations with MAP_SHARED without an API impact.

You are right that pinning is really just a special case of
allocation, but there is a reason the memcg was left with weak support
for MAP_SHARED and changing that may be more than just hard but an
infeasible trade off..

At least I don't have a good idea how to even approach building a
reasonable datstructure that can track the number of
charges per-cgroup per page. :\

Jason
