From: hanjinke <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH] block: don't allow the same type rq_qos add more than
 once
Date: Tue, 19 Jul 2022 15:50:32 +0800
Message-ID: <5b02a27a-72a1-501f-b06e-8963ebb34916@bytedance.com>
References: <20220718083646.67601-1-hanjinke.666@bytedance.com>
 <CAMZfGtVLkO6T-0n7fMBTvR84Ji8GhTO5==u9v+8f+dRkJhFHMA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=PBjfaUdPj5evCqbgk7mF2+xOQYrjkKK5SCgiEZ6AFog=;
        b=4lwX7lH7voEKXllRjuXXIWuahCwdYq00XCmdkwgwHW+uSezLtuOHvA8XUQvxDoInJo
         1rmAKASBIbnytTQnjyuqU6+YQmfiHYm+FNy5r8SL6eqKkqOSjt8TdQ9HDs24ToNKISF7
         NmzKbGCE574fdSkm8oq0ADc0E6cNKtmh8dMY4gSahs3KzV0JkdP+5mj9Ujy7g+eXqiRa
         DTHm/ZV38rwMpVczuRD2ZMVyFTKBU+QTGiDi9ughNhOqUYWISMwj5zIFuHCHGtONvmfw
         FBvWAuvhWsrWY2AGdlrf3FfN522CyVSidLNB5LAhdlvnuE1ikmd5g5h3ISqwRGAEopQC
         5Xlg==
In-Reply-To: <CAMZfGtVLkO6T-0n7fMBTvR84Ji8GhTO5==u9v+8f+dRkJhFHMA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "open list:BLOCK LAYER" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Thanks for your review. I have saw this review just after the send of 
patch v2

在 2022/7/19 下午2:53, Muchun Song 写道:
> On Mon, Jul 18, 2022 at 4:37 PM Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
>>
>> From: hanjinke <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
>>
>> In our test of iocost, we encounttered some list add/del corrutions of
>> inner_walk list in ioc_timer_fn.
>> The resean can be descripted as follow:
>>
>> cpu 0                                           cpu 1
>> ioc_qos_write                                   ioc_qos_write
>>
>> ioc = q_to_ioc(bdev_get_queue(bdev));
>> if (!ioc) {
>>          ioc = kzalloc();                        ioc = q_to_ioc(bdev_get_queue(bdev));
>>                                                          if (!ioc) {
>>                                                                  ioc = kzalloc();
>>                                                                  ...
>>                                                                  rq_qos_add(q, rqos);
>>                                                           }
>>          ...
>>          rq_qos_add(q, rqos);
>>          ...
>> }
>>
>> When the io.cost.qos file is written by two cpu concurrently, rq_qos may
>> be added to one disk twice. In that case, there will be two iocs enabled
>> and running on one disk. They own different iocgs on their active list.
>> In the ioc_timer_fn function, because of the iocgs from two ioc have the
>> same root iocg, the root iocg's walk_list may be overwritten by each
>> other and this lead to list add/del corrutions in building or destorying
>> the inner_walk list.
>>
>> And so far, the blk-rq-qos framework works in case that one instance for
>> one type rq_qos per queue by default. This patch make this explicit and
>> also fix the crash above.
>>
>> Signed-off-by: hanjinke <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> 
> The change LGTM. Maybe it is better to add a Fixes tag here so that
> others can easily know what Linux versions should be backported.
> 
> Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> 
> Thanks.
