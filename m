From: Abel Wu <wuyun.abel@bytedance.com>
Subject: Re: [PATCH 9/9] sched/psi: add PSI_IRQ to track IRQ/SOFTIRQ pressure
Date: Fri, 22 Jul 2022 15:14:00 +0800
Message-ID: <5e5d41e2-5f89-8c52-11e5-0c55c5595a88@bytedance.com>
References: <20220721040439.2651-1-zhouchengming@bytedance.com>
 <20220721040439.2651-10-zhouchengming@bytedance.com>
 <65d9f79b-be9b-e21e-0624-5c9f2cc0c0b2@bytedance.com>
 <ce22fa9d-aad0-fc23-d304-14fdd27130f4@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Gts6QjrIoCSOBmG3jGbKb3eul2uSF3MTCws6wh5quBU=;
        b=mJWWyyMIyJtter05K23sBP49ExJhHuakrSmup0Lyp7fFs/JwZdkZTej6SwtGfLSlbw
         7IBUSpZuil8/hRSDzqTvcBb0D7j1YdwogYL82PQWEGpIoIzqQUhR0Po/is6TFlr2Cqu2
         5NiWDIbUEDBkLP83ixN1UYyRaHSz2ZFs9i8m3uYbL0KLomP2Zo1YrctY4jYMWm8S4toY
         uTZeuognAbH/dQYexucHsav7T2qcO5sS1ZwIiBvM6BxpN6+CobP0ez5a35e3rQ9KAElV
         oULecPO8ft5qj+rajgCyb4B4pHFCQ0PV7tCvcl9tMGOCnEy3/1R59RIsGvF3hRIVYj2B
         fQDA==
Content-Language: en-US
In-Reply-To: <ce22fa9d-aad0-fc23-d304-14fdd27130f4@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Chengming Zhou <zhouchengming@bytedance.com>, hannes@cmpxchg.org, surenb@google.com, mingo@redhat.com, peterz@infradead.org, tj@kernel.org, corbet@lwn.net, akpm@linux-foundation.org, rdunlap@infradead.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com, cgroups@vger.kernel.org

On 7/22/22 2:13 PM, Chengming Zhou Wrote:
> On 2022/7/22 11:30, Abel Wu wrote:
>> Hi Chengming,
>>
>> On 7/21/22 12:04 PM, Chengming Zhou Wrote:
>>> Now PSI already tracked workload pressure stall information for
>>> CPU, memory and IO. Apart from these, IRQ/SOFTIRQ could have
>>> obvious impact on some workload productivity, such as web service
>>> workload.
>>>
>>> When CONFIG_IRQ_TIME_ACCOUNTING, we can get IRQ/SOFTIRQ delta time
>>> from update_rq_clock_task(), in which we can record that delta
>>> to CPU curr task's cgroups as PSI_IRQ_FULL status.
>>
>> The {soft,}irq affection should be equal to all the runnable tasks
>> on that cpu, not only rq->curr. Further I think irqstall is per-cpu
>> rather than per-cgroup.
> 
> Although IRQ/SOFTIRQ is per-cpu, it's the rq->curr who own the CPU at the time
> and pay for it, meanwhile other groups would be thought as PSI_CPU_FULL.

I don't think rq->curr pays for it if you mean consuming quota here.
And it doesn't seem appropriate to let other groups treat it as cpu
stall because the rq->curr is also the victim rather than the one
causes stall (so it's different from rq->curr causing memstall and
observed as cpustall by others).

> 
> So I think it's reasonable to account this IRQ/SOFTIRQ delta to rq->curr's groups
> as PSI_IRQ_FULL pressure stall. And per-cpu IRQ stall can also get from psi_system.
> 

