From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] misc_cgroup: use a counter to count the number of
 failures
Date: Fri, 13 Aug 2021 06:16:45 -1000
Message-ID: <YRaa7R6niNQMpqZm@mtj.duckdns.org>
References: <1628832371-16382-1-git-send-email-brookxu.cn@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JeOfnYXXUD0uawQ0bVzU2z5A2fd7nhB1MsbBkE12QoU=;
        b=V7sQT4KCgtnVpRX90o4X/FqgPaiKH4o6jvDypjFYfwZyXYnhyjnUb9+Vr2WelHEk5j
         vKp0QRk2LjsafSp8wmQnVcd8Jr+SLzWSIpm6D3zG7wHIY/2QhFG+hcMKN9Oo7cMohrQ3
         4VDmKxdS+hvcvZaD4CqmrMUkFnc0G1D2uv1dimHQxWaZhfckfKU6bgwFI0vppyBb2Rov
         EM9/BZvvM9mQdaGuHaGQiWojIjIQOhUAkPHecWSjpnLOvOOJYgGizkAkDKs4lPCSzcIl
         w3KLTLRQiWy2NcYDeRgvVG5JOstQQEuwPwpXB2oPZ59inEn7N1OKKfx6ibt+J1XyLfH8
         gJmw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1628832371-16382-1-git-send-email-brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Fri, Aug 13, 2021 at 01:26:11PM +0800, brookxu wrote:
> From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
> 
> For a container, we only print an error log when the resource
> charge fails. There may be some problems here:
> 
> 1. If a large number of containers are created and deleted,
>    there will be a lot of error logs.
> 2. According to an error log, we cannot better understand
>    the actual pressure of resources.
> 
> Therefore, perhaps we should use a failcnt counter to count
> the number of failures, so that we can easily understand the
> actual pressure of resources and avoid too many error log..
> 
> This is a partial patch of the previous serial, which may
> be useful, so I resend it.

I think this approach is fine but can you please

* Cc the original author of the misc cgroup who added the warning
  messages.

* Rename failcnt to nr_fails?

Thanks.

-- 
tejun
