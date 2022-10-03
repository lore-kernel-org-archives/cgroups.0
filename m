From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 1/3] llist: Add a lock-less list variant terminated by
 a sentinel node
Date: Mon, 3 Oct 2022 15:39:02 -0400
Message-ID: <67f5d0af-dbfa-291a-a596-c90860b94455@redhat.com>
References: <20221003154459.207538-1-longman@redhat.com>
 <20221003154459.207538-2-longman@redhat.com>
 <YzsQZPONIJRgtf3o@slm.duckdns.org>
 <006ebc52-ab37-442a-9ba3-e7b8dff53fab@redhat.com>
 <YzsUgY4CC0SH8Sl2@slm.duckdns.org>
 <8008933b-4a28-19e5-02db-ef1d07eaf952@redhat.com>
 <YzsdsjlMMDFwLOzR@slm.duckdns.org>
 <87e7cd70-4ab6-f33b-ce26-afe2c7c04faa@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664825946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bt8NrIwM3fjyECcwzKDQPI25RNR/tnhtjpGaAmrolEU=;
        b=L977o8K4kRJlpFxbR2lr9hMnGnhb5NBnawJHG0P0y8YwFVmF3uRfXrA+/bM+3jq0LZLtLz
        B8XuUYmMgepKf7GWXFKAiPW5nKgohgbNP9DykmLdxcrZ6cxW+cd44cOC/2F5KjOtoIwSzM
        AKDwsqOnt+ty460TDzu6waIOe3U7Z78=
Content-Language: en-US
In-Reply-To: <87e7cd70-4ab6-f33b-ce26-afe2c7c04faa-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>


On 10/3/22 13:40, Waiman Long wrote:
>
> On 10/3/22 13:36, Tejun Heo wrote:
>> Hello,
>>
>> On Mon, Oct 03, 2022 at 01:32:49PM -0400, Waiman Long wrote:
>>> What my current thinking is to make llist works with both NULL and 
>>> sentinel
>>> terminated lockless list. Users who wish to use the sentinel terminated
>>> version will have to use special sentinel version of LLIST_HEAD() 
>>> macro and
>>> llist_del_all() and __llist_del_all() functions. In this way, I 
>>> don't need
>>> to touch an existing users of llist while minimizing code 
>>> redundancy. What
>>> do you think?
>> Wouldn't that be more error-prone in the long term? I'd just bite the 
>> bullet
>> and convert the empty tests. It is a hassle to find them but given 
>> that it's
>> just the head node testing, it hopefully wouldn't be too bad.
>
> OK, I will take a further look at what changes will be needed by the 
> existing llist users.

After a further look, I think the task of making sentinel llist the 
default will be more time consuming that I initially thought. For example,

1) arch/powerpc/include/asm/kvm_book3s_64.h:
    It has its own llist iterator for_each_nest_rmap_safe.

2) kprobe use llist but not the full set of APIs and the
    various arch code put NULL in their llist_node to communicate
    with kprobe.

3) drivers/vhost/scsi.c uses llist but it doesn't use LLIST_HEAD
    nor init_llist_head to initialize the llist_head. I suspect that
    it may relies on NULL being the initial value.

There are 123 instances where llist_head is referenced in arch, driver, 
filesystem and kernel code. Going through all these to make sure that it 
will all work will be a major effort. I think it will be safer to allow 
both NULL and the sentinel node as the initializers and gradually 
convert them to use the proper llist APIs over time to complete the 
conversion. I am sorry that I can't spend that much time upfront for 
this conversion effort.

Regards,
Longman

