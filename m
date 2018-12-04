From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 07/14] blkcg: consolidate bio_issue_init() to be a part
 of core
Date: Tue, 4 Dec 2018 14:50:01 -0500
Message-ID: <20181204195000.gwhgdqa7ouaf73sp@MacBook-Pro-91.local>
References: <20181204183600.99746-1-dennis@kernel.org>
 <20181204183600.99746-8-dennis@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Q+ueYi+brXN7pPHAwUWTDfeiGp090xsVy/6F9O9E86E=;
        b=rdLIjCGjf0tAo/Mp4Kny0fqVkOhTxceoBFcGu715eAhPc4QSjcfOFbregjVvWysA4g
         OFhq2Kv5A3/fmL4WiVdxFam0H7sVbVUAjSBO1+VMItULxS2Oktve08quU8YU/EihF51c
         5vgqcqxmcxz6IFcwYbXNsHU+wm7gE3eRAmq2SFrSGkMb8WuaCebEB2U8Zcbr8mnCEwUE
         EEOWpScyOeFpUwmblq6k0XKhLKQmbCex2t6S12OZmI+69rF6s9BJZWsN4xJx+EZ7LZ3p
         N4toDwckwREJGuOA9MC8sbywTn6WDBGdVYqKvK3HRA364Bp4ojsAajuBQTrhM5c8awp8
         bZkA==
Content-Disposition: inline
In-Reply-To: <20181204183600.99746-8-dennis@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennis@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Dec 04, 2018 at 01:35:53PM -0500, Dennis Zhou wrote:
> bio_issue_init among other things initializes the timestamp for an IO.
> Rather than have this logic handled by policies, this consolidates it to
> be on the init paths (normal, clone, bounce clone).
> 
> Signed-off-by: Dennis Zhou <dennis@kernel.org>
> Acked-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>
> ---

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
