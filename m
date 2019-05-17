From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] memcg: make it work on sparse non-0-node systems
Date: Fri, 17 May 2019 10:16:23 +0200
Message-ID: <2c3fab03-99fb-9313-140b-04a245065dd7@suse.cz>
References: <359d98e6-044a-7686-8522-bdd2489e9456@suse.cz>
 <20190429105939.11962-1-jslaby@suse.cz>
 <20190509122526.ck25wscwanooxa3t@esperanza>
 <20190516135923.GV16651@dhcp22.suse.cz>
 <68075828-8fd7-adbb-c1d9-5eb39fbf18cb@suse.cz>
 <20190517080044.tnwhbeyxcccsymgf@esperanza>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190517080044.tnwhbeyxcccsymgf@esperanza>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

On 17. 05. 19, 10:00, Vladimir Davydov wrote:
> On Fri, May 17, 2019 at 06:48:37AM +0200, Jiri Slaby wrote:
>> On 16. 05. 19, 15:59, Michal Hocko wrote:
>>>> However, I tend to agree with Michal that (ab)using node[0].memcg_lrus
>>>> to check if a list_lru is memcg aware looks confusing. I guess we could
>>>> simply add a bool flag to list_lru instead. Something like this, may be:
>>>
>>> Yes, this makes much more sense to me!
>>
>> I am not sure if I should send a patch with this solution or Vladimir
>> will (given he is an author and has a diff already)?
> 
> I didn't even try to compile it, let alone test it. I'd appreciate if
> you could wrap it up and send it out using your authorship. Feel free
> to add my acked-by.

OK, NP.

thanks,
-- 
js
suse labs
