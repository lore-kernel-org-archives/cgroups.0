From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 1/3] llist: Add a lock-less list variant terminated by
 a sentinel node
Date: Mon, 3 Oct 2022 12:55:24 -0400
Message-ID: <006ebc52-ab37-442a-9ba3-e7b8dff53fab@redhat.com>
References: <20221003154459.207538-1-longman@redhat.com>
 <20221003154459.207538-2-longman@redhat.com>
 <YzsQZPONIJRgtf3o@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664816128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tbuz3qR+hD453Hh1mWG4NdV8SaaNv0Mi9FQnyaBvNcQ=;
        b=b/bQp0TKTdQUPHmntzH7Tzl90QqzT9MyHjf484vn4ZKeEb386mRRmwWmPkFOpCJqNVWMBj
        DCkHqTBOXdxikLECZyl8/Ki2C2wc2xhHEIOOJY9wvM3HeyPtkX9Hw0cjRzLSLKzC86/EE1
        TkMyPeu9lPodRXSugSn5UeAwTLNMfyc=
Content-Language: en-US
In-Reply-To: <YzsQZPONIJRgtf3o-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>


On 10/3/22 12:40, Tejun Heo wrote:
> Hello, Waiman.
>
> On Mon, Oct 03, 2022 at 11:44:57AM -0400, Waiman Long wrote:
>> The lock-less list API is useful for dealing with list in a lock-less
>> manner. However, one of the drawback of the current API is that there
>> is not an easy way to determine if an entry has already been put into a
>> lock-less list. This has to be tracked externally and the tracking will
>> not be atomic unless some external synchronization logic is in place.
>>
>> This patch introduces a new variant of the lock-less list terminated
>> by a sentinel node instead of by NULL. The function names start with
>> "sllist" instead of "llist". The advantage of this scheme is that we
>> can atomically determine if an entry has been put into a lock-less
>> list by looking at the next pointer of the llist_node. Of course, the
>> callers must clear the next pointer when an entry is removed from the
>> lockless list. This is done automatically when the sllist_for_each_safe
>> or sllist_for_each_entry_safe iteraters are used. The non-safe versions
>> of sllist iterator are not provided.
> Any chance we can add sentinel to the existing llist instead of creating a
> new variant? There's no real downside to always using sentinel, right?

That was my original plan. However, after looking at some existing users 
of lockless list, they have coded in the dependency on the fact that a 
lockless list is empty if it is NULL. I guess I can make this true also 
for the new lockless list with sentinel at the expense of a bit more 
overhead in the entry insertion path and deletion path. I will take a 
further look at that.

Cheers,
Longman

