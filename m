From: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 3/4] memcg: optimize memcg_get_hierarchical_limit
Date: Mon, 25 Jun 2012 18:43:57 +0800
Message-ID: <20120625104357.GB12148@kernel>
References: <1340613872-9581-1-git-send-email-liwp.linux@gmail.com>
 <4FE834D9.8070903@jp.fujitsu.com>
Reply-To: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=NiAHCZSvcJ5wAgNOVGBeRptphGpJ2j/QMYJKvL189CE=;
        b=wFhCqV3rF1APio/TJkYMFzv8pa2vlaOaEUd0hcUlM75k6E/ntOCRie97Tdw9vQdmBS
         W+i4FiK4cP2GWRsKdlL6pC5w+M/8jjtXMNEDXKnKHm7xxg754IwRkqrl9PobpvlvgJMt
         VVL41AQN1Ug6Rxr5dFAJlktAZvtBvxM69aIPUqmej207onWTgBts9OKYyQjiW+p9kJxJ
         Izic3ZpW4ppA5ByvKa7AKe6+mrzz1Qe9254qALlndljEqWaoj1G91B78zRvcOFnxN7OD
         IkPV9i+CZe6kJ6u6Q1kBjGymJ/rLPDMA4TNX9ITnldHYQEOAjSw38WFQboXXZy7CO5jX
         TzIg==
Content-Disposition: inline
In-Reply-To: <4FE834D9.8070903-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Arun Sharma <asharma-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Mon, Jun 25, 2012 at 06:52:25PM +0900, Kamezawa Hiroyuki wrote:
>(2012/06/25 17:44), Wanpeng Li wrote:
>> From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> 
>> Optimize memcg_get_hierarchical_limit to save cpu cycle.
>> 
>> Signed-off-by: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>I can't understand the benefit of this patch to the real world...
>
>So, if you wrote the patch description as "clean up" rather than optimize,
>ok, I'll agree.
OK, I will change to "Cleanup". Thank you Kame.

Best Regards,
Wanpeng Li

>
>Thanks,
>-Kame
>
>> ---
>>   mm/memcontrol.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 2e81328..4520b57 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -3917,9 +3917,9 @@ static void memcg_get_hierarchical_limit(struct mem_cgroup *memcg,
>>   
>>   	min_limit = res_counter_read_u64(&memcg->res, RES_LIMIT);
>>   	min_memsw_limit = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
>> -	cgroup = memcg->css.cgroup;
>>   	if (!memcg->use_hierarchy)
>>   		goto out;
>> +	cgroup = memcg->css.cgroup;
>>   
>>   	while (cgroup->parent) {
>>   		cgroup = cgroup->parent;
>> 
>
>
>
