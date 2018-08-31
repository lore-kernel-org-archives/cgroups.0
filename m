From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/3] fix blkcg offlining and destruction
Date: Fri, 31 Aug 2018 15:24:12 -0700
Message-ID: <20180831222412.GA1488037@devbig004.ftw2.facebook.com>
References: <20180831202244.21678-1-dennisszhou@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6eYN1qllWYHTmUDJ48f68iHeHMhzkffLFI0awVIa5j0=;
        b=kPrEjU5e2tK87pz9E+X9q6lm3tr0PBJW8xWmrwPflD2HwZs1flPrzhhJO0NP1T+/2G
         yO9iCKAM5cKiTfTWlrY3PgOuECfW8naSaRd/NSsfi1DZE5W8JNfUDkiImCOQTRzf7KDH
         sIezu5Cvrh+kYNPY1fxh74Vhc7rnLzcxts5k1xeflN7eOwn21QCzR5QCcxFTKV/oud44
         NFeNlPnCz6pgDQAqyOazGnPvQfXwQfc+pC58Cj9h2vZBQl08oqwg1BhVvXBq91WBj4Ej
         cUMhkxFB0LMqH3pYEvYLbRZ35I00MdGLWtfE7FDgfMoT1B9nWaTR1gglNzBhEMdvimtZ
         58yg==
Content-Disposition: inline
In-Reply-To: <20180831202244.21678-1-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennisszhou@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Aug 31, 2018 at 04:22:41PM -0400, Dennis Zhou wrote:
> Hi everyone,
> 
> This is a split of an earlier series I sent out [1] containing the first
> 3 patches with fixes from feedback. This series tackles the first
> problem where blkcgs were not being destroyed.
> 
> There is a regression in blkcg destruction where references weren't
> properly put causing blkcgs to never be destroyed. Previously, blkgs
> were destroyed during offlining of the blkcg. This puts back the blkcg
> reference a blkg holds allowing blkcg ref to reach zero. Then,
> blkcg_css_free() is called as part of the final cleanup.
> 
> To address the problem, 0001 reverts the broken commit, 0002 delays
> blkg destruction until writeback has finished, and 0003 closes the
> window on a race condition between a css migration and dying, and
> blkg association. This should fix the issue where blkg_get() was getting
> called when a blkcg had already begun exiting. If a bio finds itself
> here, it will just fall back to root. Oddly enough at one point,
> blk-throttle was using policy data from and associating with potentially
> different blkgs, thus how this was exposed.

For patches 1-3,

  Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
