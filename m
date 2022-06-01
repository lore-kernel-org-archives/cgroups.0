From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 1/2] blk-cgroup: Correctly free percpu iostat_cpu in
 blkg on error exit
Date: Wed, 1 Jun 2022 07:48:45 -1000
Message-ID: <YpemfZkI2G88qdQF@slm.duckdns.org>
References: <20220601165324.60892-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XQNVv3TuiqkXfJLicoHS/WLsewT+IhkJwNNY/yOQl9g=;
        b=SKU2z8FWFcS1GugMMFLbBI+MuKmAOThdo/dalT5Ltb3g/svDPwBjGIwhtVZ01dUZps
         1308bR9i3vI6Fd+2mS93Un2RwJpHcPnieky5g4cs6b6G076AAEbIz87pg92Bz2Zj/Mqn
         Odm4Ap+9X20du139FLWLRcy+MX1I6soMhKNWaYhoy3oqAmke5/rHadrkh2vRIkcWAUP+
         d0o070W8/zcaWi7YtljW7DRU6NQ1g1J0Ko4o2zGSvswFbgMoE0KVFjE7vFOgSfmehOXZ
         Ndw7QFIX4Y0EPCURlETvCM9ZB1asysMjtFMp5IIQjdFcZi7897WgKu2aCwjPHWz6kQvd
         OYMA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220601165324.60892-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>

On Wed, Jun 01, 2022 at 12:53:23PM -0400, Waiman Long wrote:
> Commit f73316482977 ("blk-cgroup: reimplement basic IO stats using cgroup
> rstat") changes block cgroup IO stats to use the rstat APIs. It added
> a new percpu iostat_cpu field into blkg. The blkg_alloc() was modified
> to allocate the new percpu iostat_cpu but didn't free it when an error
> happened. Fix this by freeing the percpu iostat_cpu on error exit.
> 
> Fixes: f73316482977 ("blk-cgroup: reimplement basic IO stats using cgroup rstat")
> Signed-off-by: Waiman Long <longman@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
