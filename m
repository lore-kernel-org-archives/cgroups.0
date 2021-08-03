From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: Set the correct memcg swappiness
 restriction
Date: Tue, 3 Aug 2021 17:20:40 +0200
Message-ID: <6e6570d2-44a2-1da1-6c2a-38766786c40c@suse.cz>
References: <d77469b90c45c49953ccbc51e54a1d465bc18f70.1627626255.git.baolin.wang@linux.alibaba.com>
 <YQOekWWgtZUfim4M@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1628004041; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ersUyOxiWFVo1kZan9calBKiFWyiEpXiBiaAlyP0RUk=;
        b=QQKupwhLEkgmEnJJYUoCR2y56AeRN1vJHq7a+JYfpBxspF6+tdBBHJ1PU/5vxtoYDVQb/h
        G22A9nYpesaAojCZwymzFeK+7epUmG6+jdfB5Bg6oOq3Pv5RTh0LlgHdlKBk5rc1sxYMEP
        s9KBxaft90NRdh31hjGXtYPcf02PCBU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1628004041;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ersUyOxiWFVo1kZan9calBKiFWyiEpXiBiaAlyP0RUk=;
        b=Q2d1r4HmCHf/1RhdxXRthGFYySUD/PbxzwbcLE2qK1ZXy8aeFFycQFy3r0HhgmpChEgwkP
        mjzibAym07HUe7Ag==
In-Reply-To: <YQOekWWgtZUfim4M-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 7/30/21 8:39 AM, Michal Hocko wrote:
> On Fri 30-07-21 14:26:35, Baolin Wang wrote:
>> Since commit c843966c556d ("mm: allow swappiness that prefers reclaiming
>> anon over the file workingset") has expended the swappiness value to
>> make swap to be preferred in some systems. We should also change the
>> memcg swappiness restriction to allow memcg swap-preferred.
>> 
>> Signed-off-by: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> 
> Yes, this looks like an omission. It doesn't really make sense to have
> two different constrains on the value.
> 
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

So, also Fixes: c843966c556d ("mm: allow swappiness that prefers reclaiming anon
over the file workingset")
?

> Thanks!
> 
>> ---
>>  mm/memcontrol.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 6580c23..988fc94 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -4046,7 +4046,7 @@ static int mem_cgroup_swappiness_write(struct cgroup_subsys_state *css,
>>  {
>>  	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
>>  
>> -	if (val > 100)
>> +	if (val > 200)
>>  		return -EINVAL;
>>  
>>  	if (!mem_cgroup_is_root(memcg))
>> -- 
>> 1.8.3.1
> 

