From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 14/15] blkcg: rename blkg_try_get to blkg_tryget
Date: Fri, 31 Aug 2018 11:50:17 -0400
Message-ID: <20180831155016.2u5erpni5omhcncr@destiny>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
 <20180831015356.69796-15-dennisszhou@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UqaA9H8RxsZ7IIFSLpndjVyK5I3+eZWdGd5MwXiwCqQ=;
        b=xFPHzLgC4sh+KhS4ZP9khaBXROOYwkCxcppvRlSRnZwE/Fk4jSXgWzsTkC1d/QwWoL
         ULECdegUNk6v49JIUEau+Lgmytsx96g++icAS0OrqGmpsa8GbFHVqRqauGJIboC9JH9I
         G62OsSkIcfQudGL7RpUYOgeSlbottNanch3F3HDOULvSgVZjx6SXtOAsgSdhOdjsK9qK
         q416PyTf4iul1hZll4jhEmnHqyQ5GkCD5cjNfZRrB9Z0N+Dle4LyBdvXWQXeF703PWmU
         B+umTNjO+2ampF1Y4tJt1LWuxgjKFeWH/ZOLy15b9BpAsyxoVkBKzCQUeyk/aSYffZ/A
         hCXQ==
Content-Disposition: inline
In-Reply-To: <20180831015356.69796-15-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennisszhou@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Aug 30, 2018 at 09:53:55PM -0400, Dennis Zhou wrote:
> From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>
> 
> blkg reference counting now uses percpu_ref rather than atomic_t. Let's
> make this consistent with css_tryget. This renames blkg_try_get to
> blkg_tryget and now returns a bool rather than the blkg or NULL.
> 
> Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
