From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v8 1/4] blk-throttle: fix that io throttle can only work
 for single bio
Date: Tue, 23 Aug 2022 08:07:08 -1000
Message-ID: <YwUXTL+8E/sPcEUB@slm.duckdns.org>
References: <20220823033130.874230-1-yukuai1@huaweicloud.com>
 <20220823033130.874230-2-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=zqj2sHtRyt3qxfs3B7KcWKedNnq53nEnQHSpLAsV5AQ=;
        b=cJx/f09Zo9shX7oJ81DbWCVKNwNypWdpkByQ67wp/tSrJdnjfTAp3sA7R2zQGA0v01
         eHYrj1LLyjvtpknIhIPVmqSBr/aRYZjERTqa3o7ZOMPAA8uR3aEEhQSrZIjXvS5UTx5A
         jDNQxJGfdlMwdKwheEB0XqTYFu6dgfp11ABsVuNDgCjj9TqRNfDa1Aqcyndh/BHRRKn2
         gqA+gtzhHp3CaQQOFdRKV46CFJZmd6C1sQb5s771PRbnKTSm/TMWocadgM/dpOsKAGak
         Xxl9KDGOALF/6MnaeYhCijrtzKBix/K/jlBIrzKwbm9qt98DSWf6kzNYKGF6AXv3D6+a
         +dhQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220823033130.874230-2-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Hello,

Should have asked you earlier but with the BIO_THROTTLED flag setting from
clone removed, with single BIO_THROTTLED flag, does the fix still require
bytes subtraction? If we can do single flag and we don't need the bytes
subtraction, might as well just stay with single flag?

Thanks.

-- 
tejun
