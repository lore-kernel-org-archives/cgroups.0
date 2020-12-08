From: Muchun Song <songmuchun@bytedance.com>
Subject: Re: [External] Re: [RESEND PATCH v2 00/12] Convert all vmstat
 counters to pages or bytes
Date: Tue, 8 Dec 2020 10:42:58 +0800
Message-ID: <CAMZfGtUKvTLOud1cL6mtisq6gtMu-X8th8uoyGtTD4d7LXPa+Q@mail.gmail.com>
References: <20201206101451.14706-1-songmuchun@bytedance.com>
 <20201207130018.GJ25569@dhcp22.suse.cz> <CAMZfGtWSEKWqR4f+23xt+jVF-NLSTVQ0L0V3xfZsQzV7aeebhw@mail.gmail.com>
 <20201207150254.GL25569@dhcp22.suse.cz> <20201207195141.GB2238414@carbon.dhcp.thefacebook.com>
 <alpine.LSU.2.11.2012071218540.9574@eggly.anvils>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jdb7C5Aq6omc7IwwxIaz9ZxTwUguDQHTm2UuR3rHd+Y=;
        b=ydR/LN6K9fneUKUhkvE0+Qv6s3BVCHWfdKrE8qmGsJQvTKxAvH9WDn3PvEV1YToQ++
         ENpqHWssU08a9ws5Cz79XXu2j8Q0956aFERX3PY4UC1SSHoXCBCdCGV/rgwtWULf+KOC
         szt0cHALCdHrYWL4imlZnAkQp9vw0sgOXP0WXl1BcK0B2RH9Ba1SV/nEg7H9W2ZSk00y
         risTzoaMsDDNspp3wyshZifGP61j6MGm1spuBHXbJ9fRUy491LUSUAXxifd/Pyb/+qJy
         R6tsRdYWrGbaeU6n5MgdwPuTfvydofDO5YHGF6V+LZJ0YJeNSm19aKSbA34QXd277huE
         dLwA==
In-Reply-To: <alpine.LSU.2.11.2012071218540.9574@eggly.anvils>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd@google.com>
Cc: Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@suse.com>, Greg KH <gregkh@linuxfoundation.org>, rafael@kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Will Deacon <will@kernel.org>, Mike Rapoport <rppt@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, esyr@redhat.com, peterx@redhat.com, krisman@collabora.com, Suren Baghdasaryan <surenb@google.com>, avagin@openvz.org, Marco Elver <elver@google.com>, Randy Dunlap <rdunlap@infradead.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, Cgroups <cgroups@vger.k>

On Tue, Dec 8, 2020 at 4:33 AM Hugh Dickins <hughd@google.com> wrote:
>
> On Mon, 7 Dec 2020, Roman Gushchin wrote:
> > On Mon, Dec 07, 2020 at 04:02:54PM +0100, Michal Hocko wrote:
> > >
> > > As I've said the THP accounting change makes more sense to me because it
> > > allows future changes which are already undergoing so there is more
> > > merit in those.
> >
> > +1
> > And this part is absolutely trivial.
>
> It does need to be recognized that, with these changes, every THP stats
> update overflows the per-cpu counter, resorting to atomic global updates.
> And I'd like to see that mentioned in the commit message.

Thanks for reminding me. Will add.

>
> But this change is consistent with 4.7's 8f182270dfec ("mm/swap.c: flush
> lru pvecs on compound page arrival"): we accepted greater overhead for
> greater accuracy back then, so I think it's okay to do so for THP stats.

Agree. Thanks.

>
> Hugh



-- 
Yours,
Muchun
