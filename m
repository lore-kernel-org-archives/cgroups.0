From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v9] block: cancel all throttled bios in del_gendisk()
Date: Thu, 17 Mar 2022 19:22:04 +0800
Message-ID: <f46c8512-400b-144f-e2ba-c57cc895fca8@huawei.com>
References: <20220210115637.1074927-1-yukuai3@huawei.com>
 <YhuyBgZSS6m/Mwu6@infradead.org> <Yhxnkg0AEaj36t+a@T590>
 <YhyYpWHGVhs3J/dk@infradead.org> <Yh31bQu3gbXoDBuK@T590>
 <836f0686-4ac8-327d-2bab-64a762ea8673@huawei.com> <Yh6/dH2CERzsBPJd@T590>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Yh6/dH2CERzsBPJd@T590>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

在 2022/03/02 8:51, Ming Lei 写道:
> On Tue, Mar 01, 2022 at 09:54:28PM +0800, yukuai (C) wrote:
>> 在 2022/03/01 18:29, Ming Lei 写道:
>>> On Mon, Feb 28, 2022 at 01:40:53AM -0800, Christoph Hellwig wrote:
>>>> On Mon, Feb 28, 2022 at 02:11:30PM +0800, Ming Lei wrote:
>>>>>> FYI, this crashed left rigt and center when running xfstests with
>>>>>> traces pointing to throtl_pending_timer_fn.
>>>>>
>>>>> Can you share the exact xfstests test(fs, test)? Or panic log?
>>>>>
>>>>> I can't reproduce it when running './check -g auto' on XFS, meantime
>>>>> tracking throtl_pending_timer_fn().
>>>>
>>>>   From a quick run using f2fs:
>>>>
>>>> generic/081 files ... [  316.487861] run fstests generic/081 at 2022-02-28 09:38:40
>>>
>>> Thanks for providing the reproducer.
>>>
>>> The reason is that the pending timer is deleted in blkg's release
>>> handler, so the timer can still be live after request queue is released.
>>>
>>> The patch of 'block: cancel all throttled bios in del_gendisk()' should just
>>> make it easier to trigger.
>>>
>>> After patch of "block: move blkcg initialization/destroy into disk allocation/
>>> release handler" lands, the issue can be fixed easily by:

Hi, Ming

Now that the above patch is landed in linux-next, do you intend to fix
the above problem? Or I can take over if you don't mind.

Thanks,
Kuai
