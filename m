From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Tue, 21 Feb 2023 09:45:15 -1000
Message-ID: <Y/UfS8TDIXhUlJ/I@slm.duckdns.org>
References: <Y+0rxoM4w9nilUMZ@dhcp22.suse.cz>
 <Y+0tWZxMUx/NZ3Ne@nvidia.com>
 <Y+3jcw9vo4ml5p0M@dhcp22.suse.cz>
 <Y+4lcq4Fge27TQIn@nvidia.com>
 <Y/T2pNQ70eMAl1sX@slm.duckdns.org>
 <Y/T+pw25oGmKqz1k@nvidia.com>
 <Y/T/bkcYc9Krw4rE@slm.duckdns.org>
 <Y/UEkNn0O65Pfi4e@nvidia.com>
 <Y/UIURDjR9pv+gzx@slm.duckdns.org>
 <Y/Ua6VcNe/DFh7X4@nvidia.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N8Fw863vYfPuhJasko8shrY4FAYlAxC3uA3w425iqK0=;
        b=ZEHG7lOnQJAZUYa9JABpoxh1o9+wBCbhvsehzjqT+E7quaMrJOPsaccDZe52r0U5eI
         Wl2Yv3964tGhKOkZTfcjpmJwvuFGvtBi3oy09nbaYT62gAUZDrnR4pSbTuU2SFVNuy1P
         CmdrtDQ8EmgggBqy4VGb5JBmMaVO6gkqnVpsJYqgG7BDSo115dqSwWqgxH/Ipu6ne0bP
         GRAvVac7/7B1rzHhTXy/NA4aOz0UfW9JcqKwvCQsKSYY41tQ/mLshdOz6uioAWmSqo72
         aawleuhd63JPO8Q7OzYdyMlLKHm5kyK/vjZ8lghkG+sD0zV5fIspvbCUFMrDfyV8F7XO
         r4TA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Y/Ua6VcNe/DFh7X4-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello,

On Tue, Feb 21, 2023 at 03:26:33PM -0400, Jason Gunthorpe wrote:
> On Tue, Feb 21, 2023 at 08:07:13AM -1000, Tejun Heo wrote:
> > > AFAIK there are few real use cases to establish a pin on MAP_SHARED
> > > mappings outside your cgroup. However, it is possible, the APIs allow
> > > it, and for security sandbox purposes we can't allow a process inside
> > > a cgroup to triger a charge on a different cgroup. That breaks the
> > > sandbox goal.
> > 
> > It seems broken anyway. Please consider the following scenario:
> 
> Yes, this is broken like this already today - memcg doesn't work
> entirely perfectly for MAP_SHARED scenarios, IMHO.

It is far from perfect but the existing behavior isn't that broken. e.g. in
the same scenario, without pinning, even if the larger cgroup keeps using
the same page, the smaller cgroup should be able to evict the pages as they
are not pinned and the cgroup is under heavy reclaim pressure. The larger
cgroup will refault them back in and end up owning those pages.

memcg can't capture the case of the same pages being actively shared by
multiple cgroups concurrently (I think those cases should be handled by
pushing them to the common parent as discussed elswhere but that's a
separate topic) but it can converge when page usage transfers across cgroups
if needed. Disassociating ownership and pinning will break that in an
irreversible way.

> > > > for whatever reason is determining the pinning ownership or should the page
> > > > ownership be attributed the same way too? If they indeed need to differ,
> > > > that probably would need pretty strong justifications.
> > > 
> > > It is inherent to how pin_user_pages() works. It is an API that
> > > establishs pins on existing pages. There is nothing about it that says
> > > who the page's memcg owner is.
> > > 
> > > I don't think we can do anything about this without breaking things.
> > 
> > That's a discrepancy in an internal interface and we don't wanna codify
> > something like that into userspace interface. Semantially, it seems like if
> > pin_user_pages() wanna charge pinning to the cgroup associated with an fd
> > (or whatever), it should also claim the ownership of the pages
> > themselves.
> 
> Multiple cgroup can pin the same page, so it is not as simple as just
> transfering ownership, we need multi-ownership and to really fix the
> memcg limitations with MAP_SHARED without an API impact.
> 
> You are right that pinning is really just a special case of
> allocation, but there is a reason the memcg was left with weak support
> for MAP_SHARED and changing that may be more than just hard but an
> infeasible trade off..
> 
> At least I don't have a good idea how to even approach building a
> reasonable datstructure that can track the number of
> charges per-cgroup per page. :\

As I wrote above, I don't think the problem here is the case of pages being
shared by multiple cgroups concurrently. We can leave that problem for
another thread. However, if we want to support accounting and control of
pinned memory, we really shouldn't introduce a fundmental discrepancy like
the owner and pinner disagreeing with each other. At least conceptually, the
solution is rather straight-forward - whoever pins a page should also claim
the ownership of it.

Thanks.

-- 
tejun
