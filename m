From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Tue, 7 Feb 2023 08:19:57 -0400
Message-ID: <Y+JB7VQX+Ypof4j6@nvidia.com>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
 <c7b5e502d1a3b9b8f6e96cbf9ca553b143c327e0.1675669136.git-series.apopple@nvidia.com>
 <Y+Fttp1ozejoSQzl@slm.duckdns.org>
 <CAJD7tkb_Cr7rTTpKc1VBpS8h=n3Hu+nGiV8dkLH-NdC1bSG9mg@mail.gmail.com>
 <Y+GA6Y7SVhAW5Xm9@slm.duckdns.org>
 <CAJD7tka6SC1ho-dffV0bK_acoZd-5DQzBOy0xg3TkOFG1zAPMg@mail.gmail.com>
 <Y+GMbWWP/YhtJQqe@slm.duckdns.org>
 <Y+GQB9I6MFN6BOFw@nvidia.com>
 <Y+GcJQRhvjqFaaSp@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ka1JLWFpn998EV2qdaWGP74rkt709l/jFMLXnA2McRI=;
 b=m5OE0QsOAJMuO7sF515kJQhbdVYWm7PbQ1qoPDMRjU+hu8SwYLfcKuvpnj8PnK6DW92p/iV5DwOGd7UDk5WpOpHzLHOnPNcEGURdho9/zdgL93qewYm3BT7ktpSrkfvOx8pqgFqByMapwxsnhf9XEkVxZ4cicYRkWNgJUwnOn40LjQlXvwf/ysRd09mQszOrL3lfPBDKCBbtjAYaeZdEoi95TPyu27VCuB/1rK2KpHWjACa+BP6N8AOajaRa6TXIvADSH2C6auwDsxSrX20MEkNkZwJ/FMw6PuFKHWp+awPf5CQlpOuRLpw3iTPhQKv28Lsdfcw4o46f9AmxoKZ+Hg==
Content-Disposition: inline
In-Reply-To: <Y+GcJQRhvjqFaaSp-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Mon, Feb 06, 2023 at 02:32:37PM -1000, Tejun Heo wrote:
> Hello,
> 
> On Mon, Feb 06, 2023 at 07:40:55PM -0400, Jason Gunthorpe wrote:
> > (a) kind of destroys the point of this as a sandboxing tool
> > 
> > It is not so harmful to use memory that someone else has been charged
> > with allocating.
> > 
> > But it is harmful to pin memory if someone else is charged for the
> > pin. It means it is unpredictable how much memory a sandbox can
> > actually lock down.
> > 
> > Plus we have the double accounting problem, if 1000 processes in
> > different cgroups open the tmpfs and all pin the memory then cgroup A
> > will be charged 1000x for the memory and hit its limit, possibly
> > creating a DOS from less priv to more priv
> 
> Let's hear what memcg people think about it. I'm not a fan of disassociating
> the ownership and locker of the same page but it is true that actively
> increasing locked consumption on a remote cgroup is awkward too.

The main purpose of all this is to support libvirt, so they need to
support (a) too.

(b) is what we have now and most closely emulates the way the RLIMIT
works.

Jason
