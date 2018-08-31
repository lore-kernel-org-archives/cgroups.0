From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 02/15] blkcg: delay blkg destruction until after
 writeback has finished
Date: Fri, 31 Aug 2018 11:27:07 -0400
Message-ID: <20180831152705.4mjm7xo6jq7ptdqn@destiny>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
 <20180831015356.69796-3-dennisszhou@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ehQWXVB9CUEK8Dd/OdxgyGILgSG54iuToHUqmjdn1ck=;
        b=nVsa7lI1KmWNAA1Dx6R13JKqqhSud5b+177hLCUxcUSeQx0KU4G755vYcDRPyWZkzp
         ZX1jKHBOHGcaGA6FxRuwI1UlaXmsS7UyHaHYbIcChjNqONYPkuxtlRFcTmlbQAUVv/Dk
         rBqugJeJvCttbgtYbzsbDPekpVSuOJ6VwWE+W38ENqrorTbS+703QJUo/oWWHVH2vBk9
         /ko0jJCj9WFIpZA6cHyleYPiUqXe2T/Z/1srrGRdEf12DwD/bgIY/mhZoV5D2CRTmqUL
         DLBQ88unB5WpChALu37MzvXD8j+yDjtFUEGP5qo0b/ZlwKQyYw8e0xAQdNuc4FoJYBoR
         WorA==
Content-Disposition: inline
In-Reply-To: <20180831015356.69796-3-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennisszhou@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Jiufei Xue <jiufei.xue@linux.alibaba.com>, Joseph Qi <joseph.qi@linux.alibaba.com>

On Thu, Aug 30, 2018 at 09:53:43PM -0400, Dennis Zhou wrote:
> From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>
> 
> Currently, blkcg destruction relies on a sequence of events:
>   1. Destruction starts. blkcg_css_offline() is called and blkgs
>      release their reference to the blkcg. This immediately destroys
>      the cgwbs (writeback).
>   2. With blkgs giving up their reference, the blkcg ref count should
>      become zero and eventually call blkcg_css_free() which finally
>      frees the blkcg.
> 
> Jiufei Xue reported that there is a race between blkcg_bio_issue_check()
> and cgroup_rmdir(). To remedy this, blkg destruction becomes contingent
> on the completion of all writeback associated with the blkcg. A count of
> the number of cgwbs is maintained and once that goes to zero, blkg
> destruction can follow. This should prevent premature blkg destruction.
> 
> The new process for blkcg cleanup is as follows:
>   1. Destruction starts. blkcg_css_offline() is called which offlines
>      writeback. Blkg destruction is delayed on the nr_cgwbs count to
>      avoid punting potentially large amounts of outstanding writeback
>      to root while maintaining any ongoing policies.
>   2. When the nr_cgwbs becomes zero, blkcg_destroy_blkgs() is called and
>      handles destruction of blkgs. This is where the css reference held
>      by each blkg is released.
>   3. Once the blkcg ref count goes to zero, blkcg_css_free() is called.
>      This finally frees the blkg.
> 
> It seems in the past blk-throttle didn't do the most understandable
> things with taking data from a blkg while associating with current. So,
> the simplification and unification of what blk-throttle is doing caused
> this.
> 

So the general approach is correct, but it's sort of confusing because you are
using nr_cgwbs as a reference counter, because it's set at 1 at blkg creation
time regardless of wether or not there's an assocated wb cg.  So instead why not
just have a refcount_t ref, set it to 1 on creation and make the wb cg take a
ref when it's attached, and then just do the get/put like normal and cleanup as
you have below?  What you are doing is a reference counter masquerading as a
count of the wb cg's, just add full ref counting to the blkcg and call it a day,
it'll be much less confusing.  Thanks,

Josef
