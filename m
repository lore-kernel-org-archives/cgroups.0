From: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH 9/9] sched/psi: add PSI_IRQ to track IRQ/SOFTIRQ pressure
Date: Fri, 22 Jul 2022 15:33:14 +0800
Message-ID: <ab445d4d-70d2-9e6f-dd1d-9e71f00c1796@bytedance.com>
References: <20220721040439.2651-1-zhouchengming@bytedance.com>
 <20220721040439.2651-10-zhouchengming@bytedance.com>
 <65d9f79b-be9b-e21e-0624-5c9f2cc0c0b2@bytedance.com>
 <ce22fa9d-aad0-fc23-d304-14fdd27130f4@bytedance.com>
 <5e5d41e2-5f89-8c52-11e5-0c55c5595a88@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=aBbLSX1JockKc7+DXzMhzivNTlzRCnKzS9NOsdu1GjE=;
        b=FH5lfoYy5vxWwh++51JNpjlucwlsQS4ixmz+0B3NZkoe7RPCjTMHjThSddtl0swkZl
         9T4ukJZEb1V3D9PIKn1QSBahL4OsSxSyt8Ev8RV4nP+gW5w5H2fIC/DbwpMSiWPA2ABJ
         9FSCGJfesuGhbecSsxNaGU78fp4xK1ZtEG/Np1qnnavUKZQATQlqlnvHMnPQ00jbhhsT
         ZaIaZWJolnaAzbuXrVkj8YgfeHBhH8cSKbNy7isQ8DnR22sFEzBY+JDKCN7FQU7X7pO6
         9kesoGgKTzbUtS+7SlzHe9ECnLkHLRESFh5vhGRoZ0tXFvogf0IDqb82FrSDH0kDDKH0
         +zyg==
Content-Language: en-US
In-Reply-To: <5e5d41e2-5f89-8c52-11e5-0c55c5595a88-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2022/7/22 15:14, Abel Wu wrote:
> On 7/22/22 2:13 PM, Chengming Zhou Wrote:
>> On 2022/7/22 11:30, Abel Wu wrote:
>>> Hi Chengming,
>>>
>>> On 7/21/22 12:04 PM, Chengming Zhou Wrote:
>>>> Now PSI already tracked workload pressure stall information for
>>>> CPU, memory and IO. Apart from these, IRQ/SOFTIRQ could have
>>>> obvious impact on some workload productivity, such as web service
>>>> workload.
>>>>
>>>> When CONFIG_IRQ_TIME_ACCOUNTING, we can get IRQ/SOFTIRQ delta time
>>>> from update_rq_clock_task(), in which we can record that delta
>>>> to CPU curr task's cgroups as PSI_IRQ_FULL status.
>>>
>>> The {soft,}irq affection should be equal to all the runnable tasks
>>> on that cpu, not only rq->curr. Further I think irqstall is per-cpu
>>> rather than per-cgroup.
>>
>> Although IRQ/SOFTIRQ is per-cpu, it's the rq->curr who own the CPU at the time
>> and pay for it, meanwhile other groups would be thought as PSI_CPU_FULL.
> 
> I don't think rq->curr pays for it if you mean consuming quota here.

Yes, it makes rq->curr's groups look more productive than it actually is,
which are clearly different from other groups.

> And it doesn't seem appropriate to let other groups treat it as cpu
> stall because the rq->curr is also the victim rather than the one
> causes stall (so it's different from rq->curr causing memstall and
> observed as cpustall by others).

IMHO, we don't care who causes stall, instead we care about what affects
workload productivity.


> 
>>
>> So I think it's reasonable to account this IRQ/SOFTIRQ delta to rq->curr's groups
>> as PSI_IRQ_FULL pressure stall. And per-cpu IRQ stall can also get from psi_system.
>>
> 
