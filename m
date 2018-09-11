From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 03/12] blkcg: convert blkg_lookup_create to find closest
 blkg
Date: Tue, 11 Sep 2018 16:50:09 -0700
Message-ID: <20180911235009.GC2966370@devbig004.ftw2.facebook.com>
References: <20180911184137.35897-1-dennisszhou@gmail.com>
 <20180911184137.35897-4-dennisszhou@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eA1Y8LAM4afbJQHN/Q+Ti6OaqCzYueF4LckPdLkAuEQ=;
        b=hO5rT3hbXcIWtGDs3OyFendQ0YC+UFVYXBBAz8vglQuSdKZ4XKCHjxdrX5nhMfN1Rz
         JzEO3vKitQt3NGra8UI+JbeG4/eawXZ+wQJx74BERbdBuzteccrfAonWna6WzxgyyI6g
         /ZfKD1lTmDsw6wfcv2gi32lk5swJBb3TAbsbxrwHuhxyP6wr0lCx6HUY2iXIwwvEfz/p
         /iSQYQb0QbqfGeRP1SqPZK9PecU3YAQJwPv9ms4tVbJ42TjaUnB+aTfYF5x7NxOBfBcA
         sjv+1Z8epTLmj8sRa+tmF2Nq76HRo9dyA4fYv3GMX1Tgxe71LcwUHSjwEUsXF6vIdC75
         344Q==
Content-Disposition: inline
In-Reply-To: <20180911184137.35897-4-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennisszhou@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Sep 11, 2018 at 02:41:28PM -0400, Dennis Zhou wrote:
> From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>
> 
> There are several scenarios where blkg_lookup_create can fail. Examples
> include the blkcg dying, request_queue is dying, or simply being OOM. At
> the end of the day, most handle this by simply falling back to the
> q->root_blkg and calling it a day.
> 
> This patch implements the notion of closest blkg. During
> blkg_lookup_create, if it fails to create, return the closest blkg
> found or the q->root_blkg. blkg_try_get_closest is introduced and used
> during association so a bio is always attached to a blkg.
> 
> Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
