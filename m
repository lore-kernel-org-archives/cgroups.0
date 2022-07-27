From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RESEND v6 2/8] blk-throttle: prevent overflow while
 calculating wait time
Date: Wed, 27 Jul 2022 08:28:38 -1000
Message-ID: <YuGD1s2TJ9euYpCv@slm.duckdns.org>
References: <20220701093441.885741-1-yukuai1@huaweicloud.com>
 <20220701093441.885741-3-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=Rr2DmdH/Yw7QfWPKMwga2AxXi65vqNRwg8R5+haMBnY=;
        b=RliP9yXWD5CA9bljnE2oiVxs9BJAxE9TKXJCXAXuaE6qP14dhUHkl97uK3BdsKC6Wu
         XY5b23DHu/JtYErCI6ZXaU/2hJCMlb0yNyib9sD417uZ3FtLx17W4FRkkUmT/FjLzfSP
         Ts8R0vQSQcJvBj0Wq11eQqdWGb3fHRbbMnGyninuRlUNg23k7gX49OPL/+O0/g1Iy8Rm
         yk+FhOE0II5xBWvTIdSNL4V5U8SLo+FmytbcpdiVSjF5NNWJd8Q2e/7n3f/U6BiF1dn3
         Msf+k/AiaqpGJHf/pBx4q5TxzXLg3TwiGnTfPMlUCua1RExTi0MI4CMUQXGU+lSbjylp
         aI0A==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220701093441.885741-3-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: mkoutny-IBi9RG/b67k@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Fri, Jul 01, 2022 at 05:34:35PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> In tg_with_in_bps_limit(), 'bps_limit * jiffy_elapsed_rnd' might
> overflow. FIx the problem by calling mul_u64_u64_div_u64() instead.
> 
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

BTW, have you observed this happening or is it from just reviewing the code?

Thanks.

-- 
tejun
