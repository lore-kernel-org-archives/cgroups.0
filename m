From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: Zero sized write should be no-op
Date: Wed, 30 Sep 2020 13:52:37 -0400
Message-ID: <20200930175237.GH4441@mtj.duckdns.org>
References: <20200930163435.GB304403@tuxera.com>
 <20200930164242.332249-1-jouni.roivas@tuxera.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GCAh8TaPpWaB6i2tYN+N4CwVQbHEcbrNvzTWfAuRh9w=;
        b=SmnTN5JLJdnYnVJlUAHKELGi4p1DcSzStBRPB8fdE8xH8WGwAGAhuUoZihOOE9+pL9
         3vNIfAS5q1AP7H/8g79G3wKBlIV89ZKJGX/eEeB1Q3P9673YFvfutRbzF1C9ybLlnfLt
         HjifyZx8YP1h3stPia1BTVeCzuljidNXSw1kfKrGjhTsHtjaoPy1gl+N2gf3KlpQ7H8D
         Rlsy8p7DJnDBjsH3z1qQg0IdgE2+4SSCnERuPjgQa1T6M/ik/23/3GBFS7wQ4r9qdkmQ
         7Df0RgkQghrC85auaOsiVSFxTt6Eu8SQ4eCC+NRC07Ker0YoC+CdfOwwtVoavhwXeNz0
         oxrg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200930164242.332249-1-jouni.roivas-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jouni Roivas <jouni.roivas-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Sep 30, 2020 at 07:42:42PM +0300, Jouni Roivas wrote:
> Do not report failure on zero sized writes, and handle them as no-op.
> 
> There's issues for example in case of writev() when there's iovec
> containing zero buffer as a first one. It's expected writev() on below
> example to successfully perform the write to specified writable cgroup
> file expecting integer value, and to return 2. For now it's returning
> value -1, and skipping the write:
> 
> 	int writetest(int fd) {
> 	  const char *buf1 = "";
> 	  const char *buf2 = "1\n";
>           struct iovec iov[2] = {
>                 { .iov_base = (void*)buf1, .iov_len = 0 },
>                 { .iov_base = (void*)buf2, .iov_len = 2 }
>           };
> 	  return writev(fd, iov, 2);
> 	}
> 
> This patch fixes the issue by checking if there's nothing to write,
> and handling the write as no-op by just returning 0.

Applied to cgroup/for-5.10.

Thanks.

-- 
tejun
