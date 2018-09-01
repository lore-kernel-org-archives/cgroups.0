From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 00/15] blkcg ref count refactor/cleanup + blkcg avg_lat
Date: Fri, 31 Aug 2018 17:35:10 -0700
Message-ID: <20180901003510.GM1488037@devbig004.ftw2.facebook.com>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KSYqO/7kLlYe8MN733EJtGY7cjl/cnw+tgVUdvuckTQ=;
        b=BsbuMufJxIsRMXpj9XFw2HJnBuLDt4UOdQk51T3VJRgZC9TNYc5DJnvUTKn1g6Wlje
         NwuZ15tvdagzj7fNPq1/ZvunhR4ClEwUSd7du2gc2iTPyDwBwBMneAp/Fglf1o4ulu96
         qdajnd39WK6Tf8+iFaYPc/IwTc8jFd/56oAkzzYEpk8BX+yVlLYmT0WobC8PLnme2uN5
         MucL8h8FJFvezVBZ0XICWfUeAqcelb+shkzp/ooHMDbdPCFiciqtc1wx2ru25NTsuHkO
         A+zN66aLgxgIayQAyl6heVVaWaDTv5nTbmTtvBZJPfw9JICBCdkXq0faG8xhNkCF3kSr
         4K6Q==
Content-Disposition: inline
In-Reply-To: <20180831015356.69796-1-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennisszhou@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 30, 2018 at 09:53:41PM -0400, Dennis Zhou wrote:
> This is a fairly lengthy patchset that aims to cleanup reference
> counting for blkcgs and blkgs. There are 4 problems that this patchset
> tries to address:
>   1. fix blkcg destruction
>   2. always associate a bio with a blkg
>   3. remove the extra css ref held by bios and utilize the blkg ref
>   4. add average latency tracking to blkcg core in io.stat.

1 is already merged.  Reviewed 2, 3 parts.  Generally looks great.
Let's try to address the found issues and get these two parts merged
first.

Thanks.

-- 
tejun
