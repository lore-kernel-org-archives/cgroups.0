From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCHSET for-5.10/block] iocost: improve debt forgiveness logic
Date: Fri, 25 Sep 2020 08:35:30 -0600
Message-ID: <a4baed8e-d3a5-3801-7f26-5c32f2931177@kernel.dk>
References: <20200918004456.593983-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3sVDrl7nq71b7+Tl95Id30AEaStu5JjNu+SbInS86S8=;
        b=E55wmYy6/zrsq1xauJ75mYZUcCl/7T8kL0VfI5mCOUuYURZxcMOOCuqthu+IF2L+NV
         eVlWeUXhu5vEq18VjsiZrD8N8Pk0YBn3UJ20S0yUhwxU/3UiyJ/bTPgCZCRlHIKCtqf+
         4t22c3hKJyeQK7cv5zEt6qCepixo/cNSB3/qhci7vp34g73P5vhesH4X/NDeo6RfV2ub
         BIV8GJZkeuY5TiDZ/1rLHDCSOwqaT7mQ6eKLpRjVzo0yU2z/zidZBszbbUK642laboim
         qTAd7a0vjHf0JpTsjxT/CmJDVk2TnsS+rzCwxP9U/4bTuRRs+8MwUdkc8Raqtx1O3cZ2
         h+fQ==
In-Reply-To: <20200918004456.593983-1-tj@kernel.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, linux-kernel@vger.kernel.org

On 9/17/20 6:44 PM, Tejun Heo wrote:
> Hello,
> 
> Debt reduction logic was recently added by dda1315f1853 ("blk-iocost: halve
> debts if device stays idle"). While it was effective at avoiding
> pathological cases where some iocgs were kept delayed while the device was
> most idle, it wasn't very effective at addressing more complex conditions
> and could leave low priority cgroups unnecessarily harshly throttled under
> moderate load.

Applied, thanks.

-- 
Jens Axboe

