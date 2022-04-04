From: Vaibhav Jain <vaibhav@linux.ibm.com>
Subject: Re: [PATCH resend] memcg: introduce per-memcg reclaim interface
Date: Mon, 04 Apr 2022 09:20:16 +0530
Message-ID: <871qyd7bif.fsf@vajain21.in.ibm.com>
References: <20220331084151.2600229-1-yosryahmed@google.com>
 <874k3d6vuq.fsf@vajain21.in.ibm.com>
 <CAJD7tka1UstKYBVrie-_1CgvtaLtVD1uwgzfk5SifxW4FQbOVw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=9dfEKjiqJk7peBrMbPWk18ZVy+8Q9UvJWWfMRHUvo6k=;
 b=BmhSMTkV4aoD1xA4JdlOkFBk33G1s0UQNOSavGiLW4aOEhSuC4jwUg+FABcgc7aDxbru
 H99MrhYeN6HqwAnTKjoB1W/DYRIh+k21qapAByc6gB1Bh+IKiJakFbKrVvtKrZPsWUiT
 89KRrpPtO00R3pq0xYQHFUwaoo33d8Lw4J7BKawk1bHjIK/4915rerisvd5q2145wg2I
 9/8lkLGYhs1ntgmr0Rs48coRyVl+KGHaExQuQbfKR7nvvBNo1JhzWNvyvH7i1M8QtM5w
 S+U5wecnCelw0GhRnO26XBS1kwbZuL60JZcAKt1x6sL0bC/lifhVhPu/EN99gbmamj0D GA== 
In-Reply-To: <CAJD7tka1UstKYBVrie-_1CgvtaLtVD1uwgzfk5SifxW4FQbOVw@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Roman Gushchin <roman.gushchin@linux.dev>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Linux-MM <linux-mm@kvack.org>, Jonathan Corbet <corbet@lwn.net>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>


Apologies for the delayed response,

Yosry Ahmed <yosryahmed@google.com> writes:

> On Fri, Apr 1, 2022 at 1:39 AM Vaibhav Jain <vaibhav@linux.ibm.com> wrote:
>>
>>
>> Yosry Ahmed <yosryahmed@google.com> writes:
>> > From: Shakeel Butt <shakeelb@google.com>
>> >
>> > Introduce an memcg interface to trigger memory reclaim on a memory cgroup.
>> <snip>
>>
>> > +
>> > +     while (nr_reclaimed < nr_to_reclaim) {
>> > +             unsigned long reclaimed;
>> > +
>> > +             if (signal_pending(current))
>> > +                     break;
>> > +
>> > +             reclaimed = try_to_free_mem_cgroup_pages(memcg,
>> > +                                             nr_to_reclaim - nr_reclaimed,
>> > +                                             GFP_KERNEL, true);
>> > +
>> > +             if (!reclaimed && !nr_retries--)
>> > +                     break;
>> > +
>> > +             nr_reclaimed += reclaimed;
>>
>> I think there should be a cond_resched() in this loop before
>> try_to_free_mem_cgroup_pages() to have better chances of reclaim
>> succeding early.
>>
> Thanks for taking the time to look at this!
>
> I believe this loop is modeled after the loop in memory_high_write()
> for the memory.high interface. Is there a reason why it should be
> needed here but not there?
>

memory_high_write() calls drain_all_stock() atleast once before calling
try_to_free_mem_cgroup_pages(). This would drain all percpu stocks
for the given memcg and its descendents, giving a high chance
try_to_free_mem_cgroup_pages() to succeed quickly. Such a functionality
is missing from this patch.

Adding a cond_resched() would atleast give chance to other processess
within the memcg to run and make forward progress thereby making more
pages available for reclaim.

Suggestion is partly based on __perform_reclaim() issues a cond_resche()
as it may get called repeatedly during direct reclaim path.


>> <snip>
>>
>> --
>> Cheers
>> ~ Vaibhav
>

-- 
Cheers
~ Vaibhav
