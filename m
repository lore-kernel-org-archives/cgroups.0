From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 1/3] llist: Add a lock-less list variant terminated by
 a sentinel node
Date: Mon, 3 Oct 2022 06:57:37 -1000
Message-ID: <YzsUgY4CC0SH8Sl2@slm.duckdns.org>
References: <20221003154459.207538-1-longman@redhat.com>
 <20221003154459.207538-2-longman@redhat.com>
 <YzsQZPONIJRgtf3o@slm.duckdns.org>
 <006ebc52-ab37-442a-9ba3-e7b8dff53fab@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=4YG/tGIVB3HXKHAYKxLgnveb2mUS1J/Za8cyWbqcRbY=;
        b=FkJ7Es97xxSs2YAwhLK8TWOlLFBmMY1bjwqO34bON1COwPd5PRuVMtod/7QuUDDP75
         lyGv2r8xUrcSL4SC/ho84tRSmnMjc1A7v2eVQwSZC+9jPIAw3FZKbwcSSSa0JAHVerlL
         tUId1KvIk/wz8cuyRjMqeDZussaQl9dkC3WBNQ2zyfmtNxCcJwbA6Y2coMWu8HWXwYq4
         d3kXjSueMVuQ6Ch9ie42kTHwezmnqf4HtTdMdRiVpVuXuiKUrvczQOARSIk35gTzeNKq
         ZVQGMh9ULifYhtp9fmbXQ5lGEGp0bPhcEicdp3OsGvll+22pQF04LA8aVfwpchQItbz0
         ZNfA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <006ebc52-ab37-442a-9ba3-e7b8dff53fab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On Mon, Oct 03, 2022 at 12:55:24PM -0400, Waiman Long wrote:
> That was my original plan. However, after looking at some existing users of
> lockless list, they have coded in the dependency on the fact that a lockless
> list is empty if it is NULL. I guess I can make this true also for the new
> lockless list with sentinel at the expense of a bit more overhead in the
> entry insertion path and deletion path. I will take a further look at that.

There aren't that many users of llist. Maybe it'd be easier / cleaner to
introduce a macro to test whether a llist is empty and replace the NULL
tests?

Thanks.

-- 
tejun
