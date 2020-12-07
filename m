From: Hugh Dickins <hughd@google.com>
Subject: Re: [External] Re: [RESEND PATCH v2 00/12] Convert all vmstat counters
 to pages or bytes
Date: Mon, 7 Dec 2020 12:33:18 -0800 (PST)
Message-ID: <alpine.LSU.2.11.2012071218540.9574@eggly.anvils>
References: <20201206101451.14706-1-songmuchun@bytedance.com> <20201207130018.GJ25569@dhcp22.suse.cz> <CAMZfGtWSEKWqR4f+23xt+jVF-NLSTVQ0L0V3xfZsQzV7aeebhw@mail.gmail.com> <20201207150254.GL25569@dhcp22.suse.cz>
 <20201207195141.GB2238414@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=VF+dRBuajSL16Efm+Qk9iftapw2E7SOSirPhcnw+PnQ=;
        b=ZRA2+e52xlSYiJHPZTaBAxFXuVgSCguGt+17cXdyunFJAuKyaHC0N9M0+4wVV+JNu/
         aS6Ru6m3Y+wnCnDvTaR0B9YOhtU4H+7LE/3LGO0G8PmR1IrdqhucfywKGLBMNQLyMXu/
         XJSr+UlHYySaZWgshmFkJXhyvI//6ZYqsYHP2wgrjLmT1qlB1JlPb9O13tbr6L0bBWLe
         GRMCt7godtRnbrHZWJKC5DL6rW4nmuRO1x9OHwbZyq7CAqDi7cjSnTBdGjEjq1IFVhKo
         fbeRgmd7/Vs61w3QEF43+SBNzMP6YdnFO+5G59r4xPy9OUThCHiccAY3BNCrGBsllVky
         hvJQ==
In-Reply-To: <20201207195141.GB2238414@carbon.dhcp.thefacebook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@suse.com>, Muchun Song <songmuchun@bytedance.com>, Greg KH <gregkh@linuxfoundation.org>, rafael@kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>, Mike Rapoport <rppt@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, esyr@redhat.com, peterx@redhat.com, krisman@collabora.com, Suren Baghdasaryan <surenb@google.com>, avagin@openvz.org, Marco Elver <elver@google.com>, Randy Dunlap <rdunlap@infradead.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux

On Mon, 7 Dec 2020, Roman Gushchin wrote:
> On Mon, Dec 07, 2020 at 04:02:54PM +0100, Michal Hocko wrote:
> > 
> > As I've said the THP accounting change makes more sense to me because it
> > allows future changes which are already undergoing so there is more
> > merit in those.
> 
> +1
> And this part is absolutely trivial.

It does need to be recognized that, with these changes, every THP stats
update overflows the per-cpu counter, resorting to atomic global updates.
And I'd like to see that mentioned in the commit message.

But this change is consistent with 4.7's 8f182270dfec ("mm/swap.c: flush
lru pvecs on compound page arrival"): we accepted greater overhead for
greater accuracy back then, so I think it's okay to do so for THP stats.

Hugh
