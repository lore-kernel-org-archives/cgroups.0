From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 1/3] llist: Add a lock-less list variant terminated by
 a sentinel node
Date: Mon, 3 Oct 2022 06:40:04 -1000
Message-ID: <YzsQZPONIJRgtf3o@slm.duckdns.org>
References: <20221003154459.207538-1-longman@redhat.com>
 <20221003154459.207538-2-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=9ee4zy4RkBCLXpL+JKk/4ZofQQA2htMYqURBy7ZeYvU=;
        b=CKJPy4Uewqo/YSJOPAe2d6CxIu2KBmc6h/tP9XP4IK7T5VK9xEh3MEwWAZe9xY66SH
         ySIs9v3huPVH3j7wos9zJYCwAcdngQ2AbsH+huitf4dGtkbrcPJL9dPYHCtwzChkLvCM
         vDw2vWysO3XbuzerYOv+YsWnpiuJaAJE3HyD2/Sbxad9FUFCnsUiFSg2PzuIn6LoOT9u
         Stsde1+6dbSK8Ot8xj8OoSrSm8PcKhgOzBhe/lpGHbY7ZoPT3aruv5+eMFubEyyNUUdg
         0qofEhC0+RNwovX7oFcrxEdxYCWUktDI5RQrVh+og06/ocfq0ZossVtSZij1PoYnUGV7
         Blog==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221003154459.207538-2-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>

Hello, Waiman.

On Mon, Oct 03, 2022 at 11:44:57AM -0400, Waiman Long wrote:
> The lock-less list API is useful for dealing with list in a lock-less
> manner. However, one of the drawback of the current API is that there
> is not an easy way to determine if an entry has already been put into a
> lock-less list. This has to be tracked externally and the tracking will
> not be atomic unless some external synchronization logic is in place.
> 
> This patch introduces a new variant of the lock-less list terminated
> by a sentinel node instead of by NULL. The function names start with
> "sllist" instead of "llist". The advantage of this scheme is that we
> can atomically determine if an entry has been put into a lock-less
> list by looking at the next pointer of the llist_node. Of course, the
> callers must clear the next pointer when an entry is removed from the
> lockless list. This is done automatically when the sllist_for_each_safe
> or sllist_for_each_entry_safe iteraters are used. The non-safe versions
> of sllist iterator are not provided.

Any chance we can add sentinel to the existing llist instead of creating a
new variant? There's no real downside to always using sentinel, right?

Thanks.

-- 
tejun
