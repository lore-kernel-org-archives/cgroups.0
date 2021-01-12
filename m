From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: prevent starvation when writing memory.high
Date: Tue, 12 Jan 2021 12:28:04 -0800
Message-ID: <CALvZod4qKrwvT7MAKrhemjrBfAAsk=fKa9g8QRij42j0CaF4nw@mail.gmail.com>
References: <20210112163011.127833-1-hannes@cmpxchg.org> <CALvZod4VFA52dsdkW79-gUbiCf2ONfFJj6LkRU+3-fQpvYXL+A@mail.gmail.com>
 <X/3+IgDVb+Jn4XfQ@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5960geX9HCG16DZ39o4+2JHIAqK0nJMhnDxc5cpnSNU=;
        b=GkTjCKATdgwwzl5zWFKM/GZkJ8Ru5mD2K4+0F8dAgffuBUOVU+23PX0EQ32Blth15w
         JG7AF7Z66SHX+yZKqO4phDlR31DIpX/ncUdaDbhFLbNBCt8yLxNJ4dZS7u1rUVE6tpaH
         +HDiGZhynjjrtmmziGnzXsAsJ5iYJkxSXkDi1q7gwxJs9+p6ZKTagbX6o3TGF7DkFF+N
         68trtXJdFXS/9iK8vcTYWckfat2CPb6DnRQ/pT2cX6VG/5Dh7iaiF44HAEPKNkdL90xT
         BXsKesBCDYzHOyFbbyEKIKnz4Jtp8aNIG2C6b3rUzc3TjWPq7dE55a+n0ogYYoHtyDj3
         5p2g==
In-Reply-To: <X/3+IgDVb+Jn4XfQ-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

On Tue, Jan 12, 2021 at 11:55 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> On Tue, Jan 12, 2021 at 10:59:58AM -0800, Shakeel Butt wrote:
> > On Tue, Jan 12, 2021 at 9:12 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > >
> > > When a value is written to a cgroup's memory.high control file, the
> > > write() context first tries to reclaim the cgroup to size before
> > > putting the limit in place for the workload. Concurrent charges from
> > > the workload can keep such a write() looping in reclaim indefinitely.
> > >
> >
> > Is this observed on real workload?
>
> Yes.
>
> On several production hosts running a particularly aggressive
> workload, we've observed writers to memory.high getting stuck for
> minutes while consuming significant amount of CPU.
>

Good to add this in the commit message or at least mentioning that it
happened in production.

> > Any particular reason to remove !reclaimed?
>
> It's purpose so far was to allow successful reclaim to continue
> indefinitely, while restricting no-progress loops to 'nr_retries'.
>
> Without the first part, it doesn't really matter whether reclaim is
> making progress or not: we do a maximum of 'nr_retries' loops until
> the cgroup size meets the new limit, then exit one way or another.

Does it make sense to add this in the commit message as well? I am
fine with either way.

For the patch:
Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
