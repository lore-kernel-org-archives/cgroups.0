From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [patch v11 0/6] support concurrent sync io for bfq on a specail
 occasion
Date: Tue, 18 Oct 2022 12:00:05 +0800
Message-ID: <82f1e969-742d-d3c3-63ca-961c755b5c35@huaweicloud.com>
References: <20220916071942.214222-1-yukuai1@huaweicloud.com>
 <29348B39-94AE-4D76-BD2E-B759056264B6@linaro.org>
 <011d479f-644f-0013-40bf-664b62f93bec@huaweicloud.com>
 <A9D22DB6-6481-46BA-9D4C-5A828D19CB61@linaro.org>
 <bcd07062-5a3b-563e-fb2d-2fa8e4c8bba5@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <bcd07062-5a3b-563e-fb2d-2fa8e4c8bba5-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi, Paolo

在 2022/10/11 17:36, Yu Kuai 写道:
>>>> Your patches seem ok to me now (thanks for you contribution and, 
>>>> above all, for your patience). I have only a high-level concern: 
>>>> what do you mean when you say that service guarantees are still 
>>>> preserved? What test did you run exactly? This point is very 
>>>> important to me. I'd like to see some convincing test with 
>>>> differentiated weights. In case you don't have other tools for 
>>>> executing such tests quickly, you may want to use the 
>>>> bandwidth-latency test in my simple S benchmark suite (for which I'm 
>>>> willing to help).
>>>
>>> Is there any test that you wish me to try?
>>>
>>> By the way, I think for the case that multiple groups are activaced, (
>>> specifically num_groups_with_pendind_rqs > 1), io path in bfq is the
>>> same with or without this patchset.
> 
> I just ran the test for one time, result is a liiter inconsistent, do
> you think it's in the normal fluctuation range?

I rerun the manually test for 5 times, here is the average result:

without this patchset / with this patchset:

| --------------- | ------------- | ------------ | -------------- | 
------------- | -------------- |
| cg1 weight      | 10            | 20           | 30             | 40 
          | 50             |
| cg2 weight      | 90            | 80           | 70             | 60 
          | 50             |
| cg1 bw MiB/s    | 21.4 / 21.74  | 42.72 / 46.6 | 63.82 / 61.52  | 
94.74 / 90.92 | 140 / 138.2    |
| cg2 bw MiB/s    | 197.2 / 197.4 | 182 / 181.2  | 171.2 / 173.44 | 162 
/ 156.8   | 138.6 / 137.04 |
| cg2 bw / cg1 bw | 9.22 / 9.08   | 4.26 / 3.89  | 2.68 / 2.82    | 1.71 
/ 1.72   | 0.99 / 0.99    |

> 
> test script:
> fio -filename=/dev/nullb0 -ioengine=libaio -ioscheduler=bfq -jumjobs=1 
> -iodepth=64 -direct=1 -bs=4k -rw=randread -runtime=60 -name=test
> 
> without this patchset:
> |                 |      |      |      |      |      |
> | --------------- | ---- | ---- | ---- | ---- | ---- |
> | cg1 weight      | 10   | 20   | 30   | 40   | 50   |
> | cg2 weight      | 90   | 80   | 70   | 60   | 50   |
> | cg1 bw MiB/s    | 25.8 | 51.0 | 80.1 | 90.5 | 138  |
> | cg2 bw MiB/s    | 193  | 179  | 162  | 127  | 136  |
> | cg2 bw / cg1 bw | 7.48 | 3.51 | 2.02 | 1.40 | 0.98 |
> 
> with this patchset
> |                 |      |      |      |      |      |
> | --------------- | ---- | ---- | ---- | ---- | ---- |
> | cg1 weight      | 10   | 20   | 30   | 40   | 50   |
> | cg2 weight      | 90   | 80   | 70   | 60   | 50   |
> | cg1 bw MiB/s    | 21.5 | 43.9 | 62.7 | 87.4 | 136  |
> | cg2 bw MiB/s    | 195  | 185  | 173  | 138  | 141  |
> | cg2 bw / cg1 bw | 9.07 | 4.21 | 2.75 | 1.57 | 0.96 |
>>>
>>
>> The tests cases you mentioned are ok for me (whatever tool or personal
>> code you use to run them).  Just show me your results with and without
>> your patchset applied.
>>
>> Thanks,
>> Paolo
>>
>>> Thanks,
>>> Kuai
>>>> Thanks,
>>>> Paolo
>>>>> Previous versions:
>>>>> RFC: 
>>>>> https://lore.kernel.org/all/20211127101132.486806-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/ 
>>>>>
>>>>> v1: 
>>>>> https://lore.kernel.org/all/20220305091205.4188398-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/ 
>>>>>
>>>>> v2: 
>>>>> https://lore.kernel.org/all/20220416093753.3054696-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/ 
>>>>>
>>>>> v3: 
>>>>> https://lore.kernel.org/all/20220427124722.48465-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/
>>>>> v4: 
>>>>> https://lore.kernel.org/all/20220428111907.3635820-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/ 
>>>>>
>>>>> v5: 
>>>>> https://lore.kernel.org/all/20220428120837.3737765-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/ 
>>>>>
>>>>> v6: 
>>>>> https://lore.kernel.org/all/20220523131818.2798712-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/ 
>>>>>
>>>>> v7: 
>>>>> https://lore.kernel.org/all/20220528095020.186970-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/ 
>>>>>
>>>>>
>>>>>
>>>>> Yu Kuai (6):
>>>>>   block, bfq: support to track if bfqq has pending requests
>>>>>   block, bfq: record how many queues have pending requests
>>>>>   block, bfq: refactor the counting of 'num_groups_with_pending_reqs'
>>>>>   block, bfq: do not idle if only one group is activated
>>>>>   block, bfq: cleanup bfq_weights_tree add/remove apis
>>>>>   block, bfq: cleanup __bfq_weights_tree_remove()
>>>>>
>>>>> block/bfq-cgroup.c  | 10 +++++++
>>>>> block/bfq-iosched.c | 71 +++++++--------------------------------------
>>>>> block/bfq-iosched.h | 30 +++++++++----------
>>>>> block/bfq-wf2q.c    | 69 ++++++++++++++++++++++++++-----------------
>>>>> 4 files changed, 76 insertions(+), 104 deletions(-)
>>>>>
>>>>> -- 
>>>>> 2.31.1
>>>>>
>>>> .
>>
>> .
>>
> 
> .
> 

