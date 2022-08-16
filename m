From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 5/9] blk-throttle: improve handling of re-entered bio
 for bps limit
Date: Tue, 16 Aug 2022 10:02:24 -1000
Message-ID: <Yvv30FjQMcLnC+aB@slm.duckdns.org>
References: <20220802140415.2960284-1-yukuai1@huaweicloud.com>
 <20220802140415.2960284-6-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=O9E2tV5Eqs8B8X15RAsfJgS9BzNTXZL8afuu3Y2YeCQ=;
        b=VdvdhuNgrENNkEhNdbQw5mkcYIDKMm6VZZaymqscCs3nYQeDbAeEYrugm2EjVWv7JE
         0G3Wwz8I348ukIAY2KsK0JBYB29l4gr8tFHK8cgpCxz8mzj1YrrVaqF+8SU+J3JL5D6d
         uxKSrGLmjm4m139pZoUo+RJD2jQQGrz0AC6hfZH4KVrKWXkIaC6Pnu3OwEYlg52ZddEF
         ZwFUmMmE9Glr6kwNxSqJPx1WbYNnzzE8sDSMZRjMWoT9vCRsYQvfa4VoTtsdsrzKvEoe
         dHLUE0doTB27/OExjwPqW8rFoQ0aBxOOJH4Xdo3RIV6jI5krIPgjDC8C6Ly5DQ7O91Nn
         EQmw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220802140415.2960284-6-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: mkoutny-IBi9RG/b67k@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Tue, Aug 02, 2022 at 10:04:11PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> Currently, if new slice is started while bio is re-entered, such bio
> will count multiple times for bps limit. Since 'bytes_skipped'
> represents how many bytes will be skipped while dispatching bios, which
> can handle that case, increasing it instead of decreasing 'bytes_disp'.

The same thing. I think we're working around the problem in the wrong place.

Thanks.

-- 
tejun
