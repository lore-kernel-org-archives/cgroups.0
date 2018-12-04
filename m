From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 11/14] blkcg: remove additional reference to the css
Date: Tue, 4 Dec 2018 14:53:02 -0500
Message-ID: <20181204195301.delc756zuo5gxtlw@MacBook-Pro-91.local>
References: <20181204183600.99746-1-dennis@kernel.org>
 <20181204183600.99746-12-dennis@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+VG8OeAI5diR1prMWfOG9jypspaoM2+GkCaXxs9Fkh4=;
        b=wnLUxI3jiVK/TZ6SfjDQh0Cu6nYvzK2mrpLOLEkUPUGkdupA/tT7gziopeU58X+Zpe
         85vv/WMoH84pvMg2DIDc6EZ51eb36yC7g/mSS6qIX8Ib71Bv5wb6lW3p+lGkBgdjL4K5
         HEEI824CFmFUm4cTRbQljlmnF3A+2tQlXzQwRo0ELL59Nek8w9qiQg55pXRvRW7qtjm9
         zruHxhq84zGez1dw04hNiSL/P8DpsRWdmXvNQmFTyIsGiGfvQMIz7NbRpMfJya0sspUy
         WlxS5EWvy5fD9PVNNlI/LrcJV4NyEkW92sJ8o8vOiQqV7xVVXc9IT1Dm+aMKRmsT+Qv1
         xU/g==
Content-Disposition: inline
In-Reply-To: <20181204183600.99746-12-dennis@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennis@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Dec 04, 2018 at 01:35:57PM -0500, Dennis Zhou wrote:
> The previous patch in this series removed carrying around a pointer to
> the css in blkg. However, the blkg association logic still relied on
> taking a reference on the css to ensure we wouldn't fail in getting a
> reference for the blkg.
> 
> Here the implicit dependency on the css is removed. The association
> continues to rely on the tryget logic walking up the blkg tree. This
> streamlines the three ways that association can happen: normal, swap,
> and writeback.
> 
> Signed-off-by: Dennis Zhou <dennis@kernel.org>
> Acked-by: Tejun Heo <tj@kernel.org>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
