From: QiuLaibin <qiulaibin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next] blk-throttle: Set BIO_THROTTLED when bio has been
 throttled
Date: Tue, 14 Dec 2021 17:12:48 +0800
Message-ID: <8c87a712-93fb-d794-6d08-cadf6452efc3@huawei.com>
References: <20211118131551.810931-1-qiulaibin@huawei.com>
 <YaUZExR6v8IdZUeM@slm.duckdns.org>
 <03964258-10ff-7f19-10cb-ca4eccf72848@huawei.com>
 <YbepLpyMPqP2ao3J@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <YbepLpyMPqP2ao3J-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2021/12/14 4:12, Tejun Heo wrote:
> On Mon, Dec 13, 2021 at 05:24:00PM +0800, QiuLaibin wrote:
>>> * This function is called synchronously on the issue path. The bio isn't
>>>     seen by the queue and device driver yet and nothing can race to issue it
>>>     before this function returns.
>>>
>>
>> The bio is under throttle here, this submit_bio return directly. And
>> current process will queue a dispatch work by
>> throtl_schedule_pending_timer() to submit this bio before BIO_THROTTLED flag
>> set. If the bio is completed quickly after the dispatch work is queued, UAF
>> of bio will happen.
> 
> You are right, the timer can get to it. Can't it be solved by just
> reordering spin_unlock and setting BIO_THROTTLED?
> 

I think it can be solved by setting BIO_THROTTLED before queue dispatch 
work.

>>> * Now we're not setting BIO_THROTTLED when we're taking a different return
>>>     path through the out_unlock label and risks calling back into blk_throtl
>>>     again on the same bio.
>>>
>>
>> In my opinion, This flag can prevent the request from being throttled
>> multiple times. If the request itself does not need to be throttled, the
>> result of repeated entry will be the same.
>> If necessary, I think we can use other methods to achieve this effect for
>> request does not need to be throttled.
> 
> So that we don't change anything regarding this?
> 

I am thinking of adding a new bio tag (like BIO_THROTTLE_BYPASS) to 
avoid those requests which do not need to be throttled to enter the 
throttle multiple times.
> Thanks.
> 
