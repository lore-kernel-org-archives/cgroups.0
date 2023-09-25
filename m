From: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] memcg, oom: unmark under_oom after the oom killer is
 done
Date: Mon, 25 Sep 2023 17:03:05 +0800
Message-ID: <6b7af68c-2cfb-b789-4239-204be7c8ad7e@shopee.com>
References: <20230922070529.362202-1-haifeng.xu@shopee.com>
 <ZRE9fAf1dId2U4cu@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1695632590; x=1696237390; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mqm4o8PPpVu6ukV6RI/eS1T+wtOMXG/bvIkWdbyHpRI=;
        b=FTvkBgjfHvoncZpkOX97gniJDTLG385fc+9N1R4RrPBtbPNYUab7gaWLl4PQ4jm0j9
         G4CxkKk3Nt0723qz4upJAn6bTBPXQzvmZoMxvTnTLLXWDOyfz0jgzb89RZOKujgdwF/5
         960fDCCB5F7Q56WsTM4ixue3LdnBnHNC7f2S9MowQBsMn2fYcwKJNWL/PIk56F6SF5v8
         0/jncluyM5NM/jNdWoMI9zPcAK0/k/H6IACyFX+Z8zLn4qmE9E7QIVktV0TXQ6ah/kFg
         7BOVkqqswH/X7R6KeUbQEkgKCt+waCKuGtRN1Lb5Iv69HLuu1GZDCNtdmhPB0PaocQyp
         e7LQ==
In-Reply-To: <ZRE9fAf1dId2U4cu-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org



On 2023/9/25 15:57, Michal Hocko wrote:
> On Fri 22-09-23 07:05:28, Haifeng Xu wrote:
>> When application in userland receives oom notification from kernel
>> and reads the oom_control file, it's confusing that under_oom is 0
>> though the omm killer hasn't finished. The reason is that under_oom
>> is cleared before invoking mem_cgroup_out_of_memory(), so move the
>> action that unmark under_oom after completing oom handling. Therefore,
>> the value of under_oom won't mislead users.
> 
> I do not really remember why are we doing it this way but trying to track
> this down shows that we have been doing that since fb2a6fc56be6 ("mm:
> memcg: rework and document OOM waiting and wakeup"). So this is an
> established behavior for 10 years now. Do we really need to change it
> now? The interface is legacy and hopefully no new workloads are
> emerging.
> 
> I agree that the placement is surprising but I would rather not change
> that unless there is a very good reason for that. Do you have any actual
> workload which depends on the ordering? And if yes, how do you deal with
> timing when the consumer of the notification just gets woken up after
> mem_cgroup_out_of_memory completes?

yes, when the oom event is triggered, we check the under_oom every 10 seconds. If it
is cleared, then we create a new process with less memory allocation to avoid oom again.

> 
>> Signed-off-by: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
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
> 
