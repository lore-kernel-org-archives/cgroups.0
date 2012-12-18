From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 09/12] cfq-iosched: enable full blkcg hierarchy support
Date: Tue, 18 Dec 2012 11:17:56 -0800
Message-ID: <20121218191756.GP1844@htj.dyndns.org>
References: <1355524885-22719-1-git-send-email-tj@kernel.org>
 <1355524885-22719-10-git-send-email-tj@kernel.org>
 <20121218184022.GC24050@redhat.com>
 <20121218191055.GN1844@htj.dyndns.org>
 <20121218191645.GA25908@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=mQBAhZGzJRFI5gyxcmnLA3YAYALHg/8fNnldslkrHoE=;
        b=WLOM22WRUjzWOz/kiFO3s7ulS9qnT6mQvM5ksHPEg8z0k/fo5uFVwsQKVc4RYoo11g
         mukAf9oiFLeZobF0IXTpeg9B/Rxg5wbBwFUo6CJ4bLJk0AqLPq9z+WW7XccROYutO0vP
         06GFGv1D8cnw7nhvjpCoYP1jZZJdgvzF+joe8x3dVHRQIJ9VyklGzInrTAVuUxeAcKJ+
         x7zs0TikkrKBT7RjDd9TqP425NHVnbKjGetpQumgtzar2zrzGg6d0tLpCdI8YHcU4NOF
         2Y/TKxlTk9ASQ1f8kqsrRJHJ8+2c0useucAFDPn9PNIWZ+iopOLrv7e4Hq9dnNAdwPDz
         jsYA==
Content-Disposition: inline
In-Reply-To: <20121218191645.GA25908-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

Hey,

On Tue, Dec 18, 2012 at 02:16:45PM -0500, Vivek Goyal wrote:
> > Yeah, sure thing.  Other than documentation / field names, do things
> > look okay to you?  If so, I'll post updated round once -rc1 happens.
> 
> Yes, in general things look good to me with this patch.

Cool.

> /me is wondering how to get a response from cpu controller folks.

Well, I pinged Peter last time about it and didn't get any response.
Prolly best to ping w/ patch.

Thanks.

-- 
tejun
