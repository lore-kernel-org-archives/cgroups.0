From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Thu, 23 Feb 2023 10:14:04 -0800
Message-ID: <CAJD7tkZHZrxK_szH=5tdDZzhDTNXpBVD-e+79RzFmpp_ZYMcBA@mail.gmail.com>
References: <Y/Ua6VcNe/DFh7X4@nvidia.com> <Y/UfS8TDIXhUlJ/I@slm.duckdns.org>
 <Y/UiQmuVwh2eqrfA@nvidia.com> <87o7pmnd0p.fsf@nvidia.com> <Y/YRJNwwvqp7nKKt@nvidia.com>
 <87k009nvnr.fsf@nvidia.com> <Y/bHNO7A8T3QQ5T+@nvidia.com> <CABdmKX18MY19bnsxN5W38Z9zmoaZx+S4+zzN_5XCYDBruwPrLg@mail.gmail.com>
 <Y/eiLBo88pgr2IUm@nvidia.com> <CAJD7tkadBRP22qP63-SjKSch1im9sHLoMzc6c2h10+ggbuxqMg@mail.gmail.com>
 <Y/esMBOyTaJnv5CW@nvidia.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VG9TRi7KY1FPj+JgMoZ9/Bap5BH1LM2HcOOT/7ev4eA=;
        b=D2wc9ublqoinhiPSET5Dt0IY9YkjUb0e1mbrI5aveVWbYaT5mTOY1SmpkdzdcDCXhy
         0tKgbqq35FTY2mCV9OliNawcLPyYie3JC/ov3fv+B8xEzv008yfXCoExBDaHBPUFIGQ9
         XcSO0t72+wVLJSh7AyZjyJdtIqHS30Q6JS3FZAWYfJQCWaOeuiKlk7PWsh5/OSZrnz5S
         hHJwPirimq5+UX1iA5mmqF6u7koMXvksCK4sS9mgfpt+uQJwsnQSVfzocj0q4CNGiWOc
         29XttugOluiL6gDHvkBeGMLGDVE5ZWt+GrVdqPTAnU4uE3qHk1suzlCFjuCHJJfJismS
         +Smg==
In-Reply-To: <Y/esMBOyTaJnv5CW-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Thu, Feb 23, 2023 at 10:11 AM Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Thu, Feb 23, 2023 at 10:03:50AM -0800, Yosry Ahmed wrote:
> > On Thu, Feb 23, 2023 at 9:28 AM Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> wrote:
> > >
> > > On Thu, Feb 23, 2023 at 09:18:23AM -0800, T.J. Mercier wrote:
> > >
> > > > > Solving that problem means figuring out when every cgroup stops using
> > > > > the memory - pinning or not. That seems to be very costly.
> > > > >
> > > > This is the current behavior of accounting for memfds, and I suspect
> > > > any kind of shared memory.
> > > >
> > > > If cgroup A creates a memfd, maps and faults in pages, shares the
> > > > memfd with cgroup B and then A unmaps and closes the memfd, then
> > > > cgroup A is still charged for the pages it faulted in.
> > >
> > > As we discussed, as long as the memory is swappable then eventually
> > > memory pressure on cgroup A will evict the memfd pages and then cgroup
> > > B will swap it in and be charged for it.
> >
> > I am not familiar with memfd, but based on
> > mem_cgroup_swapin_charge_folio() it seems like if cgroup B swapped in
> > the pages they will remain charged to cgroup A, unless cgroup A is
> > removed/offlined. Am I missing something?
>
> Ah, I don't know, Tejun said:
>
> "but it can converge when page usage transfers across cgroups
> if needed."
>
> Which I assumed was swap related but I don't know how convergence
> works.

I believe that's the case for file-backed pages, but I do not believe
it's the case for swap-backed pages.

>
> Jason
