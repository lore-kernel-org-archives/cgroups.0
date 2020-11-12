From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v21 14/19] mm/lru: introduce TestClearPageLRU
Date: Wed, 11 Nov 2020 18:03:22 -0800 (PST)
Message-ID: <alpine.LSU.2.11.2011111729350.2174@eggly.anvils>
References: <1604566549-62481-1-git-send-email-alex.shi@linux.alibaba.com> <1604566549-62481-15-git-send-email-alex.shi@linux.alibaba.com> <b4c08619-d365-bbaf-de08-9b2495a0a8d8@suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=KyT2mlBYlT2kAm/JHbWqMsOuBJM1d87BrqaaRaUfl50=;
        b=iqee5mg0JMbddEDyf2/xuBU1NZWnAWQDmcxpGfelMd2nKAPy/CPLgkG4iApYTGebQh
         yUBfhOvZXGiwgsEDXQxTtAr7ihzRkOkBe33dvPe2T9i4nrIsRa+nmWvkU6ri/CmLLHU+
         0k7mh1HRa+kWhDkkT1SWLyhPJ9t5KGqxKeLrVvIWgRoXmaWgvAMRjhxLbn1VpzsA+OFG
         EmxMxMa3aKoHuvgHtwDhMqy1TKQyoxAReTZAM95dC7u16k4wnNgEvA0A6tssToLXQzvq
         uWgRdxzDYElGfeIiIVf3cDvAOaYb+231CM6UI0zHdEqLILTIpfXcYLfiMfX75UJ9zujd
         kciw==
In-Reply-To: <b4c08619-d365-bbaf-de08-9b2495a0a8d8@suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Alex Shi <alex.shi@linux.alibaba.com>, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com, Michal Hocko <mhocko@kernel.org>

On Wed, 11 Nov 2020, Vlastimil Babka wrote:
> On 11/5/20 9:55 AM, Alex Shi wrote:
> 
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -1542,7 +1542,7 @@ unsigned int reclaim_clean_pages_from_list(struct
> > zone *zone,
> >    */
> >   int __isolate_lru_page(struct page *page, isolate_mode_t mode)
> >   {
> > -	int ret = -EINVAL;
> > +	int ret = -EBUSY;
> >     	/* Only take pages on the LRU. */
> >   	if (!PageLRU(page))
> > @@ -1552,8 +1552,6 @@ int __isolate_lru_page(struct page *page,
> > isolate_mode_t mode)
> >   	if (PageUnevictable(page) && !(mode & ISOLATE_UNEVICTABLE))
> >   		return ret;
> >   -	ret = -EBUSY;
> 
> I'm not sure why this change is here, looks unrelated to the patch?
> 
> Oh I see, you want to prevent the BUG() in isolate_lru_pages().

Yes, I suggested this part of the patch to Alex, when I hit that BUG().

> 
> But due to that, the PageUnevictable check was also affected unintentionally.
> But I don't think it's that important to BUG() when we run into
> PageUnevictable unexpectedly, so that's probably ok.

Not unintentional.  __isolate_lru_page(), or __isolate_lru_page_prepare(),
is a silly function, used by two callers whose requirements are almost
entirely disjoint.  The ISOLATE_UNEVICTABLE case is only for compaction.c,
which takes no interest in -EINVAL versus -EBUSY, and has no such BUG().

I think it dates back to lumpy reclaim days, and it probably made more
sense back then.

> 
> But with that, we can just make __isolate_lru_page() a bool function and
> remove the ugly switch in  isolate_lru_pages()?

I agree that the switch statement in isolate_lru_pages() seems pointless
now, and can be turned into an if{}else{}.  But that cleanup is a
diversion from this particular TestClearPageLRU patch, and I think from
the whole series (checking final state of the patchset, yes, the switch
is still there - though I think there have been variant series which
removed it).

Can we please leave that cleanup until after the series has gone in?

I think several of us have cleanups or optimization that we want to
follow (I had one that inlines what isolate_migratepages_block() wanted
of __isolate_lru_page() into that function, so simplifying what vmscan.c
needs; perhaps that can now eliminate it completely, I've not tried
recently).  But there was a point at which the series was growing
ten patches per release as we all added our bits and pieces on top,
it got harder and harder to review the whole, and further from
getting the basics in: I do push back against that tendency.

Hugh
