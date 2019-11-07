From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCHSET v2 block/for-next] blk-cgroup: use cgroup rstat for IO
 stats
Date: Thu, 7 Nov 2019 12:28:47 -0700
Message-ID: <2a6dd76b-6063-92b9-7b20-97f69bb4b344@kernel.dk>
References: <20191107191804.3735303-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LsQBOGT7wlBeTtd5DGVJ1cAFGBGmgxUQGz4CBk4TLCk=;
        b=pVKXsw6iTlJ2Rzs/YUhd1cSagr7G85BPX4jvG88avd78mLhxpwKSuSup+KefjXgIzd
         D99eKJyFKqrIcZz8kgmmwl8B7bGRqu8tHo6szfdV1XbTdJ6NW7Daw49AkY/gMmuKncRn
         t5QMRH81Y3OOOXlCBRJRI8iZUCYzpSb4T3mleVCNGWEdUdF1GzrTwDjUe9aEUSneQL4B
         uGtLuJbyPxquXYAPyeyX8vY0Bgl/FCPAwmmQGAHRZObaR2TK/+SlD7+smuzdVvztSDN1
         xpINYOf1vFWkuiS8IiRdmGwfG3W5cTmNRSeHvQH6W7ubVPkL/J0BJfpWgkDHYxjfInUl
         uxNQ==
In-Reply-To: <20191107191804.3735303-1-tj@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, kernel-team@fb.com

On 11/7/19 12:17 PM, Tejun Heo wrote:
> Hello,
> 
> v2: Build fix when !DEBUG.
> 
> blk-cgroup IO stats currently use blkg_rwstat which unforutnately
> requires walking all descendants recursively on read.  On systems with
> a large number of cgroups (dead or alive), this can make each stat
> read a substantially expensive operation.
> 
> This patch updates blk-cgroup to use cgroup rstat which makes stat
> reading O(# descendants which have been active since last reading)
> instead of O(# descendants).
> 
>   0001-bfq-iosched-relocate-bfqg_-rwstat-helpers.patch
>   0002-bfq-iosched-stop-using-blkg-stat_bytes-and-stat_ios.patch
>   0003-blk-throtl-stop-using-blkg-stat_bytes-and-stat_ios.patch
>   0004-blk-cgroup-remove-now-unused-blkg_print_stat_-bytes-.patch
>   0005-blk-cgroup-reimplement-basic-IO-stats-using-cgroup-r.patch
>   0006-blk-cgroup-separate-out-blkg_rwstat-under-CONFIG_BLK.patch
> 
> 0001-0003 make bfq-iosched and blk-throtl use their own blkg_rwstat to
> track basic IO stats on cgroup1 instead of sharing blk-cgroup core's.
> 0004 is a follow-up cleanup.
> 
> 0005 switches blk-cgroup to cgroup rstat.
> 
> 0006 moves blkg_rwstat to its own files and gate it under a config
> option as it's now only used by blk-throtl and bfq-iosched.
> 
> The patchset is on top of
> 
>    block/for-next  40afbe18b03a ("Merge branch 'for-5.5/drivers-post' into for-next")
> + block/for-linus b0814361a25c ("blkcg: make blkcg_print_stat() print stats only for online blkgs")
> 
> and also available in the following git branch.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-blkcg-rstat

Thanks, applied!

-- 
Jens Axboe

