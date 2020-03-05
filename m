From: Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: Re: [PATCH] mm: Make mem_cgroup_id_get_many dependent on MMU and
 MEMCG_SWAP
Date: Thu, 5 Mar 2020 10:46:21 +0000
Message-ID: <acf13158-40a3-4027-f36a-25d24efe3242@arm.com>
References: <20200304142348.48167-1-vincenzo.frascino@arm.com>
 <20200304165336.GO16139@dhcp22.suse.cz>
 <8c489836-b824-184e-7cfe-25e55ab73000@arm.com>
 <20200305100023.GR16139@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200305100023.GR16139@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko@kernel.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>

Hi Michal,

On 3/5/20 10:00 AM, Michal Hocko wrote:
> On Thu 05-03-20 09:49:23, Vincenzo Frascino wrote:
>> Hi Michal,
>>
>> On 3/4/20 4:53 PM, Michal Hocko wrote:
>>> On Wed 04-03-20 14:23:48, Vincenzo Frascino wrote:
>>>> mem_cgroup_id_get_many() is currently used only when MMU or MEMCG_SWAP
>>>> configuration options are enabled. Having them disabled triggers the
>>>> following warning at compile time:
>>>>
>>>> linux/mm/memcontrol.c:4797:13: warning: ‘mem_cgroup_id_get_many’ defined
>>>> but not used [-Wunused-function]
>>>>  static void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned
>>>>  int n)
>>>>
>>>> Make mem_cgroup_id_get_many() dependent on MMU and MEMCG_SWAP to address
>>>> the issue.
>>>
>>> A similar patch has been proposed recently
>>> http://lkml.kernel.org/r/87fthjh2ib.wl-kuninori.morimoto.gx@renesas.com.
>>> The conclusion was that the warning is not really worth adding code.
>>>
>>
>> Thank you for pointing this out, I was not aware of it. I understand that you
>> are against "#ifdeffery" in this case, but isn't it the case of adding at least
>> __maybe_unused? This would prevent people from reporting it over and over again
>> and you to have to push them back :) Let me know what do you think, in case I am
>> happy to change my patch accordingly.
> 
> We have discussed __maybe_unused in the email thread as well. I am not a
> great fan of that as mentioed there.
> 

I am aware of this. I was just exploring if there was a possibility of
addressing the warning, since if we leave all the warnings in scenarios like
randconfig can cause confusion in between real and non real issues.
Is there anything we can do?

-- 
Regards,
Vincenzo
