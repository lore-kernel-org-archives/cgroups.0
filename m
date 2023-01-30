From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Mon, 30 Jan 2023 09:20:41 -0400
Message-ID: <Y9fEKfdlL+hCiWpz@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <183372b80aac73e640d9f5ac3c742d505fc6c1f2.1674538665.git-series.apopple@nvidia.com>
 <Y9RFs+90TyzVMs83@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZwyiM/7B2+SHU43XMWs9J8BzG/ABfrNrQW3lGga4pEg=;
 b=E8kVImaomP0YB58nSm2C2vU7XQXds3bJ5ojEKT2kncJIYnuIoYSjsOOEIoB5v8vhJehbYSI+chfB1bPv3aexXhYZaNHNpTA7jFWLRlGk41NIqGDBgNIG5G/U5l+xMg5e8YE4hAQXQIHHhcBy68v2RBRa2OpwGXHcsMpKzoKrAAoDFQTPvY7fR/dBxbiJe/Vr5hJBXKVUx8+Lk7O9J+9oeGgm36gZH26wHfBeI5q3/6lCgBOqNEF0Eso9RFU3+kpVDNejXvLxsGqE0dcanYONBkKGfFtu+huWBTeCqbRCZQJjVDXYM81ulI7G9b/8KlGDi3H1xlswd6jw8i/NFkE3ug==
Content-Disposition: inline
In-Reply-To: <Y9RFs+90TyzVMs83-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "libvir-list-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <libvir-list-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Laine Stump <laine-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Fri, Jan 27, 2023 at 11:44:19AM -1000, Tejun Heo wrote:
> On Tue, Jan 24, 2023 at 04:42:43PM +1100, Alistair Popple wrote:
> > If too much memory in a system is pinned or locked it can lead to
> > problems such as performance degredation or in the worst case
> > out-of-memory errors as such memory cannot be moved or paged out.
> > 
> > In order to prevent users without CAP_IPC_LOCK from causing these
> > issues the amount of memory that can be pinned is typically limited by
> > RLIMIT_MEMLOCK. However this is inflexible as limits can't be shared
> > between tasks and the enforcement of these limits is inconsistent
> > between in-kernel users of pinned memory such as mlock() and device
> > drivers which may also pin pages with pin_user_pages().
> > 
> > To allow for a single limit to be set introduce a cgroup controller
> > which can be used to limit the number of pages being pinned by all
> > tasks in the cgroup.
> 
> The use case makes some sense to me but I wonder whether this'd fit a lot
> better in memcg rather than being its own controller.

As long as the pinned limitation has its own bucket it is probably
fine? The underlying memory allocations should have already been
charged to the memcg - so we don't want to double account.

Alex and Daniel were looking at this from the qemu/libvirt
perspective, perhaps they have some insight what they would like to
see?

Thanks,
Jason
