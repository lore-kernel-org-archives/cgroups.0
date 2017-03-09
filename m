From: Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH -mm -v6 2/9] mm, memcg: Support to charge/uncharge
 multiple swap entries
Date: Fri, 10 Mar 2017 08:22:28 +1100
Message-ID: <CAKTCnzneq1JZnSQnxNBJCxJEfk65N8GPL=K6T8Lg44t7hjtV1A@mail.gmail.com>
References: <20170308072613.17634-1-ying.huang@intel.com> <20170308072613.17634-3-ying.huang@intel.com>
 <1488973076.13674.5.camel@gmail.com> <87o9xbi6gb.fsf@yhuang-dev.intel.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=x8bz7cb0hBvxN0xJHFvyZomKWrUTsCumna0Y7sdaNDI=;
        b=iFnSWmNjezr4ggxQ/fw5DFPJc8msrmCnF2YbwKsmq2155iNSxDp5HS09v5JcccUYY5
         RIv/ImV57eAvJtwZHaejhUcr6hH8jAHMKF2FUOnYCeLSzBLDwaunLUOYQdsH8PUpyTrL
         mlqnGOQVsWiOpSs/eEL6vsphy9yHIAQmPcdezD9TOeimXdaI+iMnIU8wVwputDUBxGM6
         ARZpWru6BRGvF0FbHLqcoGsE0+V2gdpKO/dM6kA/Kuk47eTM70nFN11fNou44ImMc04Q
         R3i7hB2NLjJneLcpeZVEvCggHM0i+IUjBWIns9qSJYmy52xZoym2aApeoBJwwXTS9Fc+
         +QyA==
In-Reply-To: <87o9xbi6gb.fsf@yhuang-dev.intel.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Vladimir Davydov <vdavydov@virtuozzo.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>

On Thu, Mar 9, 2017 at 12:28 PM, Huang, Ying <ying.huang@intel.com> wrote:
> Balbir Singh <bsingharora@gmail.com> writes:
>
>> On Wed, 2017-03-08 at 15:26 +0800, Huang, Ying wrote:
>>> From: Huang Ying <ying.huang@intel.com>
>>>
>>> This patch make it possible to charge or uncharge a set of continuous
>>> swap entries in the swap cgroup.  The number of swap entries is
>>> specified via an added parameter.
>>>
>>> This will be used for the THP (Transparent Huge Page) swap support.
>>> Where a swap cluster backing a THP may be allocated and freed as a
>>> whole.  So a set of (HPAGE_PMD_NR) continuous swap entries backing one
>>> THP need to be charged or uncharged together.  This will batch the
>>> cgroup operations for the THP swap too.
>>
>> A quick look at the patches makes it look sane. I wonder if we would
>> make sense to track THP swapout separately as well
>> (from a memory.stat perspective)
>
> The patchset is just the first step of THP swap optimization.  So the
> THP will still be split after putting the THP into the swap cache.  This
> makes it unnecessary to change mem_cgroup_swapout().  I am working on a
> following up patchset to further delaying THP splitting after swapping
> out the THP to the disk.  In that patchset, I will change
> mem_cgroup_swapout() too.


Fair enough

Thanks,
Balbir

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
