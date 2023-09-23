From: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] memcg, oom: do not wake up memcg_oom_waitq if
 waitqueue is empty
Date: Sat, 23 Sep 2023 16:01:15 +0800
Message-ID: <94c2a462-1d4e-e6e8-0e31-babcbc459836@shopee.com>
References: <20230922070529.362202-2-haifeng.xu@shopee.com>
 <ZQ4hsQRp31RXMOfv@P9FQF9L96D.corp.robot.car>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1695456080; x=1696060880; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=//ZPpaDq66gMwAPM04xisJ28uaG0yhnKLXXS/is+y1c=;
        b=d2TsDG5jUx+RkDgIAOo4rjzQUbdR6b9IhOuBugAmWOs2Nj+4sOIy4oMvSaGuag5zBj
         rFAYOCy+ZWksOcVNvBvkRVWsgYzuPMWzcRwaHjW+Z6WyiyJWkMsQrqWObJ5PnaVM07L7
         IeocHcaGLBmk5q3EpXA4zvuh9UHs42C51FuIbb3haushQ22iiIXVWq+zW4IZs/NgzB4L
         Z6E+4avGJiKW+ujLIRUlsWLU2p9dsewsBTmPiBMNffBqPf1V/H1oZhcGJslvashx8Ign
         dxhixuZd/Z5CY7ccjziqLWhBPIHw1xcy/FbkxcH4Cb0vpaqemuhazhiI8ejxcAZ5lJlw
         fzfQ==
In-Reply-To: <ZQ4hsQRp31RXMOfv-+xijCwNIfdoLQcUKs7qKB+WAnPUfkyWGUBSOeVevoDU@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org



On 2023/9/23 07:22, Roman Gushchin wrote:
> On Fri, Sep 22, 2023 at 07:05:29AM +0000, Haifeng Xu wrote:
>> Only when memcg oom killer is disabled, the task which triggers memecg
>> oom handling will sleep on a waitqueue. Except this case, the waitqueue
>> is empty though under_oom is true. There is no need to step into wake
>> up path when resolve the oom situation. So add a check that whether the
>> waitqueue is empty.
>>
>> Signed-off-by: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
>> ---
>>  mm/memcontrol.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 0b6ed63504ca..2bb98ff5be3d 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -1918,7 +1918,7 @@ static void memcg_oom_recover(struct mem_cgroup *memcg)
>>  	 * achieved by invoking mem_cgroup_mark_under_oom() before
>>  	 * triggering notification.
>>  	 */
>> -	if (memcg && memcg->under_oom)
>> +	if (memcg && memcg->under_oom && !list_empty(&memcg_oom_waitq.head))
>>  		__wake_up(&memcg_oom_waitq, TASK_NORMAL, 0, memcg);
> 
> This change looks questionable to me:
> 1) it's not obvious that this racy check is fine. can an oom event be
>    missed because of a race here? why not?

The oom event can't be missed, because the OOM task has been put on the waitqueue before marking the hierarchy as
under OOM(can be seen in mem_cgroup_oom_synchronize()).

> 2) is there any measurable impact?

No. 

it's not a hot path, so I'd keep it
>    simple.

ok, thanks.

> 
> Thanks!
