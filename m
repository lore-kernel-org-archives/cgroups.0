From: Muchun Song <songmuchun@bytedance.com>
Subject: Re: [External] Re: [PATCH 5/9] mm: memcontrol: convert NR_FILE_THPS
 account to pages
Date: Sun, 6 Dec 2020 00:52:34 +0800
Message-ID: <CAMZfGtUTotdRbGEE85SD_6B7_X=L1hU_8JAWbwPN7ztWCTD-Sg@mail.gmail.com>
References: <20201205130224.81607-1-songmuchun@bytedance.com>
 <20201205130224.81607-6-songmuchun@bytedance.com> <X8uU6ODzteuBY9pf@kroah.com>
 <CAMZfGtWjumNV4hu-Qv8Z+WoS-EmyhvQd1qsaoS1quvQCyczT=g@mail.gmail.com>
 <X8uoITGcfvZ/EA74@kroah.com> <CAMZfGtWmoPjuxfwYFUACRBCBgk3q77Sfv0kE2ysoX-9LJ8s2Zw@mail.gmail.com>
 <X8u2TavrUAnnhq+M@kroah.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4TjBWxHeiYLGN2gLQ9wB5wlqIelnuKaJ3NWlRad2iWo=;
        b=lHercq+HFs9Uw4tBCUBPVfm4XBHEjObQ2+zuVWYecpGDyqFLGynsD/AS+5i0AyeHq/
         K6ze34AxmCpza061G3nwgZIiUh0OmEOpNFMg+6zIIGochjQhJZMMclJbcnWaQjNFl4jH
         FHmt9G4qXYxRcmaDVviFYXWC40swpwKncRblXHFOMLT/bPiCU6AjbLED5NF2oKlJJBoV
         jkVuZmlzv7QfSJNzrIohVAVf6pxyKeWq6LyIcowmbgYTxrkUjlB7EThoh9ahUzcwn5um
         OgPX+0xIn0N6nmIBXwGoSm3purEI2y21/BPelFRc0s9F5r0ZH9z63jHb+Tu4eBj/mOre
         eBJA==
In-Reply-To: <X8u2TavrUAnnhq+M@kroah.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg KH <gregkh@linuxfoundation.org>
Cc: rafael@kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>, Roman Gushchin <guro@fb.com>, Mike Rapoport <rppt@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, esyr@redhat.com, peterx@redhat.com, krisman@collabora.com, Suren Baghdasaryan <surenb@google.com>, avagin@openvz.org, Marco Elver <elver@google.com>, Randy Dunlap <rdunlap@infradead.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, Cgroups <cgroups@vger.kern>

On Sun, Dec 6, 2020 at 12:32 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Sat, Dec 05, 2020 at 11:39:24PM +0800, Muchun Song wrote:
> > On Sat, Dec 5, 2020 at 11:32 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Sat, Dec 05, 2020 at 11:29:26PM +0800, Muchun Song wrote:
> > > > On Sat, Dec 5, 2020 at 10:09 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > On Sat, Dec 05, 2020 at 09:02:20PM +0800, Muchun Song wrote:
> > > > > > Converrt NR_FILE_THPS account to pages.
> > > > > >
> > > > > > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > > > > > ---
> > > > > >  drivers/base/node.c | 3 +--
> > > > > >  fs/proc/meminfo.c   | 2 +-
> > > > > >  mm/filemap.c        | 2 +-
> > > > > >  mm/huge_memory.c    | 3 ++-
> > > > > >  mm/khugepaged.c     | 2 +-
> > > > > >  mm/memcontrol.c     | 5 ++---
> > > > > >  6 files changed, 8 insertions(+), 9 deletions(-)
> > > > > >
> > > > > > diff --git a/drivers/base/node.c b/drivers/base/node.c
> > > > > > index 05c369e93e16..f6a9521bbcf8 100644
> > > > > > --- a/drivers/base/node.c
> > > > > > +++ b/drivers/base/node.c
> > > > > > @@ -466,8 +466,7 @@ static ssize_t node_read_meminfo(struct device *dev,
> > > > > >                                   HPAGE_PMD_NR),
> > > > > >                            nid, K(node_page_state(pgdat, NR_SHMEM_PMDMAPPED) *
> > > > > >                                   HPAGE_PMD_NR),
> > > > > > -                          nid, K(node_page_state(pgdat, NR_FILE_THPS) *
> > > > > > -                                 HPAGE_PMD_NR),
> > > > > > +                          nid, K(node_page_state(pgdat, NR_FILE_THPS)),
> > > > >
> > > > > Again, is this changing a user-visable value?
> > > > >
> > > >
> > > > Of course not.
> > > >
> > > > In the previous, the NR_FILE_THPS account is like below:
> > > >
> > > >     __mod_lruvec_page_state(page, NR_FILE_THPS, 1);
> > > >
> > > > With this patch, it is:
> > > >
> > > >     __mod_lruvec_page_state(page, NR_FILE_THPS, HPAGE_PMD_NR);
> > > >
> > > > So the result is not changed from the view of user space.
> > >
> > > So you "broke" it on the previous patch and "fixed" it on this one?  Why
> > > not just do it all in one patch?
> >
> > Sorry for the confusion. I mean that the "previous" is without all of this patch
> > series. So this series is aimed to convert the unit of all different THP vmstat
> > counters from HPAGE_PMD_NR to pages. Thanks.
>
> I'm sorry, I still do not understand.  It looks to me that you are
> changing the number printed to userspace here.  Where is the
> corrisponding change that changed the units for this function?  Is it in
> this patch?  If so, sorry, I did not see that at all...

Sorry, actually, this patch does not change the number printed to
userspace. It only changes the unit of the vmstat counter.

Without this patch, every counter of NR_FILE_THPS represents
NR_FILE_THPS pages. However, with this patch, every counter
represents only one page. And why do I want to do this? Can
reference to the cover letter. Thanks very much.

>
> thanks,
>
> greg k-h



-- 
Yours,
Muchun
