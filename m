From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: =?UTF-8?B?UmU6IOetlOWkjTog562U5aSNOiBbUEFUQ0hdIG1tL21lbWNvbnRyb2wu?=
 =?UTF-8?Q?c:_speed_up_to_force_empty_a_memory_cgroup?=
Date: Wed, 21 Mar 2018 01:35:05 +0300
Message-ID: <e265c518-968b-8669-ad22-671c781ad96e@virtuozzo.com>
References: <1521448170-19482-1-git-send-email-lirongqing@baidu.com>
 <20180319085355.GQ23100@dhcp22.suse.cz>
 <2AD939572F25A448A3AE3CAEA61328C23745764B@BC-MAIL-M28.internal.baidu.com>
 <20180319103756.GV23100@dhcp22.suse.cz>
 <2AD939572F25A448A3AE3CAEA61328C2374589DC@BC-MAIL-M28.internal.baidu.com>
 <alpine.DEB.2.20.1803191044310.177918@chino.kir.corp.google.com>
 <20180320083950.GD23100@dhcp22.suse.cz>
 <alpine.DEB.2.20.1803201327060.167205@chino.kir.corp.google.com>
 <56508bd0-e8d7-55fd-5109-c8dacf26b13e@virtuozzo.com>
 <alpine.DEB.2.20.1803201514340.14003@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=gamGeXGyujYd0AOpLGqaHQ1E9FW0z4w9y7Nx2ygDzUY=;
 b=J2Xtoh5/RWmMTwhf2DeNuh404Adu9FIzqqtxI535dyqTNGCieHDhCuQYJSl+yfK/fiIH1eFgKpu0CFFuNEXMTXigLEKapN5chva3jK6lnMVcV12wTIPa/ffIS83KD95fwb/FQ9NQkyy0EnXFeHI50nsF54ERGMHbxhzhzael6aI=
In-Reply-To: <alpine.DEB.2.20.1803201514340.14003@chino.kir.corp.google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@kernel.org>, "Li,Rongqing" <lirongqing@baidu.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>

On 03/21/2018 01:15 AM, David Rientjes wrote:
> On Wed, 21 Mar 2018, Andrey Ryabinin wrote:
> 
>>>>> It would probably be best to limit the 
>>>>> nr_pages to the amount that needs to be reclaimed, though, rather than 
>>>>> over reclaiming.
>>>>
>>>> How do you achieve that? The charging path is not synchornized with the
>>>> shrinking one at all.
>>>>
>>>
>>> The point is to get a better guess at how many pages, up to 
>>> SWAP_CLUSTER_MAX, that need to be reclaimed instead of 1.
>>>
>>>>> If you wanted to be invasive, you could change page_counter_limit() to 
>>>>> return the count - limit, fix up the callers that look for -EBUSY, and 
>>>>> then use max(val, SWAP_CLUSTER_MAX) as your nr_pages.
>>>>
>>>> I am not sure I understand
>>>>
>>>
>>> Have page_counter_limit() return the number of pages over limit, i.e. 
>>> count - limit, since it compares the two anyway.  Fix up existing callers 
>>> and then clamp that value to SWAP_CLUSTER_MAX in 
>>> mem_cgroup_resize_limit().  It's a more accurate guess than either 1 or 
>>> 1024.
>>>
>>
>> JFYI, it's never 1, it's always SWAP_CLUSTER_MAX.
>> See try_to_free_mem_cgroup_pages():
>> ....	
>> 	struct scan_control sc = {
>> 		.nr_to_reclaim = max(nr_pages, SWAP_CLUSTER_MAX),
>>
> 
> Is SWAP_CLUSTER_MAX the best answer if I'm lowering the limit by 1GB?
> 

Absolutely not. I completely on your side here. 
I've tried to fix this recently - http://lkml.kernel.org/r/20180119132544.19569-2-aryabinin@virtuozzo.com
I guess that Andrew decided to not take my patch, because Michal wasn't
happy about it (see mail archives if you want more details).

