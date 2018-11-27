From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 01/13] blkcg: fix ref count issue with bio_blkcg() using
 task_css
Date: Tue, 27 Nov 2018 15:54:29 -0500
Message-ID: <20181127205427.v2x7ezd6jgkxg562@macbook-pro-91.dhcp.thefacebook.com>
References: <20181126211946.77067-1-dennis@kernel.org>
 <20181126211946.77067-2-dennis@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bqyE1nmXeAtPZbB2AL1Q4bwPXAN2rTBpblfeBKlhVg4=;
        b=KgSSMt4L+4tqXR2s+UHTYAZflYlIuedUbXzViNuZYxBCrGfB2P6tWYKhhL9LqkWnIY
         uIWLGg625SPIus4yfa8vQ4Rn0berTLnGHGJa0iC2cJa1eD73Mt8pBBGxNhs12Ms1ggKI
         uksj6n+fKLc9mFWtfr5/rf0CwViWF9qHyxCrZ5RORsfJAT+ehnebXCrGtBK2naK75PTa
         ZR/Etd+hEl93Th/ytTmMiCidhAapEKabckiaf41BfTMzQlwxwJd5YIaSy8qZoovKLOD6
         z3SMMTiPewSfzgbh5hyY0w6FVDCe/+tBO5ZYPm47xWSCJszcmh28uTamHa22akWBpx2D
         BYuw==
Content-Disposition: inline
In-Reply-To: <20181126211946.77067-2-dennis@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennis@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Nov 26, 2018 at 04:19:34PM -0500, Dennis Zhou wrote:
> The bio_blkcg() function turns out to be inconsistent and consequently
> dangerous to use. The first part returns a blkcg where a reference is
> owned by the bio meaning it does not need to be rcu protected. However,
> the third case, the last line, is problematic:
> 
> 	return css_to_blkcg(task_css(current, io_cgrp_id));
> 
> This can race against task migration and the cgroup dying. It is also
> semantically different as it must be called rcu protected and is
> susceptible to failure when trying to get a reference to it.
> 
> This patch adds association ahead of calling bio_blkcg() rather than
> after. This makes association a required and explicit step along the
> code paths for calling bio_blkcg(). In blk-iolatency, association is
> moved above the bio_blkcg() call to ensure it will not return %NULL.
> 
> BFQ uses the old bio_blkcg() function, but I do not want to address it
> in this series due to the complexity. I have created a private version
> documenting the inconsistency and noting not to use it.
> 
> Signed-off-by: Dennis Zhou <dennis@kernel.org>
> Acked-by: Tejun Heo <tj@kernel.org>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
