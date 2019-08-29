From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCHSET v3 block/for-linus] IO cost model based work-conserving
 porportional controller
Date: Wed, 28 Aug 2019 21:29:00 -0600
Message-ID: <f48b98fa-b33e-b3d3-2657-04f599e710fd@kernel.dk>
References: <20190828220600.2527417-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JGxbE50uXwCgfhAfE1eTU8tNsVQiLS6htVfulohzZj4=;
        b=YcVaHG7J8kEUDEEpnsah1aC33aFF/zVr9WtxqWBS/dVq90U/A5AgzuMSwi522I98nE
         JO8rA9dtet4C9wMyT2ZBAADep7t6cOkCV8+4UOo6nfksXdT4Rd6v/g4xKys4wjTQvkAG
         hhvxC14TXxXJauZWxqVQU8IzKF66W5niRk7fIdp8Ix9De6qGWEOhuAMoe6kKLhTxxf6t
         TtHfwstOlHFEUJr66LCpaRJWxc52yQZRenzaX/zb/M98dxweJf6eqPo1jJ1hhg+UCw3G
         Saes9+wAsSIoIkuN0nuZqPYVFo3jt6AceCpIOvGpk/p1tGh3dX2TQzyPA8xsqopw8kJA
         0RqA==
In-Reply-To: <20190828220600.2527417-1-tj@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, newella@fb.com, clm@fb.com, josef@toxicpanda.com, dennisz@fb.com, lizefan@huawei.com, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org

On 8/28/19 4:05 PM, Tejun Heo wrote:
> Changes from v2[2]:
> 
> * Fixed a divide-by-zero bug in current_hweight().
> 
> * pre_start_time and friends renamed to alloc_time and now has its own
>    CONFIG option which is selected by IOCOST.

This looks fine to me now, I've queued it up for 5.4.

-- 
Jens Axboe

