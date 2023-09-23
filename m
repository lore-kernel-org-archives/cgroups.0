From: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] memcg, oom: unmark under_oom after the oom killer is
 done
Date: Sat, 23 Sep 2023 16:05:40 +0800
Message-ID: <94eea77c-2786-794e-ac2b-71a48966b5db@shopee.com>
References: <20230922070529.362202-1-haifeng.xu@shopee.com>
 <ZQ4giCbTqUpmKWAa@P9FQF9L96D.corp.robot.car>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1695456345; x=1696061145; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xRuWP6V8GVdoPyHzIkm8uWRv8cNgAdi6Pry1OPgErIE=;
        b=Rx6ILTNU+v8MPpL/ylURc6kK4vqs5NAroOseeaVM55fvhkUn+qHxyD7uzTFnq3Q7SV
         sJPrj8RK33Adug1bQRRVo7F6+phLGV4BKjyTv8ycgfDkVwchVOlNK/FtkYnrZFO2NzyG
         Lztl7cOm93z1FhA2Ajt3++0dCWWBgY0tTW/2SKeEI2rDTLsaJBmSorBBOg+lmhQp3HLO
         lCph7XJZrgYDiy6Mi2/5s5QlDBAbsd+8UHpCUJTSLBsftwd3X9HpbyvxiOo0P8ELcTZ+
         8FSsZzaJwver0OnaM7gpPTdXJ++1KLxpCceU0Kc4mbXsPLGud0OAS36Ix5fL+STjXj5l
         +hKQ==
In-Reply-To: <ZQ4giCbTqUpmKWAa-+xijCwNIfdoLQcUKs7qKB+WAnPUfkyWGUBSOeVevoDU@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org



On 2023/9/23 07:17, Roman Gushchin wrote:
> On Fri, Sep 22, 2023 at 07:05:28AM +0000, Haifeng Xu wrote:
>> When application in userland receives oom notification from kernel
>> and reads the oom_control file, it's confusing that under_oom is 0
>> though the omm killer hasn't finished. The reason is that under_oom
>> is cleared before invoking mem_cgroup_out_of_memory(), so move the
>> action that unmark under_oom after completing oom handling. Therefore,
>> the value of under_oom won't mislead users.
>>
>> Signed-off-by: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
> 
> Makes sense to me.
> 
> Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> 
> Thanks!

OK,thanks. But I forgot to cc mailing list and akpm. I'll resend a new mail later.

> 
>> ---
>>  mm/memcontrol.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index e8ca4bdcb03c..0b6ed63504ca 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -1970,8 +1970,8 @@ static bool mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int order)
>>  	if (locked)
>>  		mem_cgroup_oom_notify(memcg);
>>  
>> -	mem_cgroup_unmark_under_oom(memcg);
>>  	ret = mem_cgroup_out_of_memory(memcg, mask, order);
>> +	mem_cgroup_unmark_under_oom(memcg);
>>  
>>  	if (locked)
>>  		mem_cgroup_oom_unlock(memcg);
>> -- 
>> 2.25.1
>>
