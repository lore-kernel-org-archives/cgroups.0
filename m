From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v7 1/3] llist: Add a lock-less list variant terminated by
 a sentinel node
Date: Mon, 3 Oct 2022 07:36:50 -1000
Message-ID: <YzsdsjlMMDFwLOzR@slm.duckdns.org>
References: <20221003154459.207538-1-longman@redhat.com>
 <20221003154459.207538-2-longman@redhat.com>
 <YzsQZPONIJRgtf3o@slm.duckdns.org>
 <006ebc52-ab37-442a-9ba3-e7b8dff53fab@redhat.com>
 <YzsUgY4CC0SH8Sl2@slm.duckdns.org>
 <8008933b-4a28-19e5-02db-ef1d07eaf952@redhat.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=5L++ta1CEKG7cNirpHCVz8TWx+DYjvecQkSUPMV2bHg=;
        b=lTWWoEoXEzxpuxxTJ3loP+njbF5t/rALzsK3NCjNS0BMDeQgm4X9ZNI/RxAfvH5z3G
         MpyC7/pIViafioL12ImcN7/XnBPCrAuVHfvK/WNf3APtv6JGTBvdfIecRwahKQTlmXZk
         pWASBgGnLNZCxMV2Umj2EioGHEM5HWXKTOWEaLYIZqVg968cTiU6+CpMzYOPfk2Th3pX
         rjQaUwGL1XipGw1LaJvq61i/O9gXnIQULcXVq7k2CDrsg2vhE9RGyGp9x5C1HfOpgMoT
         Mq1qE0bCafvetOV9rtbK5XbYs8ZV8cna/GZYew8+T/84t3NzoJYLc8+a0v+Z7A9CQjdi
         u+KQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <8008933b-4a28-19e5-02db-ef1d07eaf952@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>

Hello,

On Mon, Oct 03, 2022 at 01:32:49PM -0400, Waiman Long wrote:
> What my current thinking is to make llist works with both NULL and sentinel
> terminated lockless list. Users who wish to use the sentinel terminated
> version will have to use special sentinel version of LLIST_HEAD() macro and
> llist_del_all() and __llist_del_all() functions. In this way, I don't need
> to touch an existing users of llist while minimizing code redundancy. What
> do you think?

Wouldn't that be more error-prone in the long term? I'd just bite the bullet
and convert the empty tests. It is a hassle to find them but given that it's
just the head node testing, it hopefully wouldn't be too bad.

Thanks.

-- 
tejun
