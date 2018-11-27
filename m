From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 03/13] blkcg: convert blkg_lookup_create() to find
 closest blkg
Date: Tue, 27 Nov 2018 16:01:33 -0500
Message-ID: <20181127210131.7cdgku7cmixxwdbc@macbook-pro-91.dhcp.thefacebook.com>
References: <20181126211946.77067-1-dennis@kernel.org>
 <20181126211946.77067-4-dennis@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2+oB3NQ6DcHGeIHckr9cxaNYbTfbF5HSphI11S9KWTQ=;
        b=s6TA9BR+Y6w/5h1lwrPObaaUUawuQqf64/Sa+x+v3JxRRzJ57egayvruUwD9bjd+Sv
         q52LBGdh9SNQPlHfTlKYm6TWbbJqF/smr6Ea9KRseqDzubjyjQ1sTanXW1BHYoOTuU5a
         3NZ8/eJE4EYKKA+LZUO4bnLBGQ1PCQDzG4/7UTKoQfoGKdM61nGItxtYEjl27flovFMS
         bPdZIhr4xB553ypzY21QJ6OAAn8rjTUX51v1ZGKGQi4Ingk2T74IA3yrxYbNeKZC31+F
         nNI3Ju76jqgUvDTysHyezpw4/DQuY6vCU2/AeUFqOTy2zTvTMQxXsSJuoUqJVc/CsX1G
         HQ6Q==
Content-Disposition: inline
In-Reply-To: <20181126211946.77067-4-dennis@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennis@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Nov 26, 2018 at 04:19:36PM -0500, Dennis Zhou wrote:
> There are several scenarios where blkg_lookup_create() can fail such as
> the blkcg dying, request_queue is dying, or simply being OOM. Most
> handle this by simply falling back to the q->root_blkg and calling it a
> day.
> 
> This patch implements the notion of closest blkg. During
> blkg_lookup_create(), if it fails to create, return the closest blkg
> found or the q->root_blkg. blkg_try_get_closest() is introduced and used
> during association so a bio is always attached to a blkg.
> 
> Signed-off-by: Dennis Zhou <dennis@kernel.org>
> Acked-by: Tejun Heo <tj@kernel.org>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
