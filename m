From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [External] Re: [PATCH 5/9] mm: memcontrol: convert NR_FILE_THPS
 account to pages
Date: Sat, 5 Dec 2020 16:32:49 +0100
Message-ID: <X8uoITGcfvZ/EA74@kroah.com>
References: <20201205130224.81607-1-songmuchun@bytedance.com>
 <20201205130224.81607-6-songmuchun@bytedance.com>
 <X8uU6ODzteuBY9pf@kroah.com>
 <CAMZfGtWjumNV4hu-Qv8Z+WoS-EmyhvQd1qsaoS1quvQCyczT=g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607182373;
        bh=YvwWbwUJz4IsDZPSgrDxX9tu/27SyYUwe/JZizJeblA=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=mrTHi9vVfhyA42YnDVcB34yiTLBSymgeakxRNtgMdkIcHq3gM4SpZeohUcBjJiiOC
         KYpF6+h2Vsl0LLBEgyxzmUbbwQbICwRpvxibvUcVhMLAhJubFkIl+6gGZd9aI6V0/d
         UO6pX0KDAvixCm+HGsq2/Ixiff3DUqAKIhXVvLlo=
Content-Disposition: inline
In-Reply-To: <CAMZfGtWjumNV4hu-Qv8Z+WoS-EmyhvQd1qsaoS1quvQCyczT=g@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, krisman-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29Tb/PtFMR13I2A@public.gmane.org>

On Sat, Dec 05, 2020 at 11:29:26PM +0800, Muchun Song wrote:
> On Sat, Dec 5, 2020 at 10:09 PM Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> >
> > On Sat, Dec 05, 2020 at 09:02:20PM +0800, Muchun Song wrote:
> > > Converrt NR_FILE_THPS account to pages.
> > >
> > > Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> > > ---
> > >  drivers/base/node.c | 3 +--
> > >  fs/proc/meminfo.c   | 2 +-
> > >  mm/filemap.c        | 2 +-
> > >  mm/huge_memory.c    | 3 ++-
> > >  mm/khugepaged.c     | 2 +-
> > >  mm/memcontrol.c     | 5 ++---
> > >  6 files changed, 8 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/drivers/base/node.c b/drivers/base/node.c
> > > index 05c369e93e16..f6a9521bbcf8 100644
> > > --- a/drivers/base/node.c
> > > +++ b/drivers/base/node.c
> > > @@ -466,8 +466,7 @@ static ssize_t node_read_meminfo(struct device *dev,
> > >                                   HPAGE_PMD_NR),
> > >                            nid, K(node_page_state(pgdat, NR_SHMEM_PMDMAPPED) *
> > >                                   HPAGE_PMD_NR),
> > > -                          nid, K(node_page_state(pgdat, NR_FILE_THPS) *
> > > -                                 HPAGE_PMD_NR),
> > > +                          nid, K(node_page_state(pgdat, NR_FILE_THPS)),
> >
> > Again, is this changing a user-visable value?
> >
> 
> Of course not.
> 
> In the previous, the NR_FILE_THPS account is like below:
> 
>     __mod_lruvec_page_state(page, NR_FILE_THPS, 1);
> 
> With this patch, it is:
> 
>     __mod_lruvec_page_state(page, NR_FILE_THPS, HPAGE_PMD_NR);
> 
> So the result is not changed from the view of user space.

So you "broke" it on the previous patch and "fixed" it on this one?  Why
not just do it all in one patch?

Confused,

greg k-h
