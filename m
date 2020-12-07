From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [External] Re: [RESEND PATCH v2 00/12] Convert all vmstat
 counters to pages or bytes
Date: Mon, 7 Dec 2020 11:51:41 -0800
Message-ID: <20201207195141.GB2238414@carbon.dhcp.thefacebook.com>
References: <20201206101451.14706-1-songmuchun@bytedance.com>
 <20201207130018.GJ25569@dhcp22.suse.cz>
 <CAMZfGtWSEKWqR4f+23xt+jVF-NLSTVQ0L0V3xfZsQzV7aeebhw@mail.gmail.com>
 <20201207150254.GL25569@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ApH9spN0E9R4hdJB2VpBfFP9PfbnPsafyCHQUiddqR0=;
 b=FkJlnRn13qM2/kEazcX7qrWzMV5MN0aTky0zy8EqasQNqWmP3SgTwa8a3VpcyjdmLmtH
 qX6usjb75l+aUi0R5ROwHPqJKtIfqZdDv4OJ/4SLdlN0mO91UJReLJBB/5Bwl19KMs/D
 lzI3KOV51xkiNmnhejlHPwgYIj0tkF2H/GY= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ApH9spN0E9R4hdJB2VpBfFP9PfbnPsafyCHQUiddqR0=;
 b=JHcY7Zo5fH17knmY5ekt7Ua+hSWWgabripmN9XUsnuc77auYnR316pOXrtYRA5xySYg2fv6/CpguaJE9RNenQ5tI8A6Ug4LvI7T2vjybWF362wzi4s2AY4wEAs5LbTahGQtkxJA0gt6T2LtYKAdm+StcDPLj/wY4zG6dDNG79QY=
Content-Disposition: inline
In-Reply-To: <20201207150254.GL25569-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, krisman-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Mon, Dec 07, 2020 at 04:02:54PM +0100, Michal Hocko wrote:
> On Mon 07-12-20 22:52:30, Muchun Song wrote:
> > On Mon, Dec 7, 2020 at 9:00 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > >
> > > On Sun 06-12-20 18:14:39, Muchun Song wrote:
> > > > Hi,
> > > >
> > > > This patch series is aimed to convert all THP vmstat counters to pages
> > > > and some KiB vmstat counters to bytes.
> > > >
> > > > The unit of some vmstat counters are pages, some are bytes, some are
> > > > HPAGE_PMD_NR, and some are KiB. When we want to expose these vmstat
> > > > counters to the userspace, we have to know the unit of the vmstat counters
> > > > is which one. It makes the code complex. Because there are too many choices,
> > > > the probability of making a mistake will be greater.
> > > >
> > > > For example, the below is some bug fix:
> > > >   - 7de2e9f195b9 ("mm: memcontrol: correct the NR_ANON_THPS counter of hierarchical memcg")
> > > >   - not committed(it is the first commit in this series) ("mm: memcontrol: fix NR_ANON_THPS account")
> > > >
> > > > This patch series can make the code simple (161 insertions(+), 187 deletions(-)).
> > > > And make the unit of the vmstat counters are either pages or bytes. Fewer choices
> > > > means lower probability of making mistakes :).
> > > >
> > > > This was inspired by Johannes and Roman. Thanks to them.
> > >
> > > It would be really great if you could summarize the current and after
> > > the patch state so that exceptions are clear and easier to review. The
> > 
> > Agree. Will do in the next version. Thanks.
> > 
> > 
> > > existing situation is rather convoluted but we have at least units part
> > > of the name so it is not too hard to notice that. Reducing exeptions
> > > sounds nice but I am not really sure it is such an improvement it is
> > > worth a lot of code churn. Especially when it comes to KB vs B. Counting
> > 
> > There are two vmstat counters (NR_KERNEL_STACK_KB and
> > NR_KERNEL_SCS_KB) whose units are KB. If we do this, all
> > vmstat counter units are either pages or bytes in the end. When
> > we expose those counters to userspace, it can be easy. You can
> > reference to:
> > 
> >     [RESEND PATCH v2 11/12] mm: memcontrol: make the slab calculation consistent
> > 
> > From this point of view, I think that it is worth doing this. Right?
> 
> Well, unless I am missing something, we have two counters in bytes, two
> in kB, both clearly distinguishable by the B/KB suffix. Changing KB to B
> will certainly reduce the different classes of units, no question about
> that, but I am not really sure this is worth all the code churn. Maybe
> others will think otherwise.

Even if it was me who suggested it, I do agree. It's nice to have a smaller number
of units, but if it creates a lot of hassle, then it makes not much sense.
I think we need to look at the final version of patches and decide if it
worth it or not.

> 
> As I've said the THP accounting change makes more sense to me because it
> allows future changes which are already undergoing so there is more
> merit in those.

+1
And this part is absolutely trivial.
