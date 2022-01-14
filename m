From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/3] block, bfq: minor cleanup and fix
Date: Fri, 14 Jan 2022 16:23:36 +0800
Message-ID: <1cdb99ba-ed52-c755-fec4-86ee5f9bc61d@huawei.com>
References: <20211231032354.793092-1-yukuai3@huawei.com>
 <5696c767-8248-09a4-f04e-ac93138d30ef@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5696c767-8248-09a4-f04e-ac93138d30ef-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: jack-AlSwsSmVLrQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

在 2022/01/11 9:40, yukuai (C) 写道:
> 在 2021/12/31 11:23, Yu Kuai 写道:
>> Chagnes in v2:
>>   - add comment in patch 2
>>   - remove patch 4, since the problem do not exist.
>>
> friendly ping ...

Hi, Jens

Can this patchset be applied?

Thanks
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
