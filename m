From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v5 2/3] blk-cgroup: Return -ENOMEM directly in
 blkcg_css_alloc() error path
Date: Thu, 2 Jun 2022 06:16:32 -1000
Message-ID: <YpjiYPscJst5iuyv@slm.duckdns.org>
References: <20220601211824.89626-1-longman@redhat.com>
 <20220602133543.128088-3-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uGG9vxabvHTNIKzZz4iCB8IKnMzQr1VCGtUnhFb1+UY=;
        b=RCEMSbNiZBiU/AiNlb77dfvjT/7kyqYVv2/vI278NdBW4V5QnJkaMZOOSnD0B82vh7
         RBtEmAQrWCym5AO3j+nOEPyxoI487W4vGEIC+qUbl5IX3Los948Cskn1r93l52PPl9tC
         LajBg3fsnB01Fw8f1nsVonEumyh6ZNngCUphOzXcf7z0uzABuA+Hab2If8PPLGrMGog7
         +h3fzv84WGstiX+3v9E2xyaDrSuQjkUOHb7O4vA4PB1A2ex+3S9IKDUDb5Gfx/9jgzP8
         5bmLeLFeUN5LYOb39BohI1QwFmn6iJiGDo5MLVDe0Zx/N6d2edYybL1a/jT7taLcqoMg
         wY4w==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220602133543.128088-3-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>

On Thu, Jun 02, 2022 at 09:35:42AM -0400, Waiman Long wrote:
> For blkcg_css_alloc(), the only error that will be returned is -ENOMEM.
> Simplify error handling code by returning this error directly instead
> of setting an intermediate "ret" variable.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

But I don't understand why this would trigger warning. Can you please
elaborate why this is needed.

Thanks.

-- 
tejun
