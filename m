From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/6] blkcg: move io_service_bytes and io_serviced stats
 into blkcg_gq
Date: Fri, 26 Jun 2015 12:09:23 -0400
Message-ID: <20150626160923.GI15805@mtj.duckdns.org>
References: <1435268337-1738-1-git-send-email-tj@kernel.org>
 <1435268337-1738-6-git-send-email-tj@kernel.org>
 <20150626160142.GA24554@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ruPf6yxVyK0UpFLjZ8EdoRr/4UJW/hx4WfIdmY7amQY=;
        b=zhfBpaet2L04WM2Yrypm7arAqL6+2fBapQG7jZD+XTcvCAumf03KAsRk7YZOp3rZJX
         aR0S5jrB2NwM+d4hG+SqBzAFSxALVo2A2t6Vd2sclO+YyJOVdkf9AH8LYCbGu9FqHGBQ
         KP+6fFXCa1dmUQaSsCUxMPlxrBC8PJ2yn1X+WzGnesUYCkjiY+Nf8gziE/jot/r+zGkR
         q7+owHYIb7tQltYpy5NZ7rY3ph8LQLZraQykKoue4641BQ4Xs5qxmgEAWHd99koM/BUa
         tsT9p3fxSsBvGUGZ1lyU6P5caYgufMJCS5brTN8FH7JzPBWp5JbRQkwG31vUcEKxGsLA
         an8w==
Content-Disposition: inline
In-Reply-To: <20150626160142.GA24554-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello, Vivek.

On Fri, Jun 26, 2015 at 12:01:42PM -0400, Vivek Goyal wrote:
> - Previously throttling policy was calculating number of IOs in terms of
>   number of bios while CFQ was calculating it in terms of number of
>   requests. I think this will be a behavior change now? IIUC, now even
>   throttling policy will report number of requests and number of bios.

Yes, it'd be.  I'll mention it in the description.  The thing is this
has never been documented or explained properly.  The only thing
userland saw would be the counts deviating over time.  I don't think
putting them on the same measure is gonna break anything.

> - Looks like completion and stat is now lined to request. I am wondering
>   what will happen to bio based targets. One can put a throttling policy
>   on any of the stacked dm devices. I suspect we will be broken there?

Dang, I forgot about bio based drivers.  I don't care whether it
counts bios or requests.  The only thing I want is counting the same
thing once instead of separately in subtly different ways.  I'll
converge them to bios.

> - Can you please also update the blkio-controller.txt. Specifically
>   blkio.throttle.io_serviced.

Sure, will do.

Thanks.

-- 
tejun
