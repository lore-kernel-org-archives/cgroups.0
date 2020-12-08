From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [RESEND PATCH v2 00/12] Convert all vmstat
 counters to pages or bytes
Date: Tue, 8 Dec 2020 10:29:23 +0800
Message-ID: <CAMZfGtUumSm5Adoz+XTzZmjxV7krGQKffuh6NaBP0FVgTFtoJg@mail.gmail.com>
References: <20201206101451.14706-1-songmuchun@bytedance.com>
 <20201207130018.GJ25569@dhcp22.suse.cz> <CAMZfGtWSEKWqR4f+23xt+jVF-NLSTVQ0L0V3xfZsQzV7aeebhw@mail.gmail.com>
 <20201207150254.GL25569@dhcp22.suse.cz> <30ebae81-86e8-80db-feb6-d7c47dbaccb2@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CH7xlBpG5Zzki/I0pNBCcovPXjgp215OcunjJaNzVcc=;
        b=V7atJSCte4bFOWHk0qsCWTfnLuJ+UxQ/uwlkqIATLHBwZoo+PiUsnBOD/Eh8d5fLjb
         fic9D7J2wW7Kfc/uN96HMHD1VaNDk6m8UIHLD5y9sGrwLWk2uvmxbvLOc+pMpAIHp9en
         UZkOvNmBlt7mPlN/HxiVH1/FDjn6Kcjq5ueHMQVzwHAK6DH730S3sPzUFDeOku8m4POh
         4uT1KDIT9Icxs9Cg6+xXE/3D1v/iNGPP7OUKux/LT6sanoaCOsbpxYx6Rv7dr0u+mHcY
         O0g3F8kKAW6PnnhlrhwoPeTuyUEGrPHdo3RTKoNBx+FOfTcMKLNHoU9LrgpGakM5r8hI
         FTRw==
In-Reply-To: <30ebae81-86e8-80db-feb6-d7c47dbaccb2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, krisman-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TZUIDd8j+nm9g@public.gmane.org>

On Tue, Dec 8, 2020 at 2:51 AM Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>
> On 12/7/20 7:02 AM, Michal Hocko wrote:
> > On Mon 07-12-20 22:52:30, Muchun Song wrote:
> >> On Mon, Dec 7, 2020 at 9:00 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> >>>
> >>> On Sun 06-12-20 18:14:39, Muchun Song wrote:
> >>>> Hi,
> >>>>
> >>>> This patch series is aimed to convert all THP vmstat counters to pages
> >>>> and some KiB vmstat counters to bytes.
> >>>>
> >>>> The unit of some vmstat counters are pages, some are bytes, some are
> >>>> HPAGE_PMD_NR, and some are KiB. When we want to expose these vmstat
> >>>> counters to the userspace, we have to know the unit of the vmstat counters
> >>>> is which one. It makes the code complex. Because there are too many choices,
> >>>> the probability of making a mistake will be greater.
> >>>>
> >>>> For example, the below is some bug fix:
> >>>>   - 7de2e9f195b9 ("mm: memcontrol: correct the NR_ANON_THPS counter of hierarchical memcg")
> >>>>   - not committed(it is the first commit in this series) ("mm: memcontrol: fix NR_ANON_THPS account")
> >>>>
> >>>> This patch series can make the code simple (161 insertions(+), 187 deletions(-)).
> >>>> And make the unit of the vmstat counters are either pages or bytes. Fewer choices
> >>>> means lower probability of making mistakes :).
> >>>>
> >>>> This was inspired by Johannes and Roman. Thanks to them.
> >>>
> >>> It would be really great if you could summarize the current and after
> >>> the patch state so that exceptions are clear and easier to review. The
> >>
> >> Agree. Will do in the next version. Thanks.
> >>
> >>
> >>> existing situation is rather convoluted but we have at least units part
> >>> of the name so it is not too hard to notice that. Reducing exeptions
> >>> sounds nice but I am not really sure it is such an improvement it is
> >>> worth a lot of code churn. Especially when it comes to KB vs B. Counting
> >>
> >> There are two vmstat counters (NR_KERNEL_STACK_KB and
> >> NR_KERNEL_SCS_KB) whose units are KB. If we do this, all
> >> vmstat counter units are either pages or bytes in the end. When
> >> we expose those counters to userspace, it can be easy. You can
> >> reference to:
> >>
> >>     [RESEND PATCH v2 11/12] mm: memcontrol: make the slab calculation consistent
> >>
> >> From this point of view, I think that it is worth doing this. Right?
> >
> > Well, unless I am missing something, we have two counters in bytes, two
> > in kB, both clearly distinguishable by the B/KB suffix. Changing KB to B
> > will certainly reduce the different classes of units, no question about
> > that, but I am not really sure this is worth all the code churn. Maybe
> > others will think otherwise.
> >
> > As I've said the THP accounting change makes more sense to me because it
> > allows future changes which are already undergoing so there is more
> > merit in those.
> >
>
> Hi,
>
> Are there any documentation changes that go with these patches?
> Or are none needed?
>
> If the patches change the output in /proc/* or /sys/* then I expect
> there would need to be some doc changes.

Oh, we do not change the output. It is transparent to userspace.

Thanks.

>
> And is there any chance of confusing userspace s/w (binary or scripts)
> with these changes?
>
> thanks.
> --
> ~Randy
>


-- 
Yours,
Muchun
