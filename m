From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH RFC] mm/memcontrol: reclaim severe usage over high limit
 in get_user_pages loop
Date: Tue, 6 Aug 2019 10:19:49 +0300
Message-ID: <c6b2c864-985a-2565-95e7-3af9e3e015f8@yandex-team.ru>
References: <156431697805.3170.6377599347542228221.stgit@buzz>
 <20190729154952.GC21958@cmpxchg.org> <20190729185509.GI9330@dhcp22.suse.cz>
 <20190802094028.GG6461@dhcp22.suse.cz>
 <105a2f1f-de5c-7bac-3aa5-87bd1dbcaed9@yandex-team.ru>
 <20190802114438.GH6461@dhcp22.suse.cz>
 <20190806070728.GB11812@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1565075992; bh=N6mFKzcJuhbgMksEZaXjMK9Sa+aXVEkZHt/RWDgwRic=;
        h=In-Reply-To:Message-ID:From:Date:References:To:Subject:Cc;
        b=qj1+3eKYycJsRWYRyESXh/le9T+uXhFB29JZh8tHuGVXVY4TzJH31MfvV4dDd3p3D
         5j+amf4w55mGNYaE/HxSlnsaBt7smrFwVUAi4JQnakvs/XAP5VyloJFo3MqiiLQ9zS
         ItceemZk1AVrWepJltjbLkwA8naBgpG1rtuSRmSk=
In-Reply-To: <20190806070728.GB11812@dhcp22.suse.cz>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Vladimir Davydov <vdavydov.dev@gmail.com>

On 8/6/19 10:07 AM, Michal Hocko wrote:
> On Fri 02-08-19 13:44:38, Michal Hocko wrote:
> [...]
>>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>>> index ba9138a4a1de..53a35c526e43 100644
>>>> --- a/mm/memcontrol.c
>>>> +++ b/mm/memcontrol.c
>>>> @@ -2429,8 +2429,12 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
>>>>    				schedule_work(&memcg->high_work);
>>>>    				break;
>>>>    			}
>>>> -			current->memcg_nr_pages_over_high += batch;
>>>> -			set_notify_resume(current);
>>>> +			if (gfpflags_allow_blocking(gfp_mask)) {
>>>> +				reclaim_high(memcg, nr_pages, GFP_KERNEL);
>>
>> ups, this should be s@GFP_KERNEL@gfp_mask@
>>
>>>> +			} else {
>>>> +				current->memcg_nr_pages_over_high += batch;
>>>> +				set_notify_resume(current);
>>>> +			}
>>>>    			break;
>>>>    		}
>>>>    	} while ((memcg = parent_mem_cgroup(memcg)));
>>>>
> 
> Should I send an official patch for this?
> 

I prefer to keep it as is while we have no better solution.
