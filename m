From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH] blk-iocost: skip empty flush bio in iocost
Date: Thu, 20 Jul 2023 14:02:28 -0600
Message-ID: <168988334811.126089.11961578901520630861.b4-ty@kernel.dk>
References: <20230720121441.1408522-1-chengming.zhou@linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689883349; x=1690488149;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lm9L8OGKEHZdmU9hnM3GKjbpRPyEmtA8o0crHfCp3hU=;
        b=4LjnEBByBbYMg48CJm/WiUWl6CGT7KLK3x1yg9e74apbaaiCjJKsG0LP+pH+C5XbpD
         1aQURjA7F3xiTiJ6/Wt0zs00qVbFZzPBiuuQig0lbZf2eHNKjrWr6awACXx6C43Croe4
         8Cndlkg1wBerLxo6OEWgL7fBwSPsEnlO7Uj4SkhGi5ts9s2VHSn3XzZlR2DawlFgCJyt
         g5l4ytQnFqyZdqCSAC3YUl9X6ZKXdCCbcG4PvXmalUn1qRda/jPe5oBVuIXPyeD1fMKF
         +DlQmLCX9ZNogRTJHsBHSvlrqF02hiYaPoPUX3auskDSRlzsITpO6mzsEkIKviViU/tx
         3Rqg==
In-Reply-To: <20230720121441.1408522-1-chengming.zhou-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, chengming.zhou-fxUVXftIFDnyG1zEObXtfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org


On Thu, 20 Jul 2023 20:14:41 +0800, chengming.zhou-fxUVXftIFDnyG1zEObXtfA@public.gmane.org wrote:
> The flush bio may have data, may have no data (empty flush), we couldn't
> calculate cost for empty flush bio. So we'd better just skip it for now.
> 
> Another side effect is that empty flush bio's bio_end_sector() is 0, cause
> iocg->cursor reset to 0, may break the cost calculation of other bios.
> 
> This isn't good enough, since flush bio still consume the device bandwidth,
> but flush request is special, can be merged randomly in the flush state
> machine, we don't know how to calculate cost for it for now.
> 
> [...]

Applied, thanks!

[1/1] blk-iocost: skip empty flush bio in iocost
      commit: 013adcbef165c3eaf73e297b7482290593815ab8

Best regards,
-- 
Jens Axboe



