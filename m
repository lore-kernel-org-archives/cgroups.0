From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 07/15] blkcg: consolidate bio_issue_init and blkg
 association
Date: Fri, 31 Aug 2018 16:45:14 -0700
Message-ID: <20180831234514.GE1488037@devbig004.ftw2.facebook.com>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
 <20180831015356.69796-8-dennisszhou@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zvFghNppYyZBqHCLnWMPO4VCWSZqUB1Oh/HejIwRyhg=;
        b=QWBhN5TAIxBr0QMhHHAeehcxrNYbYXO2jLGzf53oCTvWwQi+uW2LyMELp/GphZIbf+
         newm4DkacPYykCLTo0E5Irx+ADWlHewboIBPvHv9XgUEYbeMEEFq4f0CQXGhoSunSwGT
         EP8l3ab3oUfBP2d1EHCDPGsZn43FwvJUEUW9wlP7nxVUgfxF/OlNzL6LRSzBDPpHCZmt
         q46osqkPGTRTuMOdEj7Z8mJ+rP4VC2PVk58p8TSOBIkECBIv9IXJGBlJ+C+b/YcLqsb/
         MV7bvKJhS8uGZY/oBkSKsWxZsG5lVIOKav9rL8h6YhdoyaOfqIXOXl/JiOXNCrhXA/NJ
         DnXg==
Content-Disposition: inline
In-Reply-To: <20180831015356.69796-8-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennisszhou@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Aug 30, 2018 at 09:53:48PM -0400, Dennis Zhou wrote:
> From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>
> 
> This removes the now duplicate association logic in blk-throttle and
> blk-iolatency. bio_issue_init is moved into blkcg_bio_issue_check and
> into the bio clone variants to allow for the future addition of a
> latency moving average for IOs.
> 
> Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>

I don't have strong feelings about where the removal goes, so please
feel free to reorganize patches per Josef's suggestion.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
