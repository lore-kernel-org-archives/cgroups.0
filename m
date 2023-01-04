From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 1/5] blk-iocost: check return value of match_u64()
Date: Wed, 4 Jan 2023 11:48:17 -1000
Message-ID: <Y7X0IT27kPap4tFi@slm.duckdns.org>
References: <20221226085859.2701195-1-yukuai1@huaweicloud.com>
 <20221226085859.2701195-2-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yrCi/Pft2qxPLFB1xPtkzEGdXf77jJ8rZEUSTd/viPw=;
        b=DmTDoakfnRqv676B+kjCUKyufhaCbCkmNiys62I7CNdzzMY12YgPxOgMSxKsZrUb1A
         qxmcP8kEWRZdvKxNFoz8BoN5oUdu2Ig90TdQjOzgwapkQa+rMk3Jte/oYHZX4UdDZYft
         rfD9/heLa+bmWdwiadsCSV5JtE2WuHKIkZqelGQuQ0dbVOltGdg/CEEnaj3BJ6GuDIKK
         V7mkaqGzPse11DjNHB1+ReyY6d+dCgriktFfRkxfc7L77V1L1YhC0jEfTMjsJe6frz8N
         m3jD7+/1umkw8ZeaaitWMt0JuA+ODfgSqbj826YcKjId/ByyFSa1Dv3XnZOJIOSG+6DV
         8S1Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221226085859.2701195-2-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Mon, Dec 26, 2022 at 04:58:55PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> This patch fixs that the return value of match_u64() from ioc_qos_write()
> is not checked,
> 
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
