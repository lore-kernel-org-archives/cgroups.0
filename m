From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v8 5/9] hugetlb: disable region_add file_region coalescing
Date: Mon, 4 Nov 2019 13:15:02 -0800
Message-ID: <a5f991c8-3f74-6000-cbd3-09fb8626e3f5@oracle.com>
References: <20191030013701.39647-1-almasrymina@google.com>
 <20191030013701.39647-5-almasrymina@google.com>
 <1c060bde-8d44-146c-6d67-a7b145aa1b59@oracle.com>
 <CAHS8izPTvybLq9Y9Fn6Z+hSc7gLP+goQ-ixzjxa1XJ-qhWM8ow@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Gx9KwExmMMzjVr3YxjcHGknRiK3FRatTEn7SFiCRVlo=;
 b=TM2hXBvBRL2mJ1WqhIcE9gohEfsiVsssaD0IqYV6WNyJ//+yc3LZsjXkHjiiPkAbPufX
 xtm39fbNG4ySxAmUEteThrRIB5XoxGNWIZg4r274Wr4jzdIMDIE69cMPcLjAmEbIvv9b
 j27Jok6QfXHPRZ5nwnTentwZ3wie8PDuU68+7NpHywDIDHd7oyKhB5SU1Xc7aY9G+OAf
 6pQX3kcMb4mWfmwU5zbzYm62juOPyGqzJS9gS5pQC9EluewTF0HY/w8T4d9RTzJc7TsL
 gneOdJzwwKICikiPjEOoRwBcyqWKt+uXwpeyxRZyo0bpE9UbuH5cPOu8YS7yc8uqRIEx Gg== 
In-Reply-To: <CAHS8izPTvybLq9Y9Fn6Z+hSc7gLP+goQ-ixzjxa1XJ-qhWM8ow@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina@google.com>
Cc: shuah <shuah@kernel.org>, open list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>

On 11/4/19 1:04 PM, Mina Almasry wrote:
> On Fri, Nov 1, 2019 at 4:23 PM Mike Kravetz <mike.kravetz@oracle.com> wrote:
>>
>> On 10/29/19 6:36 PM, Mina Almasry wrote:
>>>  static long add_reservation_in_range(struct resv_map *resv, long f, long t,
>>> -                                  bool count_only)
>>> +                                  long *regions_needed, bool count_only)
>>>  {
>>> -     long chg = 0;
>>> +     long add = 0;
>>>       struct list_head *head = &resv->regions;
>>> +     long last_accounted_offset = f;
>>>       struct file_region *rg = NULL, *trg = NULL, *nrg = NULL;
>>>
>>> -     /* Locate the region we are before or in. */
>>> -     list_for_each_entry (rg, head, link)
>>> -             if (f <= rg->to)
>>> -                     break;
>>> +     if (regions_needed)
>>> +             *regions_needed = 0;
>>>
>>> -     /* Round our left edge to the current segment if it encloses us. */
>>> -     if (f > rg->from)
>>> -             f = rg->from;
>>> -
>>> -     chg = t - f;
>>> +     /* In this loop, we essentially handle an entry for the range
>>> +      * [last_accounted_offset, rg->from), at every iteration, with some
>>> +      * bounds checking.
>>> +      */
>>> +     list_for_each_entry_safe(rg, trg, head, link) {
>>> +             /* Skip irrelevant regions that start before our range. */
>>> +             if (rg->from < f) {
>>> +                     /* If this region ends after the last accounted offset,
>>> +                      * then we need to update last_accounted_offset.
>>> +                      */
>>> +                     if (rg->to > last_accounted_offset)
>>> +                             last_accounted_offset = rg->to;
>>> +                     continue;
>>> +             }
>>>
>>> -     /* Check for and consume any regions we now overlap with. */
>>> -     nrg = rg;
>>> -     list_for_each_entry_safe (rg, trg, rg->link.prev, link) {
>>> -             if (&rg->link == head)
>>> -                     break;
>>> +             /* When we find a region that starts beyond our range, we've
>>> +              * finished.
>>> +              */
>>>               if (rg->from > t)
>>>                       break;
>>>
>>> -             /* We overlap with this area, if it extends further than
>>> -              * us then we must extend ourselves.  Account for its
>>> -              * existing reservation.
>>> +             /* Add an entry for last_accounted_offset -> rg->from, and
>>> +              * update last_accounted_offset.
>>>                */
>>> -             if (rg->to > t) {
>>> -                     chg += rg->to - t;
>>> -                     t = rg->to;
>>> +             if (rg->from > last_accounted_offset) {
>>> +                     add += rg->from - last_accounted_offset;
>>> +                     if (!count_only) {
>>> +                             nrg = get_file_region_entry_from_cache(
>>> +                                     resv, last_accounted_offset, rg->from);
>>> +                             list_add(&nrg->link, rg->link.prev);
>>> +                     } else if (regions_needed)
>>> +                             *regions_needed += 1;
>>>               }
>>> -             chg -= rg->to - rg->from;
>>>
>>> -             if (!count_only && rg != nrg) {
>>> -                     list_del(&rg->link);
>>> -                     kfree(rg);
>>> -             }
>>> +             last_accounted_offset = rg->to;
>>
>> That last assignment is unneeded.  Correct?
>>
> 
> Not to make you nervous, but this assignment is needed.
> 
> The basic idea is that there are 2 loop invariants here:
> 1. Everything before last_accounted_offset is filled in with file_regions.
> 2. rg points to the first region past last_account_offset.
> 
> Each loop iteration compares rg->from to last_accounted_offset, and if
> there is a gap, it creates a new region to fill this gap. Then this
> assignment restores loop invariant #2 by assigning
> last_accounted_offset to rg->to, since now everything before rg->to is
> filled in with file_regions.
> 

My apologies!

>>>       }
>>>
>>> -     if (!count_only) {
>>> -             nrg->from = f;
>>> -             nrg->to = t;
>>> +     /* Handle the case where our range extends beyond
>>> +      * last_accounted_offset.
>>> +      */
>>> +     if (last_accounted_offset < t) {
>>> +             add += t - last_accounted_offset;
>>> +             if (!count_only) {
>>> +                     nrg = get_file_region_entry_from_cache(
>>> +                             resv, last_accounted_offset, t);
>>> +                     list_add(&nrg->link, rg->link.prev);
>>> +             } else if (regions_needed)
>>> +                     *regions_needed += 1;
>>> +             last_accounted_offset = t;

The question about an unnecessary assignment was supposed to be
directed at the above line.

-- 
Mike Kravetz


>>>       }
>>>
>>> -     return chg;
>>> +     return add;
>>>  }
