From: Muchun Song <songmuchun@bytedance.com>
Subject: Re: [External] Re: [RESEND PATCH v2 09/12] mm: memcontrol: convert
 vmstat slab counters to bytes
Date: Tue, 8 Dec 2020 10:44:18 +0800
Message-ID: <CAMZfGtWFrauMfoP6KisvaocY3Y86VXw6YjnV5hiZVWZA6tn-cw@mail.gmail.com>
References: <20201206101451.14706-1-songmuchun@bytedance.com>
 <20201206101451.14706-10-songmuchun@bytedance.com> <20201207194622.GA2238414@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bd4Hsr49ZJKHJxsRFcOWYguXCX0y9MtXs3EZNlzxdm4=;
        b=OXUXdThRs0qPdY6KEOM/aFVNwkZvW9d+93Pe+/JG6Te3MYtWs1tQ8wuA4565rISPTo
         IpMNiPjxjuwB4Z1DOxGmFYQI273fJ2EH4+DDBMSTVGeK+VSYmFHrt4pz5PodmjMHZbS3
         oOOaWCeFh0oO+6FfRMD5IoRVV3WldU8+EEXkoj4pqNIEDdfBsAi0c1pT5GRdvfd6/zC/
         zjZXFVFezJLBqBBA4qo2Y2R1A5YNenWVtVibEMpCLi7QwRVy4hmCYGFDAL+y1vOIaQj0
         d0aI8xhqAnUttrYq9uvO2OWgwb1mbYo4zJt//eX1Psn46BEDnZ/VJNUmiOoqb/R1a5OU
         lPIA==
In-Reply-To: <20201207194622.GA2238414@carbon.dhcp.thefacebook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, rafael@kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>, Mike Rapoport <rppt@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, esyr@redhat.com, peterx@redhat.com, krisman@collabora.com, Suren Baghdasaryan <surenb@google.com>, avagin@openvz.org, Marco Elver <elver@google.com>, Randy Dunlap <rdunlap@infradead.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, Cgroups <c>

On Tue, Dec 8, 2020 at 3:46 AM Roman Gushchin <guro@fb.com> wrote:
>
> On Sun, Dec 06, 2020 at 06:14:48PM +0800, Muchun Song wrote:
> > the global and per-node counters are stored in pages, however memcg
> > and lruvec counters are stored in bytes. This scheme looks weird.
> > So convert all vmstat slab counters to bytes.
>
> There is a reason for this weird scheme:
> percpu caches (see struct per_cpu_nodestat) are s8, so counting in bytes
> will lead to overfills. Switching to s32 can lead to an increase in
> the cache thrashing, especially on small machines.

Thanks Roman. I see now.

>
> >
> > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > ---
> >  include/linux/vmstat.h | 17 ++++++++++-------
> >  mm/vmstat.c            | 21 ++++++++++-----------
> >  2 files changed, 20 insertions(+), 18 deletions(-)
> >
> > diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
> > index 322dcbfcc933..fd1a3d5d4926 100644
> > --- a/include/linux/vmstat.h
> > +++ b/include/linux/vmstat.h
> > @@ -197,18 +197,26 @@ static inline
> >  unsigned long global_node_page_state_pages(enum node_stat_item item)
> >  {
> >       long x = atomic_long_read(&vm_node_stat[item]);
> > +
> >  #ifdef CONFIG_SMP
> >       if (x < 0)
> >               x = 0;
> >  #endif
> > +     if (vmstat_item_in_bytes(item))
> > +             x >>= PAGE_SHIFT;
> >       return x;
> >  }
> >
> >  static inline unsigned long global_node_page_state(enum node_stat_item item)
> >  {
> > -     VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
> > +     long x = atomic_long_read(&vm_node_stat[item]);
> >
> > -     return global_node_page_state_pages(item);
> > +     VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
> > +#ifdef CONFIG_SMP
> > +     if (x < 0)
> > +             x = 0;
> > +#endif
> > +     return x;
> >  }
> >
> >  static inline unsigned long zone_page_state(struct zone *zone,
> > @@ -312,11 +320,6 @@ static inline void __mod_zone_page_state(struct zone *zone,
> >  static inline void __mod_node_page_state(struct pglist_data *pgdat,
> >                       enum node_stat_item item, int delta)
> >  {
> > -     if (vmstat_item_in_bytes(item)) {
> > -             VM_WARN_ON_ONCE(delta & (PAGE_SIZE - 1));
> > -             delta >>= PAGE_SHIFT;
> > -     }
> > -
> >       node_page_state_add(delta, pgdat, item);
> >  }
> >
> > diff --git a/mm/vmstat.c b/mm/vmstat.c
> > index 8d77ee426e22..7fb0c7cb9516 100644
> > --- a/mm/vmstat.c
> > +++ b/mm/vmstat.c
> > @@ -345,11 +345,6 @@ void __mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
> >       long x;
> >       long t;
> >
> > -     if (vmstat_item_in_bytes(item)) {
> > -             VM_WARN_ON_ONCE(delta & (PAGE_SIZE - 1));
> > -             delta >>= PAGE_SHIFT;
> > -     }
> > -
> >       x = delta + __this_cpu_read(*p);
> >
> >       t = __this_cpu_read(pcp->stat_threshold);
> > @@ -554,11 +549,6 @@ static inline void mod_node_state(struct pglist_data *pgdat,
> >       s8 __percpu *p = pcp->vm_node_stat_diff + item;
> >       long o, n, t, z;
> >
> > -     if (vmstat_item_in_bytes(item)) {
> > -             VM_WARN_ON_ONCE(delta & (PAGE_SIZE - 1));
> > -             delta >>= PAGE_SHIFT;
> > -     }
> > -
> >       do {
> >               z = 0;  /* overflow to node counters */
> >
> > @@ -1012,19 +1002,28 @@ unsigned long node_page_state_pages(struct pglist_data *pgdat,
> >                                   enum node_stat_item item)
> >  {
> >       long x = atomic_long_read(&pgdat->vm_stat[item]);
> > +
> >  #ifdef CONFIG_SMP
> >       if (x < 0)
> >               x = 0;
> >  #endif
> > +     if (vmstat_item_in_bytes(item))
> > +             x >>= PAGE_SHIFT;
> >       return x;
> >  }
> >
> >  unsigned long node_page_state(struct pglist_data *pgdat,
> >                             enum node_stat_item item)
> >  {
> > +     long x = atomic_long_read(&pgdat->vm_stat[item]);
> > +
> >       VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
> >
> > -     return node_page_state_pages(pgdat, item);
> > +#ifdef CONFIG_SMP
> > +     if (x < 0)
> > +             x = 0;
> > +#endif
> > +     return x;
> >  }
> >  #endif
> >
> > --
> > 2.11.0
> >



-- 
Yours,
Muchun
