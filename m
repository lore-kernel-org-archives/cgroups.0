From: Muchun Song <songmuchun@bytedance.com>
Subject: Re: [External] Re: [RESEND PATCH v2 02/12] mm: memcontrol: convert
 NR_ANON_THPS account to pages
Date: Fri, 11 Dec 2020 01:05:57 +0800
Message-ID: <CAMZfGtWBqR=__CLL_nsXUAOirT8mrgCjh8BTipNH_H2qUijixA@mail.gmail.com>
References: <20201206101451.14706-1-songmuchun@bytedance.com>
 <20201206101451.14706-3-songmuchun@bytedance.com> <20201210161029.GI264602@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OfRhTAas1NcetqsYHCdhKdRkmhDx/6FtHvtSU75aAas=;
        b=Mb7SoDls4nifj95yys/nowAqBSY/LC+BoX0EAbTxa/y37i1DCYf4rw1bYQJ4mH4vYL
         /1ttdgE5mTdf5ZZpBvmUxqILY8drb6/plJX6BwO2W8VE3YlkIQfaf51ZC2x1kQT0g3KR
         CIcHoj27fgpFrnmV3MYI9byhT8ZNtQzXErfG0CToemZtuHzIKA8WsjG+A5ykxbFi2KnZ
         yeCY2mGPMAlz+HrKB3/d/fc5YUhKBSIF4Yxg1cn0R7pweYEYK1VMPizYW8ntZY9wTL4Q
         3UU9CuW31tWbcEDJ3/7Br6bxpfYVuEwjWp3JbOBj+6c/hfa3Fo4hoT+tfeHOuOoUXtyT
         mpJA==
In-Reply-To: <20201210161029.GI264602@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>, Roman Gushchin <guro@fb.com>, Mike Rapoport <rppt@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, esyr@redhat.com, peterx@redhat.com, krisman@collabora.com, Suren Baghdasaryan <surenb@google.com>, avagin@openvz.org, Marco Elver <elver@google.com>, Randy Dunlap <rdunlap@infradead.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>

On Fri, Dec 11, 2020 at 12:12 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Sun, Dec 06, 2020 at 06:14:41PM +0800, Muchun Song wrote:
> > @@ -1144,7 +1144,8 @@ void do_page_add_anon_rmap(struct page *page,
> >                * disabled.
> >                */
> >               if (compound)
> > -                     __inc_lruvec_page_state(page, NR_ANON_THPS);
> > +                     __mod_lruvec_page_state(page, NR_ANON_THPS,
> > +                                             HPAGE_PMD_NR);
> >               __mod_lruvec_page_state(page, NR_ANON_MAPPED, nr);
>
> What I mistakenly wrote about the previous patch applies to this and
> the following patches, though:
>
> /proc/vmstat currently prints number of anon, file and shmem THPs; you
> are changing it to print number of 4k pages in those THPs.
>
> That's an ABI change we cannot really do.

Agree. Sorry. I forgot to fix the /proc/vmstat. Thanks for your
reminder.


-- 
Yours,
Muchun
