From: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/5] block: add request->io_data_len
Date: Thu, 9 Apr 2020 10:38:57 +0800
Message-ID: <20200409023857.GB370295@localhost.localdomain>
References: <20200408201450.3959560-1-tj@kernel.org>
 <20200408201450.3959560-3-tj@kernel.org>
 <20200409014406.GA370295@localhost.localdomain>
 <20200409021119.GJ162390@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586399955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HR+51ncLat+TViGePt1EzZ9/+c+0ffiOCieXE52eEnw=;
        b=f8NO9WvipJyNIkkhrJ1ASjOXLcmeZ/L+5qyCrVkWrOgVmjRoOLP4X0CuL/Rc5UjMgb3tOE
        uaiV+L0o7zOuV4lsfJLAM6H5uJob1YwzsXyfUNsYWifr5WmS/dZduZyjp4sppeJOFAQ7nP
        GEGoaC0NthSH/R8H1X+82ZhrZ0+ajaQ=
Content-Disposition: inline
In-Reply-To: <20200409021119.GJ162390-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, newella-b10kYP2dOMg@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org

On Wed, Apr 08, 2020 at 10:11:19PM -0400, Tejun Heo wrote:
> On Thu, Apr 09, 2020 at 09:44:06AM +0800, Ming Lei wrote:
> > Almost all __blk_mq_end_request() follow blk_update_request(), so the
> > completed bytes can be passed to __blk_mq_end_request(), then we can
> > avoid to introduce this field.
> 
> But on some drivers blk_update_request() may be called multiple times before
> __blk_mq_end_request() is called and what's needed here is the total number of
> bytes in the whole request, not just in the final completion.

OK.

Another choice might be to record request bytes in rq's payload
when calling .queue_rq() only for these drivers.

> 
> > Also there is just 20 callers of __blk_mq_end_request(), looks this kind
> > of change shouldn't be too big.
> 
> This would work iff we get rid of partial completions and if we get rid of
> partial completions, we might as well stop exposing blk_update_request() and
> __blk_mq_end_request().

Indeed, we can store the completed bytes in request payload, so looks killing
partial completion shouldn't be too hard.

Thanks,
Ming

