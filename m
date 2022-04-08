From: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH resend] memcg: introduce per-memcg reclaim interface
Date: Fri, 08 Apr 2022 11:08:28 +0800
Message-ID: <87y20gtgpf.fsf@yhuang6-desk2.ccr.corp.intel.com>
References: <20220331084151.2600229-1-yosryahmed@google.com>
        <YkcEMdsi9G5y8mX4@dhcp22.suse.cz>
        <CAAPL-u_i-Mp-Bo7LtP_4aJscY=1JHG_y1H_-A7N_HRAgtz+arg@mail.gmail.com>
        <87y20nzyw4.fsf@yhuang6-desk2.ccr.corp.intel.com>
        <CAAPL-u8wjtBRE7KZyZjoQ0eTJecnW35uEXAE3KU0M+AvL=5-ug@mail.gmail.com>
        <87o81fujdc.fsf@yhuang6-desk2.ccr.corp.intel.com>
        <CAAPL-u_6XqQYtLAMNFvEo+0XU2VR=XYm0T9btL=g6rVVW2h93w@mail.gmail.com>
        <87bkxfudrk.fsf@yhuang6-desk2.ccr.corp.intel.com>
        <215bd7332aee0ed1092bad4d826a42854ebfd04a.camel@linux.intel.com>
        <CAAPL-u_aAbDOmATSA8ZvjnfBk_7EoXvLoh0etM0fB0aY1845VQ@mail.gmail.com>
        <df6110a09cacc80ee1cbe905a71273a5f3953e16.camel@linux.intel.com>
        <CAAPL-u-oF5HQ26w1czNCmA5VadXOfC54GbGpSppva86YEkefyA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649387315; x=1680923315;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=mip+/VJYm0x9QxlXtQ8hn3QtLV04GsE06YGBmuPIRI4=;
  b=HL0IFoDeS9iaslDDdNpKjMpVdK5dVbPpV4hZ+O7IEV8Ncscsp7SnE6mD
   fpFXfnQKKML4CK+/ZO19AR75HEhb01D9+Em+GR05AF6fkSIYB2avinusx
   IJxe51a5uGcTN/SGbMSFjiiqO3GbsBGhUJPXH19+gffw0W+/1IxqhUG/p
   09rXXdOt8TJTcik9dqa8SY5mBdltWKg4yh8timcgiaOv471w/WWzo6G6R
   mJL46Nl6AXGa43A7SO72n0qIA9KNrJi1K/zTchEFcpCML/Ney/CZHO9SV
   0yYScdOHq8j5wWnw5irpYjEF+Cxfp0q6nqOwxXOS9eFSTkLkWBEi0Xk5K
   A==;
In-Reply-To: <CAAPL-u-oF5HQ26w1czNCmA5VadXOfC54GbGpSppva86YEkefyA@mail.gmail.com>
        (Wei Xu's message of "Thu, 7 Apr 2022 19:10:20 -0700")
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Xu <weixugc@google.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Michal Hocko <mhocko@suse.com>, Yosry Ahmed <yosryahmed@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Roman Gushchin <roman.gushchin@linux.dev>, Cgroups <cgroups@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Jonathan Corbet <corbet@lwn.net>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Greg Thelen <gthelen@google.com>

Wei Xu <weixugc@google.com> writes:

> On Thu, Apr 7, 2022 at 4:11 PM Tim Chen <tim.c.chen@linux.intel.com> wrote:
>>
>> On Thu, 2022-04-07 at 15:12 -0700, Wei Xu wrote:
>>
>> >
>> > (resending in plain-text, sorry).
>> >
>> > memory.demote can work with any level of memory tiers if a nodemask
>> > argument (or a tier argument if there is a more-explicitly defined,
>> > userspace visible tiering representation) is provided.  The semantics
>> > can be to demote X bytes from these nodes to their next tier.
>> >
>>
>> We do need some kind of userspace visible tiering representation.
>> Will be nice if I can tell the memory type, nodemask of nodes in tier Y with
>>
>> cat memory.tier_Y
>>
>>
>> > memory_dram/memory_pmem assumes the hardware for a particular memory
>> > tier, which is undesirable.  For example, it is entirely possible that
>> > a slow memory tier is implemented by a lower-cost/lower-performance
>> > DDR device connected via CXL.mem, not by PMEM.  It is better for this
>> > interface to speak in either the NUMA node abstraction or a new tier
>> > abstraction.
>>
>> Just from the perspective of memory.reclaim and memory.demote, I think
>> they could work with nodemask.  For ease of management,
>> some kind of abstraction of tier information like nodemask, memory type
>> and expected performance should be readily accessible by user space.
>>
>
> I agree.  The tier information should be provided at the system level.
> One suggestion is to have a new directory "/sys/devices/system/tier/"
> for tiers, e.g.:
>
> /sys/devices/system/tier/tier0/memlist: all memory nodes in tier 0.
> /sys/devices/system/tier/tier1/memlist: all memory nodes in tier 1.

I think that it may be sufficient to make tier an attribute of "node".
Some thing like,

/sys/devices/system/node/nodeX/memory_tier

Best Regards,
Huang, Ying

> We can discuss this tier representation in a new thread.
>
>> Tim
>>
>> >
>> > It is also desirable to make this interface stateless, i.e. not to
>> > require the setting of memory_dram.reclaim_policy.  Any policy can be
>> > specified as arguments to the request itself and should only affect
>> > that particular request.
>> >
>> > Wei
>>
