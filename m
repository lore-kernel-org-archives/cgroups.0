From: Alexander Fedorov <halcien-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Possible race in obj_stock_flush_required() vs drain_obj_stock()
Date: Mon, 3 Oct 2022 18:01:35 +0300
Message-ID: <2f9bdffd-062e-a364-90c4-da7f09c95619@gmail.com>
References: <1664546131660.1777662787.1655319815@gmail.com>
 <Yzc0yZwDB8GG+4t7@P9FQF9L96D.corp.robot.car>
 <b91e75f4-b09c-85aa-c6ad-2364dab9af92@gmail.com>
 <Yzm5cukBe6IfyAs7@P9FQF9L96D.lan>
 <d3cf9c69-19a1-53f9-cf97-5d40ce5cda44@gmail.com>
 <YzrkaKZKYqx+c325@dhcp22.suse.cz>
 <821923d8-17c3-f1c2-4d6a-5653c88db3e8@gmail.com>
 <YzrxNGpf7sSwSWy2@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=9rAQZSDFLx6oyudqXJUAKh8EPFf5CZriEW2Q/puz7cw=;
        b=R8sv2LFCszyDp3XyJnq6sBvDNnGkSMQYnrP0Lc3g+w4Yp8MnStv2rONOs0pMHKHcfd
         b1HwUh/xsuxD6nwHgRLiKUWcF23LKLGO3t3trUjyZC1CnwmHORgYdieP+o8PO5wklJjZ
         gvvs6uXlyJ2PsOJYOa/Xi3YiaNhGR2lFYaOqLZ6MZ1/sHkr/mKvS76+s1GvLAKF6leys
         CryJL6jxaaUc1b8uatBJ/TDxAMK7CvHL5sBQYWQWhzPYNOEcuOeosg+tj3FWXixEaYbK
         6feHOwigK9z4PuRHCKdXAFlm5jhOu7kw/YrGgQumu4diYCXnfDawjwmf7Yv730voEpEL
         znWA==
In-Reply-To: <YzrxNGpf7sSwSWy2-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 03.10.2022 17:27, Michal Hocko wrote:
> On Mon 03-10-22 17:09:15, Alexander Fedorov wrote:
>> On 03.10.2022 16:32, Michal Hocko wrote:
>>> On Mon 03-10-22 15:47:10, Alexander Fedorov wrote:
>>>> @@ -3197,17 +3197,30 @@ static void drain_obj_stock(struct memcg_stock_pcp *stock)
>>>>  		stock->nr_bytes = 0;
>>>>  	}
>>>>  
>>>> -	obj_cgroup_put(old);
>>>> +	/*
>>>> +	 * Clear pointer before freeing memory so that
>>>> +	 * drain_all_stock() -> obj_stock_flush_required()
>>>> +	 * does not see a freed pointer.
>>>> +	 */
>>>>  	stock->cached_objcg = NULL;
>>>> +	obj_cgroup_put(old);
>>>
>>> Do we need barrier() or something else to ensure there is no reordering?
>>> I am not reallyu sure what kind of barriers are implied by the pcp ref
>>> counting.
>>
>> obj_cgroup_put() -> kfree_rcu() -> synchronize_rcu() should take care
>> of this:
> 
> This is a very subtle guarantee. Also it would only apply if this is the
> last reference, right?

Hmm, yes, for the last reference only, also not sure about pcp ref
counter ordering rules for previous references.

> Is there any reason to not use
> 	WRITE_ONCE(stock->cached_objcg, NULL);
> 	obj_cgroup_put(old);
> 
> IIRC this should prevent any reordering. 

Now that I think about it we actually must use WRITE_ONCE everywhere
when writing cached_objcg because otherwise compiler might split the
pointer-sized store into several smaller-sized ones (store tearing),
and obj_stock_flush_required() would read garbage instead of pointer.

And thinking about memory barriers, maybe we need them too alongside
WRITE_ONCE when setting pointer to non-null value?  Otherwise
drain_all_stock() -> obj_stock_flush_required() might read old data.
Since that's exactly what rcu_assign_pointer() does, it seems
that we are going back to using rcu_*() primitives everywhere?
