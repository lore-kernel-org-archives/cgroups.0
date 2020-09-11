From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH block/for-next] blk-iocost: fix divide-by-zero in
 transfer_surpluses()
Date: Fri, 11 Sep 2020 11:10:58 -0600
Message-ID: <ff46ca79-433e-3279-a8eb-35156639be7b@kernel.dk>
References: <20200911170746.GG4295@mtj.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PjaHcTfFjzbLCw68IPxqcyo+o8vTrqFIU4LrLdQ6i4E=;
        b=dtr8rc1TFTdhuQX1JX6cpdjp7g5dPXot326EizN5cMg4FGGWCBF3SujtkOjH2g9AU8
         VYooSex5NOHLaQmydJQvGP2ciPTbamrxy8e63sgmRcld3qe9CBysCiE7nkIJAWTrWWzD
         5cPZyRl9Z1CgPdcCfFgCs0umR5vPyTmNsQ7ARuMaYYHRDmzXZ+nTUkdmdtXeWtLd5x6F
         HZeOjxlKX3IAgX2SHg4n37ycDB7odU4BCn88ZKZVTPuVXZ6SEHZ4H2WFRV979A/Iqjwg
         f8eUotxsYrCJSPi9GeB9lCE1tcTM+Wow6b+ZMYQyvCDgYzOgnphaaEjqYJOXrGsWBVEa
         ZVMw==
In-Reply-To: <20200911170746.GG4295-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 9/11/20 11:07 AM, Tejun Heo wrote:
> Conceptually, root_iocg->hweight_donating must be less than WEIGHT_ONE but
> all hweight calculations round up and thus it may end up >= WEIGHT_ONE
> triggering divide-by-zero and other issues. Bound the value to avoid
> surprises.

Applied, thanks.

-- 
Jens Axboe

