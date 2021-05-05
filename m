From: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 1/1] sched/fair: Fix unfairness caused by missing load
 decay
Date: Wed, 5 May 2021 11:43:00 +0200
Message-ID: <4b0d6562-db41-b4fc-ae51-694946c9255d@arm.com>
References: <20210425080902.11854-1-odin@uged.al>
 <20210425080902.11854-2-odin@uged.al> <20210427142611.GA22056@vingu-book>
 <CAFpoUr1KOvLSUoUac8MMTD+TREDWmDpeku950U=_p-oBDE4Avw@mail.gmail.com>
 <CAKfTPtCtt9V69AvkJTuMDRPJXGPboFsnSmwLM5RExnU2h5stSw@mail.gmail.com>
 <4ba77def-c7e9-326e-7b5c-cd491b063888@arm.com>
 <CAFpoUr3vMQq8QYajXZsQ6zWQOncO5Q8-2gFWOJLFm-APUznuZA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFpoUr3vMQq8QYajXZsQ6zWQOncO5Q8-2gFWOJLFm-APUznuZA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Odin Ugedal <odin-lVFEcm3hDZTQT0dZR+AlfA@public.gmane.org>
Cc: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 01/05/2021 16:41, Odin Ugedal wrote:
> Hi,
> 
>> I think what I see on my Juno running the unfairness_missing_load_decay.sh script is
>> in sync which what you discussed here:
> 
> Thanks for taking a look!
> 
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 794c2cb945f8..7214e6e89820 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -10854,6 +10854,8 @@ static void propagate_entity_cfs_rq(struct sched_entity *se)
>>                         break;
>>
>>                 update_load_avg(cfs_rq, se, UPDATE_TG);
>> +               if (!cfs_rq_is_decayed(cfs_rq))
>> +                       list_add_leaf_cfs_rq(cfs_rq);
>>         }
>> }
> 
> This might however lead to "loss" at /slice/cg-2/sub and
> slice/cg-1/sub in this particular case tho, since
> propagate_entity_cfs_rq skips one cfs_rq
> by taking the parent of the provided se. The loss in that case would
> however not be equally big, but will still often contribute to some
> unfairness.

Yeah, that's true.

By moving stopped `stress` tasks into

 /sys/fs/cgroup/cpu/slice/cg-{1,2}/sub

and then into

 /sys/fs/cgroup/cpuset/A

which has a cpuset.cpus {0-1,4-5} not containing the cpus the `stress`
tasks attached {2,3} to and then restart the `stress` tasks again I get:

cfs_rq[1]:/slice/cg-1/sub
  .load_avg                      : 1024
  .removed.load_avg              : 0
  .tg_load_avg_contrib           : 1024  <---
  .tg_load_avg                   : 2047  <---
  .se->avg.load_avg              : 511
cfs_rq[1]:/slice/cg-1
  .load_avg                      : 512
  .removed.load_avg              : 0
  .tg_load_avg_contrib           : 512  <---
  .tg_load_avg                   : 1022 <---
  .se->avg.load_avg              : 512
cfs_rq[1]:/slice
  .load_avg                      : 513
  .removed.load_avg              : 0
  .tg_load_avg_contrib           : 513
  .tg_load_avg                   : 1024
  .se->avg.load_avg              : 512
cfs_rq[5]:/slice/cg-1/sub
  .load_avg                      : 1024
  .removed.load_avg              : 0
  .tg_load_avg_contrib           : 1023 <---
  .tg_load_avg                   : 2047 <---
  .se->avg.load_avg              : 511
cfs_rq[5]:/slice/cg-1
  .load_avg                      : 512
  .removed.load_avg              : 0
  .tg_load_avg_contrib           : 510  <---
  .tg_load_avg                   : 1022 <---
  .se->avg.load_avg              : 511
cfs_rq[5]:/slice
  .load_avg                      : 512
  .removed.load_avg              : 0
  .tg_load_avg_contrib           : 511
  .tg_load_avg                   : 1024
  .se->avg.load_avg              : 510

I saw that your v2 patch takes care of that.
