From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Tue, 21 Feb 2023 13:51:12 -0400
Message-ID: <Y/UEkNn0O65Pfi4e@nvidia.com>
References: <Y+GMbWWP/YhtJQqe@slm.duckdns.org>
 <Y+GQB9I6MFN6BOFw@nvidia.com>
 <Y+GcJQRhvjqFaaSp@mtj.duckdns.org>
 <Y+0rxoM4w9nilUMZ@dhcp22.suse.cz>
 <Y+0tWZxMUx/NZ3Ne@nvidia.com>
 <Y+3jcw9vo4ml5p0M@dhcp22.suse.cz>
 <Y+4lcq4Fge27TQIn@nvidia.com>
 <Y/T2pNQ70eMAl1sX@slm.duckdns.org>
 <Y/T+pw25oGmKqz1k@nvidia.com>
 <Y/T/bkcYc9Krw4rE@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nfsPA5ydF9JSAYHxDEO2XlmhJB5FFetsi9LZA1Lbr0A=;
 b=gLKYzJNG53oPf6n9IcMdkdK58kNvECq+/1LpO9BTcXcB8r939w50XFMzMSshDC7dwiPGqbtvskfWAErXvW7JQhux3x21jH3D72Gp1Y3/wz36UQmQZfw5LD9/aOGAY5+Q3OKb93K2vS42gBS8SPlM2lDgi6Au2mfIRwgZKxdpNLN7mVtie6NnhkGgISfWvZmdWlo7l3YpyfqzJYx/v52oEvx1AEqITBNJw6Wz65DLnvkdqVTPRsosmINqCB+kKcSnZV/uHO7c4MFjGQHzxZ0/MdiqvB+d8Vid26ppJqpcrUEZacOFjDxoSTbB8354e+hQyoYbXDw8GtbJLK+e5iUY+Q==
Content-Disposition: inline
In-Reply-To: <Y/T/bkcYc9Krw4rE-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Tue, Feb 21, 2023 at 07:29:18AM -1000, Tejun Heo wrote:
> On Tue, Feb 21, 2023 at 01:25:59PM -0400, Jason Gunthorpe wrote:
> > On Tue, Feb 21, 2023 at 06:51:48AM -1000, Tejun Heo wrote:
> > > cgroup, right? It makes little sense to me to separate the owner of the
> > > memory page and the pinner of it. They should be one and the same.
> > 
> > The owner and pinner are not always the same entity or we could just
> > use the page's cgroup.
> 
> Yeah, so, what I'm trying to say is that that might be the source of the
> problem. Is the current page ownership attribution correct 

It should be correct.

This mechanism is driven by pin_user_page(), (as it is the only API
that can actually create a pin) so the cgroup owner of the page is
broadly related to the "owner" of the VMA's inode.

The owner of the pin is the caller of pin_user_page(), which is
initated by some FD/proces that is not necessarily related to the
VMA's inode.

Eg concretely, something like io_uring will do something like:
  buffer = mmap()     <- Charge memcg for the pages
  fd = io_uring_setup(..)
  io_uring_register(fd,xx,buffer,..);   <- Charge the pincg for the pin

If mmap is a private anonymous VMA created by the same process then it
is likely the pages will have the same cgroup as io_uring_register and
the FD.

Otherwise the page cgroup is unconstrained. MAP_SHARED mappings will
have the page cgroup point at whatever cgroup was first to allocate
the page for the VMA's inode.

AFAIK there are few real use cases to establish a pin on MAP_SHARED
mappings outside your cgroup. However, it is possible, the APIs allow
it, and for security sandbox purposes we can't allow a process inside
a cgroup to triger a charge on a different cgroup. That breaks the
sandbox goal.

If memcg could support multiple owners then it would be logical that
the pinner would be one of the memcg owners.

> for whatever reason is determining the pinning ownership or should the page
> ownership be attributed the same way too? If they indeed need to differ,
> that probably would need pretty strong justifications.

It is inherent to how pin_user_pages() works. It is an API that
establishs pins on existing pages. There is nothing about it that says
who the page's memcg owner is.

I don't think we can do anything about this without breaking things.

Jason
