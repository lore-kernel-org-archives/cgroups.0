From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Tue, 21 Feb 2023 08:07:13 -1000
Message-ID: <Y/UIURDjR9pv+gzx@slm.duckdns.org>
References: <Y+GQB9I6MFN6BOFw@nvidia.com>
 <Y+GcJQRhvjqFaaSp@mtj.duckdns.org>
 <Y+0rxoM4w9nilUMZ@dhcp22.suse.cz>
 <Y+0tWZxMUx/NZ3Ne@nvidia.com>
 <Y+3jcw9vo4ml5p0M@dhcp22.suse.cz>
 <Y+4lcq4Fge27TQIn@nvidia.com>
 <Y/T2pNQ70eMAl1sX@slm.duckdns.org>
 <Y/T+pw25oGmKqz1k@nvidia.com>
 <Y/T/bkcYc9Krw4rE@slm.duckdns.org>
 <Y/UEkNn0O65Pfi4e@nvidia.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iC2+JAOPJ7xBzI8XxPV50aOEhLdtaBVXx3tgIqcIDA8=;
        b=JxVgPwFf7PjLbqHyg/KF/bgcZTQyoMGHvbtVxDqt6yOY9aGl+AvfLI1AXDxz/r1wvV
         S+BrCUA9rK42zdI/Nzsaw//jN1f4IG1/si+33bGh8BWt8Ya1CJR38YIebWuF1Mo07cb9
         ir4sJZrHHOcDWDDxAfugg9OaOSg8y43jssvNXjnAXq2byO9AFBVugRCbXUVssSAMabAd
         ekkiFJCsuLfKBpDbCzzRVEUuCoCPKn5Hleyy6/LRtTHq0QLWEKOURXVW89vZ9P0Hnt+Y
         ISdL8k+PVv40iT4STlT7TM32PbUzIoMuXdCOzE+L4zMeW65sJG/C04HXNTUu9KSvEhAu
         UuPg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Y/UEkNn0O65Pfi4e-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello,

On Tue, Feb 21, 2023 at 01:51:12PM -0400, Jason Gunthorpe wrote:
> > Yeah, so, what I'm trying to say is that that might be the source of the
> > problem. Is the current page ownership attribution correct 
> 
> It should be correct.
> 
> This mechanism is driven by pin_user_page(), (as it is the only API
> that can actually create a pin) so the cgroup owner of the page is
> broadly related to the "owner" of the VMA's inode.
> 
> The owner of the pin is the caller of pin_user_page(), which is
> initated by some FD/proces that is not necessarily related to the
> VMA's inode.
> 
> Eg concretely, something like io_uring will do something like:
>   buffer = mmap()     <- Charge memcg for the pages
>   fd = io_uring_setup(..)
>   io_uring_register(fd,xx,buffer,..);   <- Charge the pincg for the pin
> 
> If mmap is a private anonymous VMA created by the same process then it
> is likely the pages will have the same cgroup as io_uring_register and
> the FD.
> 
> Otherwise the page cgroup is unconstrained. MAP_SHARED mappings will
> have the page cgroup point at whatever cgroup was first to allocate
> the page for the VMA's inode.
> 
> AFAIK there are few real use cases to establish a pin on MAP_SHARED
> mappings outside your cgroup. However, it is possible, the APIs allow
> it, and for security sandbox purposes we can't allow a process inside
> a cgroup to triger a charge on a different cgroup. That breaks the
> sandbox goal.

It seems broken anyway. Please consider the following scenario:

1. A is a tiny cgroup which only does streaming IOs and has memory.high of
   128M which is more than sufficient for IO window. The last file it
   streamed happened to be F which was about 256M.

2. B is an a lot larger cgroup w/ pin limit way above 256M. B pins the
   entirety of F.

3. A now tries to stream another file but F is almost fully occupying its
   memory allowance and can't be evicted. A keeps thrashing due to lack of
   memory and isolation is completely broken.

This stems directly from page ownership and pin accounting discrepancy.

> If memcg could support multiple owners then it would be logical that
> the pinner would be one of the memcg owners.
> 
> > for whatever reason is determining the pinning ownership or should the page
> > ownership be attributed the same way too? If they indeed need to differ,
> > that probably would need pretty strong justifications.
> 
> It is inherent to how pin_user_pages() works. It is an API that
> establishs pins on existing pages. There is nothing about it that says
> who the page's memcg owner is.
> 
> I don't think we can do anything about this without breaking things.

That's a discrepancy in an internal interface and we don't wanna codify
something like that into userspace interface. Semantially, it seems like if
pin_user_pages() wanna charge pinning to the cgroup associated with an fd
(or whatever), it should also claim the ownership of the pages themselves. I
have no idea how feasiable that'd be from memcg POV tho. Given that this
would be a fairly cold path (in most cases, the ownership should already
match), maybe it won't be too bad?

Thanks.

-- 
tejun
