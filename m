From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] blk-throttle: export io_serviced_recursive,
 io_service_bytes_recursive
Date: Mon, 11 Dec 2017 07:17:05 -0800
Message-ID: <20171211151705.GG2421075@devbig577.frc2.facebook.com>
References: <20171211145621.GA2115@localhost.didichuxing.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XLn9G+oNjSkuWSao9zckSNns9dUIb/XHIha9E55mfUQ=;
        b=bPktPA28avUSV1aLtr2Ro62S3bYNo7ir+1xO/dkBvDQKmFo84BWVmyYimXI8G5qCCp
         WOP7lY87yhaInbiQfJuBuQ7LemZQAEEe1gDovyt+hvJYSQiHU7YJQmdbDJ5PMd4kW9oc
         6rnQ0hJZ4ugb6kyqb78nemE9+b8tE1NZ5y5u6jsgaFTF8l8b2teZUrk4a6GN0NIdrCyn
         OCboESkhZue8LRQAh9P8G9BidEETlZPnub6VCj9KxDQA/GlWPAlTY6lfDxgBZrJWbfMc
         zy8YLZynxzahOfRbxo6xzCUx5/D1ejOvRw0KJk+fEKH5nhNOlrjhoXvJGzITK1AADmdQ
         M4vA==
Content-Disposition: inline
In-Reply-To: <20171211145621.GA2115-bi+AKbBUZKZw6VQDmTdmGHWcxnUbehklAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Dec 11, 2017 at 10:56:25PM +0800, weiping zhang wrote:
> export these two interface for cgroup-v1.
> 
> Signed-off-by: weiping zhang <zhangweiping-j11cvHKnkmPwvR0lvYjcXw@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
