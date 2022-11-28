From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] blk-iocost: fix shift-out-of-bounds in iocg_hick_delay()
Date: Mon, 28 Nov 2022 07:09:01 -1000
Message-ID: <Y4TrLfOj5sTpXyYR@slm.duckdns.org>
References: <20221126121458.3564942-1-lijinlin3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sznbp6Qjro/lU0fK9+7muhZjge7QWHgQWbjlTiDXzkc=;
        b=a8tTbIcUy2a41TN780C+9J4rBtuAeFTi8gr72QkA0d2fcO8Uwmb6U5OzC3NKdEHsLY
         l2esfexl6uRmQ4ljLpk/ffd0/3DnPY0ik2CPQ9EMfuJCyAmXMrFvJucmchwO+xb3rogv
         ChfoJNtPJVUpaHKP6H3h1Fazd2xWQl+8i0ufLrwSla/QEQbBRXcagCCFTLZwLtwG/vNi
         cS3cSVvO/muC82MOR1B3Ggp1gpjpqH59zMn3yiI+cH1TDFw8WqmR4vC150oMsGUIUunV
         vvT5BSl1bNkGqr2SyZVnOcIaVC59T3osws9U30UgVXRHsDQWjghnfNgIzj3HmDMFyQhS
         pKyg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221126121458.3564942-1-lijinlin3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Jinlin <lijinlin3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liuzhiqiang26-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Sat, Nov 26, 2022 at 08:14:58PM +0800, Li Jinlin wrote:
>  	if (iocg->delay)
> -		delay = iocg->delay >> div64_u64(tdelta, USEC_PER_SEC);
> +		delay = iocg->delay >> min(div64_u64(tdelta, USEC_PER_SEC), 63);

Let's just set delay to 0 if the shift is too big.

Thanks.

-- 
tejun
