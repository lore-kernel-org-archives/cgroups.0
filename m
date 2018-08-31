From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 08/15] blkcg: associate a blkg for pages being evicted by
 swap
Date: Fri, 31 Aug 2018 11:44:26 -0400
Message-ID: <20180831154425.hvh7hrz5nocs35tr@destiny>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
 <20180831015356.69796-9-dennisszhou@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bW4HdnUXreM4ZDeViOaJVHzcCN7B4W80txKIg0Q23RQ=;
        b=uK3VdRwN8MhVYd1Nns86CO2r3GgV7tsi1u0TFyu24pZ/1o4MpqLu4Ne3KN66a/91OW
         Q47vO8uNo24yz1tI3mZpy2u7hqU2Uxr04XqsTL5NhifBpqdCaQImpEttXy5ISm2BKiKh
         B7wC1RFx6OifDBPrisbTRB604ZN7N25rfACgv1LTL3NmYCjwjNpq3yH8ho1sCCiAu2nC
         K4h4NimSyhwBvlWT42JAyEdmEwV5zwFpRYIzT1mDEeBwCjGKb7fzlVRImXhTCdeKFvna
         KJzoMRHjKeepN8ecdavYemNugPatUBN6bdez7Qlxe/pLBsUk+Va8RpAcEvAE0IxWvAoi
         rpFQ==
Content-Disposition: inline
In-Reply-To: <20180831015356.69796-9-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennisszhou@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Aug 30, 2018 at 09:53:49PM -0400, Dennis Zhou wrote:
> From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>
> 
> A prior patch in this series added blkg association to bios issued by
> cgroups. There are two other paths that we want to attribute work back
> to the appropriate cgroup: swap and writeback. Here we modify the way
> swap tags bios to include the blkg. Writeback will be tackle in the next
> patch.
> 
> Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
