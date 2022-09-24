From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] iocost_monitor: reorder BlkgIterator
Date: Fri, 23 Sep 2022 16:57:42 -1000
Message-ID: <Yy5yJsSbrcqkQzth@slm.duckdns.org>
References: <182ef30785e.c6f6f47035469.3423320276766255135@elijahpepe.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=Yhr2nrFZk+vd4PavOKiv8NZwpQ0tV9+eXmyqSocKfSs=;
        b=eX0Fjows/Ll90CuZs1R+ARoXMetbxE5UzpodleCQWJ9uAJt6W6kBsdzOTTYm0GenQu
         ffWiiLRJYzYv1w3Z3YqEfkNbBcSDQYWnkU/7BfHxp8TCELFADqY0PxMsTcXg/h+YIK+Y
         LkLH5hqNgFMSFNXbUzuJXwBmpdWbJEmY5T1orZmcLQ0jh8Qww3v3N0sjxCOjOrolFbyn
         7mI7538h4siKdt20Dti9nqDHIns/uPNv9rMIOh3/y3Q3aqxFzjtrqwQIimI1GP3Dw5Gt
         2GOxkxN6fsML5iwinYyT7dJgxg+ody/UTlDLIbxUzeZsMeKL4ZlRkeQjGKT+1Qx4ymWb
         tsXg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <182ef30785e.c6f6f47035469.3423320276766255135-a+BPLuE9hVQK94dJeoFgHg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Elijah Conners <business-a+BPLuE9hVQK94dJeoFgHg@public.gmane.org>
Cc: axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-block <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, josef <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, asmlsilence <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, minglei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, bvanassche <bvanassche-HInyCGIudOg@public.gmane.org>

On Tue, Aug 30, 2022 at 07:38:27AM -0700, Elijah Conners wrote:
> In order to comply with PEP 8, the first parameter of a class should be
> __init__.
> 
> Signed-off-by: Elijah Conners <business-a+BPLuE9hVQK94dJeoFgHg@public.gmane.org> 

Applied to cgroup/for-6.1.

Thanks.

-- 
tejun
