From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v7 1/3] llist: Add a lock-less list variant terminated by
 a sentinel node
Date: Mon, 3 Oct 2022 13:40:05 -0400
Message-ID: <87e7cd70-4ab6-f33b-ce26-afe2c7c04faa@redhat.com>
References: <20221003154459.207538-1-longman@redhat.com>
 <20221003154459.207538-2-longman@redhat.com>
 <YzsQZPONIJRgtf3o@slm.duckdns.org>
 <006ebc52-ab37-442a-9ba3-e7b8dff53fab@redhat.com>
 <YzsUgY4CC0SH8Sl2@slm.duckdns.org>
 <8008933b-4a28-19e5-02db-ef1d07eaf952@redhat.com>
 <YzsdsjlMMDFwLOzR@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664818813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/OvRUrGfw8TOZah0PxNYChSkH0fCR+iXG8NZ//kOXLc=;
        b=GLvw4/8Md/ka9eC21uvQhKfX1eSQGuBdPVW0qGYFm6JV2A05J2Fbo5W5s5rNn6w5vN6vpq
        mb4eRanNfv5av0MfhqBIcLUqOi5KaZ5PO2zbTTiAvEaZyZRYg3miU3NUH18JXI1gJu8/od
        OKdxELzuP9ss///g2MtEh9GfyJU+puk=
Content-Language: en-US
In-Reply-To: <YzsdsjlMMDFwLOzR@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>


On 10/3/22 13:36, Tejun Heo wrote:
> Hello,
>
> On Mon, Oct 03, 2022 at 01:32:49PM -0400, Waiman Long wrote:
>> What my current thinking is to make llist works with both NULL and sentinel
>> terminated lockless list. Users who wish to use the sentinel terminated
>> version will have to use special sentinel version of LLIST_HEAD() macro and
>> llist_del_all() and __llist_del_all() functions. In this way, I don't need
>> to touch an existing users of llist while minimizing code redundancy. What
>> do you think?
> Wouldn't that be more error-prone in the long term? I'd just bite the bullet
> and convert the empty tests. It is a hassle to find them but given that it's
> just the head node testing, it hopefully wouldn't be too bad.

OK, I will take a further look at what changes will be needed by the 
existing llist users.

Thanks,
Longman

