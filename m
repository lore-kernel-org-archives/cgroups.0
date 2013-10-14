From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] blk-throttle: simplify logic by token bucket algorithm
Date: Mon, 14 Oct 2013 09:36:20 -0400
Message-ID: <20131014133620.GF4722@htj.dyndns.org>
References: <1381574794-7639-1-git-send-email-zhiguohong@tencent.com>
 <1381741757-20888-1-git-send-email-zhiguohong@tencent.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=xB/q7iOyBp3wTu/iTVH2rKhTa7/m+fel0pehSu47CfE=;
        b=TmZej0XSBGWpDRPaiJ5PrrsmgekqNugfGYgqKPC/AXQlCgQf8+gaTVx9kc2qPbeylc
         l31TRCReslZEOVkDNlM52poor5J53CjdqBNYbzwCjygoDoqQLv5wIv/RaGSktudeB9D+
         4vTP1rHTtPDJomgC+hLoBVpnusB9M58KEkwXK6mueSOVTLgBqapJQ/V0i2eQrgx/wJFf
         4KviUFxvlyWpMmn2KQbLgTEUb+oQ5cDpml5auhEQZDnEtRbQxQ9uny+4VBLhAzJ2MB2S
         x5tpnu49ttWGId4yt4zcWMRPskqKXy1WGZsOp0XlUZomgICjKCkMO8N04gewnOvaqmrl
         D3DA==
Content-Disposition: inline
In-Reply-To: <1381741757-20888-1-git-send-email-zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hong Zhiguo <honkiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Hello,

On Mon, Oct 14, 2013 at 05:09:17PM +0800, Hong Zhiguo wrote:
> From: Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
> 
> Token bucket algorithm(http://en.wikipedia.org/wiki/Token_bucket)
> is very simple and widely used for rate limiting and shaping.
> It's well suitable for blk-throttle. And it natually works for
> hierarchical cgroups. So I took it to replace the original time
> _slicing_|_trimming_|_extending_ logic.
> 
> The advantage is simplicity, reliability and less fluctuation.
> 
> About 300 lines of code for time-slicing is replaced with 60 lines of
> code for token bucket in blk-throttle.c.
> 
> I've tested this patch by fio with rw=randread, rw=randrw. It
> behaves almost the same with original time-slicing implementation,
> and with more accuracy.

Yes, this definitely is the direction we wanna take it.  I'll wait for
Vivek to chime in but have you also tested hierarchical setup?

Thanks.

-- 
tejun
