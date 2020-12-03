From: Roman Gushchin <guro@fb.com>
Subject: Re: [External] Re: [PATCH] mm/memcontrol: make the slab calculation
 consistent
Date: Wed, 2 Dec 2020 19:20:52 -0800
Message-ID: <20201203032052.GA1568874@carbon.DHCP.thefacebook.com>
References: <20201202121434.75099-1-songmuchun@bytedance.com>
 <20201202211646.GA1517142@carbon.lan>
 <CAMZfGtWUWAO8J6iBpQLV0T8xPAuQvFTfX9UQ7G2eM_O9C7w83w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Zs34bp8bHYjIfBzqirNIIUOHJapdSElegqWQGPxT5wg=;
 b=h5HFFrmfUYSzhNQYZqcsc9gAB6S+FIMRHU5Y3xHWKH1nrVFxqmlMLo7KdrnXRXNWqewJ
 f+9xuN7vVSmwbeZjQe8mkvSAHVBHLLGxWDWpx7brMAb+GDeh61K1efH0XbQpceIwtL63
 pvjqEmZrWxxB5Kjz7DTmg13nTPLhYA9Dl+M= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zs34bp8bHYjIfBzqirNIIUOHJapdSElegqWQGPxT5wg=;
 b=csDVWBPhhfxMZbEDXmxTISZXMWmsDrGVUSnZF8kfW0a0Bip6wLDzcrVxiWY1vp4iOCZDZSaIPTfdKBwdTNg3Xhmmb1O5Uzjuc+TFsy0L2IOrAQtlRy9yPvWOcwqw8BE5lVcefL6I8I19zJ3sWL3kKrYYQHf03SxQEPn7YIJtDgQ=
Content-Disposition: inline
In-Reply-To: <CAMZfGtWUWAO8J6iBpQLV0T8xPAuQvFTfX9UQ7G2eM_O9C7w83w@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Cgroups <cgroups@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Thu, Dec 03, 2020 at 10:53:33AM +0800, Muchun Song wrote:
> On Thu, Dec 3, 2020 at 5:16 AM Roman Gushchin <guro@fb.com> wrote:
> >
> > On Wed, Dec 02, 2020 at 08:14:34PM +0800, Muchun Song wrote:
> > > Although the ratio of the slab is one, we also should read the ratio
> > > from the related memory_stats instead of hard-coding. And the local
> > > variable of size is already the value of slab_unreclaimable. So we
> > > do not need to read again. Simplify the code here.
> > >
> > > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > > ---
> > >  mm/memcontrol.c | 22 +++++++++++++++++-----
> > >  1 file changed, 17 insertions(+), 5 deletions(-)
> >
> > Hi Muchun!
> >
> > >
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index 9922f1510956..03a9c64560f6 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -1545,12 +1545,22 @@ static int __init memory_stats_init(void)
> > >       int i;
> > >
> > >       for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
> > > +             switch (memory_stats[i].idx) {
> > >  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > > -             if (memory_stats[i].idx == NR_ANON_THPS ||
> > > -                 memory_stats[i].idx == NR_FILE_THPS ||
> > > -                 memory_stats[i].idx == NR_SHMEM_THPS)
> > > +             case NR_ANON_THPS:
> > > +             case NR_FILE_THPS:
> > > +             case NR_SHMEM_THPS:
> > >                       memory_stats[i].ratio = HPAGE_PMD_SIZE;
> > > +                     break;
> > >  #endif
> > > +             case NR_SLAB_UNRECLAIMABLE_B:
> > > +                     VM_BUG_ON(i < 1);
> > > +                     VM_BUG_ON(memory_stats[i - 1].idx != NR_SLAB_RECLAIMABLE_B);
> >
> > Please, convert these to BUILD_BUG_ON(), they don't have to be runtime checks.
> 
> Agree. But here we cannot use BUILD_BUG_ON(). The compiler will
> complain about it.

We can!

We just need to change the condition. All we really need to check is that
NR_SLAB_UNRECLAIMABLE_B immediately following NR_SLAB_RECLAIMABLE_B.

Something like BUILD_BUG_ON(NR_SLAB_UNRECLAIMABLE_B != NR_SLAB_RECLAIMABLE_B + 1)
should work (completely untested).

> 
> >
> >
> > > +                     break;
> > > +             default:
> > > +                     break;
> > > +             }
> > > +
> > >               VM_BUG_ON(!memory_stats[i].ratio);
> > >               VM_BUG_ON(memory_stats[i].idx >= MEMCG_NR_STAT);
> > >       }
> > > @@ -1587,8 +1597,10 @@ static char *memory_stat_format(struct mem_cgroup *memcg)
> > >               seq_buf_printf(&s, "%s %llu\n", memory_stats[i].name, size);
> > >
> >
> > Can you, please, add a small comment here stating that we're printing
> > unreclaimable, reclaimable and the sum of both? It will simplify the reading of the code.
> 
> Will do.

Thank you!
