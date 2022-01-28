From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/3] block, bfq: minor cleanup and fix
Date: Fri, 28 Jan 2022 17:35:40 +0800
Message-ID: <a6c3696b-467c-0ea7-141c-714a9a1b7ba4@huawei.com>
References: <20211231032354.793092-1-yukuai3@huawei.com>
 <a461cdbd-e1f3-0083-cd96-b69837334b19@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a461cdbd-e1f3-0083-cd96-b69837334b19-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: jack-AlSwsSmVLrQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

在 2022/01/24 11:46, yukuai (C) 写道:
> 在 2021/12/31 11:23, Yu Kuai 写道:
>> Chagnes in v2:
>>   - add comment in patch 2
>>   - remove patch 4, since the problem do not exist.
>>
>> Yu Kuai (3):
>>    block, bfq: cleanup bfq_bfqq_to_bfqg()
>>    block, bfq: avoid moving bfqq to it's parent bfqg
>>    block, bfq: don't move oom_bfqq
>>
>>   block/bfq-cgroup.c  | 16 +++++++++++++++-
>>   block/bfq-iosched.c |  4 ++--
>>   block/bfq-iosched.h |  1 -
>>   block/bfq-wf2q.c    | 15 ---------------
>>   4 files changed, 17 insertions(+), 19 deletions(-)
>>
> Hi, jens
> 
> Now that with acked-by Paolo, can you please applied this pathset?
friendly ping ...
> 
> Thanks,
> Kuai
