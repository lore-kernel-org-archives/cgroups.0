From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v21 15/19] mm/compaction: do page isolation first in
 compaction
Date: Wed, 11 Nov 2020 18:28:38 -0800 (PST)
Message-ID: <alpine.LSU.2.11.2011111803580.2174@eggly.anvils>
References: <1604566549-62481-1-git-send-email-alex.shi@linux.alibaba.com> <1604566549-62481-16-git-send-email-alex.shi@linux.alibaba.com> <a0b8c198-6bd0-2ccb-fe55-970895c26a0b@suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=AvwRUTHJ9jTp1FV7SvxjXPTpodIViw+Olzzn0cdboYg=;
        b=lMyQa3HoSGrWwK8T9kKUMIlmfO5rgLpJnycM2uiTklWJC1raq7dGrWwm2m9/O/if2P
         3n7ga50tjyyPXWvWHiYwKwgL71HOGc0UsHfCamf5Lb/v6jwKiGtkZaV+P/Wht/+eQ0gk
         72CTbdBOF5eQeyXTRetfdXuu3yjIbyVQER+3mo8NswaNnZCCSwUw3+GXKNdL+WpEJPsc
         ZiloYfx5zK7I6BMUOJdaXePB/dRGYPw1vVDN88kE+Fh7udX6Jzsp3ynwIwSGo4T8Wq8k
         XyE0c8ANci/qxhmbZ7uB9liD3aqNmaCP5Ne/bJd5re/Pi7/eHeAqVlF05mv7yH2RRQyu
         ZXKg==
In-Reply-To: <a0b8c198-6bd0-2ccb-fe55-970895c26a0b@suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Alex Shi <alex.shi@linux.alibaba.com>, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com

On Wed, 11 Nov 2020, Vlastimil Babka wrote:
> On 11/5/20 9:55 AM, Alex Shi wrote:
> 
> > @@ -979,10 +995,6 @@ static bool too_many_isolated(pg_data_t *pgdat)
> >   					goto isolate_abort;
> >   			}
> >   -			/* Recheck PageLRU and PageCompound under lock */
> > -			if (!PageLRU(page))
> > -				goto isolate_fail;
> > -
> >   			/*
> >   			 * Page become compound since the non-locked check,
> >   			 * and it's on LRU. It can only be a THP so the order
> > @@ -990,16 +1002,13 @@ static bool too_many_isolated(pg_data_t *pgdat)

Completely off-topic, and won't matter at all when Andrew rediffs into
mmotm: but isn't it weird that this is showing "too_many_isolated(",
when actually the function is isolate_migratepages_block()?

> >   			 */
> >   			if (unlikely(PageCompound(page) &&
> > !cc->alloc_contig)) {
> >   				low_pfn += compound_nr(page) - 1;
> > -				goto isolate_fail;
> > +				SetPageLRU(page);
> > +				goto isolate_fail_put;
> >   			}
> 
> IIUC the danger here is khugepaged will collapse a THP. For that,
> __collapse_huge_page_isolate() has to succeed isolate_lru_page(). Under the
> new scheme, it shouldn't be possible, right? If that's correct, we can remove
> this part?

I don't think so.  A preliminary check for PageCompound was made much
higher up, before taking a reference on the page, but it can easily have
become PageCompound since then (when racing prep_new_page() calls
prep_compound_page()).

And __collapse_huge_page_isolate() does not turn a non-compound page
into a compound page: it isolates small pages before copying them into
the compound page (in the usual case: I can see there's also allowance
for PageCompound there too, which will do something different).

Hugh
