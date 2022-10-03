From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 1/3] llist: Add a lock-less list variant terminated by
 a sentinel node
Date: Mon, 3 Oct 2022 10:15:24 -1000
Message-ID: <YztC3BVzOiwOKZij@slm.duckdns.org>
References: <20221003154459.207538-1-longman@redhat.com>
 <20221003154459.207538-2-longman@redhat.com>
 <YzsQZPONIJRgtf3o@slm.duckdns.org>
 <006ebc52-ab37-442a-9ba3-e7b8dff53fab@redhat.com>
 <YzsUgY4CC0SH8Sl2@slm.duckdns.org>
 <8008933b-4a28-19e5-02db-ef1d07eaf952@redhat.com>
 <YzsdsjlMMDFwLOzR@slm.duckdns.org>
 <87e7cd70-4ab6-f33b-ce26-afe2c7c04faa@redhat.com>
 <67f5d0af-dbfa-291a-a596-c90860b94455@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=C3/N9hbhwupuGmO0AntkXcuTr5FrNGR8ZHngrdZEthU=;
        b=qRoStCLUpxzw2alYY4nRjwbDniVOp8r0swaVcfpwPdIZNnoFCQ4yfr/+ZSZ1CDeYOs
         z7pb17R3TjBSqJwf5r/yas2oc5Tg5YIcxLhgMAwL8Az8k0PEcg4mVmeiQR3jyRy/AwhO
         +YWF/uUicBgF61WQTFHS1YOx12fHVeKIowPbeQbx+MpvPCBiAd7NAmJcvPGKX+vzyvEP
         lWgbCkExvoG93U49AtvbMOPRVbxtS/ejd3i3tR9o+A3EQBbztZuuvQWE+mjLFEkO272e
         kMxiNlbpxEbPFy58aiweYJFXjJVHhv1oRFonnxwCQWQ5+4UX9EozgbNg3PmZUJENB6nM
         TukA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <67f5d0af-dbfa-291a-a596-c90860b94455-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>

Hello,

On Mon, Oct 03, 2022 at 03:39:02PM -0400, Waiman Long wrote:
> There are 123 instances where llist_head is referenced in arch, driver,
> filesystem and kernel code. Going through all these to make sure that it
> will all work will be a major effort. I think it will be safer to allow both
> NULL and the sentinel node as the initializers and gradually convert them to
> use the proper llist APIs over time to complete the conversion. I am sorry
> that I can't spend that much time upfront for this conversion effort.

I see. Oh well, thanks for taking a look.

-- 
tejun
