From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Mon, 6 Feb 2023 19:40:55 -0400
Message-ID: <Y+GQB9I6MFN6BOFw@nvidia.com>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
 <c7b5e502d1a3b9b8f6e96cbf9ca553b143c327e0.1675669136.git-series.apopple@nvidia.com>
 <Y+Fttp1ozejoSQzl@slm.duckdns.org>
 <CAJD7tkb_Cr7rTTpKc1VBpS8h=n3Hu+nGiV8dkLH-NdC1bSG9mg@mail.gmail.com>
 <Y+GA6Y7SVhAW5Xm9@slm.duckdns.org>
 <CAJD7tka6SC1ho-dffV0bK_acoZd-5DQzBOy0xg3TkOFG1zAPMg@mail.gmail.com>
 <Y+GMbWWP/YhtJQqe@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=756dhXWezEIp93so5vb4qTkpfkbSmgRWyY2aYv2uiKA=;
 b=XlZIX+anh1ducJnI/itZxDFh5fsJx4hV2lN79AiDGPOZL5r/4UgBcCnKYA5/p2HXP9TK0RFxkugLr5lxNqw+Df98XEilMbA0M2uTPMH46QHMHf6GzXQ3JEiYFJRdp56L5qE9OddrlmV6vQVuJIPR0JiUIQ2TeTabveQfzz6w0iD6wz5l+1pfvV/vWZs3ztidNVULNcf3bYNauXGsys9+D/CLM/XLDR5nJUr77vQmT+h5LWaICorztAuD2K841XYsbNtRep7jhDGpQGB4KZIUftYVe/gq4hjcs4/Fy+CFhjZ0SjkDSild0IV6jYtAcyELw9+SJD31TqKRB24BrtY53A==
Content-Disposition: inline
In-Reply-To: <Y+GMbWWP/YhtJQqe-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Mon, Feb 06, 2023 at 01:25:33PM -1000, Tejun Heo wrote:
> On Mon, Feb 06, 2023 at 02:39:17PM -0800, Yosry Ahmed wrote:
> > On Mon, Feb 6, 2023 at 2:36 PM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > >
> > > On Mon, Feb 06, 2023 at 02:32:10PM -0800, Yosry Ahmed wrote:
> > > > I guess it boils down to which we want:
> > > > (a) Limit the amount of memory processes in a cgroup can be pinned/locked.
> > > > (b) Limit the amount of memory charged to a cgroup that can be pinned/locked.
> > > >
> > > > The proposal is doing (a), I suppose if this was part of memcg it
> > > > would be (b), right?
> > > >
> > > > I am not saying it should be one or the other, I am just making sure
> > > > my understanding is clear.
> > >
> > > I don't quite understand what the distinction would mean in practice. It's
> > > just odd to put locked memory in a separate controller from interface POV.
> > 
> > Assume we have 2 cgroups, A and B. A process in cgroup A creates a
> > tmpfs file and writes to it, so the memory is now charged to cgroup A.
> > Now imagine a process in cgroup B tries to lock this memory.
> > - With (a) the amount of locked memory will count toward's cgroup A's
> > limit, because cgroup A is charged for the memory.
> > - With (b) the amount of locked memory will count toward's cgroup B's
> > limit, because a process in cgroup B is locking the memory.
> > 
> > I agree that it is confusing from an interface POV.
> 
> Oh yeah, that's confusing. I'd go with (a) for consistency with the rest of
> memcg - locked memory should fit inside e.g. memory.max. The problem with
> shared memory accounting exists for non-locked memory as well and prolly
> best to handle the same way rather than handling differently.

(a) kind of destroys the point of this as a sandboxing tool

It is not so harmful to use memory that someone else has been charged
with allocating.

But it is harmful to pin memory if someone else is charged for the
pin. It means it is unpredictable how much memory a sandbox can
actually lock down.

Plus we have the double accounting problem, if 1000 processes in
different cgroups open the tmpfs and all pin the memory then cgroup A
will be charged 1000x for the memory and hit its limit, possibly
creating a DOS from less priv to more priv

Jason
