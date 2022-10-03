From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 1/3] llist: Add a lock-less list variant terminated by
 a sentinel node
Date: Mon, 3 Oct 2022 13:32:49 -0400
Message-ID: <8008933b-4a28-19e5-02db-ef1d07eaf952@redhat.com>
References: <20221003154459.207538-1-longman@redhat.com>
 <20221003154459.207538-2-longman@redhat.com>
 <YzsQZPONIJRgtf3o@slm.duckdns.org>
 <006ebc52-ab37-442a-9ba3-e7b8dff53fab@redhat.com>
 <YzsUgY4CC0SH8Sl2@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664818374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yBSbBZJTth3XYTHA2mLySm1VLze7ahVnS1GTEZ2C0hY=;
        b=hqO1pLHkobZvOnxNKjnb3ONlTppkB+gl7QN3ke9x0DPU4FzyaD5A1xaqyAwKl79RIYZWCo
        gQNBWkRQZYfz3164Uva/Nn9vqPQxbHvPlBOEvwpGLhvAH8hPWKGs5olZs9/crJyeTURgO/
        IKIkCVaFbN4b5E/MZNMmW+zije15HTk=
Content-Language: en-US
In-Reply-To: <YzsUgY4CC0SH8Sl2-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On 10/3/22 12:57, Tejun Heo wrote:
> On Mon, Oct 03, 2022 at 12:55:24PM -0400, Waiman Long wrote:
>> That was my original plan. However, after looking at some existing users of
>> lockless list, they have coded in the dependency on the fact that a lockless
>> list is empty if it is NULL. I guess I can make this true also for the new
>> lockless list with sentinel at the expense of a bit more overhead in the
>> entry insertion path and deletion path. I will take a further look at that.
> There aren't that many users of llist. Maybe it'd be easier / cleaner to
> introduce a macro to test whether a llist is empty and replace the NULL
> tests?

What my current thinking is to make llist works with both NULL and 
sentinel terminated lockless list. Users who wish to use the sentinel 
terminated version will have to use special sentinel version of 
LLIST_HEAD() macro and llist_del_all() and __llist_del_all() functions. 
In this way, I don't need to touch an existing users of llist while 
minimizing code redundancy. What do you think?

Cheers,
Longman

