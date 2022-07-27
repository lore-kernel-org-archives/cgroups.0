From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RESEND v6 7/8] blk-throttle: cleanup tg_update_disptime()
Date: Wed, 27 Jul 2022 08:42:54 -1000
Message-ID: <YuGHLlBw55lBx1IE@slm.duckdns.org>
References: <20220701093441.885741-1-yukuai1@huaweicloud.com>
 <20220701093441.885741-8-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=AmYRhi+bYnf/7wctVUfLsHYE6jk09n50bYSccxZQAcE=;
        b=OE3lt+DEngtZX5hQ1eQWQNZKJeRw2G3yBic79b6g6GTefs4pdXaH7cEN+ijBdjD9zG
         /DD2kp1I7c3OL1lehoNgpPpnlO2WCkmE/pRAF6ll7AjOt8mvKRBsQpXZSxf3gapp/NkN
         Vsi9i2dgzbTa//cH7XWoyBsPNK2xx3j3Xjm9nJ2FozUM3g5smsguvTrtSbsWz6uHFi/o
         2Q33sLUGcoS9Ooet2vT8Ny6vsIheqGO10LTdnNsS7aqOKqIzRhKgkphgPxDYnsukm8ju
         90JnyDICSD2NEQx+oO8qtwkAiRCI/LNB9sFz+1D2vmtl2oIQoKHJGxyTwSchmNZsNtjb
         F6jQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220701093441.885741-8-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: mkoutny-IBi9RG/b67k@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Fri, Jul 01, 2022 at 05:34:40PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> th_update_disptime() only need to adjust postion for 'tg' in
  ^                         ^
  tg                        needs

> 'parent_sq', there is no need to call throtl_enqueue/dequeue_tg().

What are we gaining / losing by changing this? Why is this better?

Thanks.

-- 
tejun
