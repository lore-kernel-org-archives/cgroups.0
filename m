From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v21 15/19] mm/compaction: do page isolation first in
 compaction
Date: Thu, 12 Nov 2020 12:25:26 +0100
Message-ID: <85a40d01-09b6-1647-4ca0-7a83efdd9cbf@suse.cz>
References: <1604566549-62481-1-git-send-email-alex.shi@linux.alibaba.com>
 <1604566549-62481-16-git-send-email-alex.shi@linux.alibaba.com>
 <a0b8c198-6bd0-2ccb-fe55-970895c26a0b@suse.cz>
 <alpine.LSU.2.11.2011111803580.2174@eggly.anvils>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LSU.2.11.2011111803580.2174-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On 11/12/20 3:28 AM, Hugh Dickins wrote:
> On Wed, 11 Nov 2020, Vlastimil Babka wrote:
>> On 11/5/20 9:55 AM, Alex Shi wrote:
>> 
>> > @@ -979,10 +995,6 @@ static bool too_many_isolated(pg_data_t *pgdat)
>> >   					goto isolate_abort;
>> >   			}
>> >   -			/* Recheck PageLRU and PageCompound under lock */
>> > -			if (!PageLRU(page))
>> > -				goto isolate_fail;
>> > -
>> >   			/*
>> >   			 * Page become compound since the non-locked check,
>> >   			 * and it's on LRU. It can only be a THP so the order
>> > @@ -990,16 +1002,13 @@ static bool too_many_isolated(pg_data_t *pgdat)
> 
> Completely off-topic, and won't matter at all when Andrew rediffs into
> mmotm: but isn't it weird that this is showing "too_many_isolated(",
> when actually the function is isolate_migratepages_block()?
> 
>> >   			 */
>> >   			if (unlikely(PageCompound(page) &&
>> > !cc->alloc_contig)) {
>> >   				low_pfn += compound_nr(page) - 1;
>> > -				goto isolate_fail;
>> > +				SetPageLRU(page);
>> > +				goto isolate_fail_put;
>> >   			}
>> 
>> IIUC the danger here is khugepaged will collapse a THP. For that,
>> __collapse_huge_page_isolate() has to succeed isolate_lru_page(). Under the
>> new scheme, it shouldn't be possible, right? If that's correct, we can remove
>> this part?
> 
> I don't think so.  A preliminary check for PageCompound was made much
> higher up, before taking a reference on the page, but it can easily have
> become PageCompound since then (when racing prep_new_page() calls
> prep_compound_page()).
> 
> And __collapse_huge_page_isolate() does not turn a non-compound page
> into a compound page: it isolates small pages before copying them into
> the compound page (in the usual case: I can see there's also allowance
> for PageCompound there too, which will do something different).

Right, on both points, got too confused.

> Hugh
> 

