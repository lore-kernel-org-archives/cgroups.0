From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 09/15] blkcg: associate writeback bios with a blkg
Date: Fri, 31 Aug 2018 11:45:29 -0400
Message-ID: <20180831154528.y4x67cr7lr5bi4bf@destiny>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
 <20180831015356.69796-10-dennisszhou@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nuFNt6MCancQNI3iR/De5cCHy3/7r6A9CMgcd5Jtrpg=;
        b=Ned2hdW+c4ekVJhYUok8ynF4fmDNMaboUbzphHYLRJTD6CN6CxdJClw6Iy1QMnKwXV
         jTKG3rfbDqvYA/Go+t7E4pLVzkWixFGtuQ6sPZS1zSrXnF4K+rRlObqzqL1uAhLJJYUO
         xSlnQZYtyuDPFevh8bQf/iu9bHHl1WVsfzqioOCtMotEcUNFN1JDyPu5sPfbvFSHHqMp
         aGYW2T6vugkXBZ25eqmLEvdFUxpYrKgKZP4stdmbY4MWbviYV3sC9SecSJ151RB2Zmdc
         wJJ/0X3Ws2qBup1WR8kgl6Lx2+O+zz4JxIt3luRPJOtwTGUCr0dTmhSFnQC9Dikq77JH
         tg1Q==
Content-Disposition: inline
In-Reply-To: <20180831015356.69796-10-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennisszhou@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Aug 30, 2018 at 09:53:50PM -0400, Dennis Zhou wrote:
> From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>
> 
> One of the goals of this series is to remove a separate reference to
> the css of the bio. This can and should be accessed via bio_blkcg. In
> this patch, the wbc_init_bio call is changed such that it must be called
> after a queue has been associated with the bio.
> 
> Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
