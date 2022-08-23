From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v8 4/4] blk-throttle: fix io hung due to configuration
 updates
Date: Tue, 23 Aug 2022 08:08:43 -1000
Message-ID: <YwUXq9XO4TstKJ66@slm.duckdns.org>
References: <20220823033130.874230-1-yukuai1@huaweicloud.com>
 <20220823033130.874230-5-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=jMrD17BOV98jk73P9NMr/PINIPRYYcJU7k+IUzeRBQA=;
        b=or9uvjfPOCaGwdBvw+hLIyR+yPC8qv//wqrLKeu8hWnasHqJPxFAr1OVi/nGYJLywp
         4MoXa1LsfePr3nTkMbdtLI+IIspnZMLsg8bqwRMUUEqBd2ssYPK8QnOpYFK/IpAFeTVk
         tn64l35YiVkrtVNO4kyUZD+0EXEi91pcE8wAb9ypz3/y5QOVxs3wElkyEk+38AVMafrS
         ahsKWdGxRWW+g1JQLLufAZfYq1uq8sPr3d8KbcqW3PzONzMmPwvw6LXY3OaevoGU06hM
         A6tFf73jfJRDoM2yFxjVc5Z3mUccQu0q2RfXya7Mwi/J8iGRgI6XlTWQwMPma1mNzTb9
         Ubog==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220823033130.874230-5-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: axboe@kernel.dk, ming.lei@redhat.com, mkoutny@suse.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

On Tue, Aug 23, 2022 at 11:31:30AM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> If new configuration is submitted while a bio is throttled, then new
> waiting time is recalculated regardless that the bio might already wait
> for some time:
> 
> tg_conf_updated
>  throtl_start_new_slice
>   tg_update_disptime
>   throtl_schedule_next_dispatch
> 
> Then io hung can be triggered by always submmiting new configuration
> before the throttled bio is dispatched.
> 
> Fix the problem by respecting the time that throttled bio already waited.
> In order to do that, add new fields to record how many bytes/io are
> waited, and use it to calculate wait time for throttled bio under new
> configuration.
> 
> Some simple test:
> 1)
> cd /sys/fs/cgroup/blkio/
> echo $$ > cgroup.procs
> echo "8:0 2048" > blkio.throttle.write_bps_device
> {
>         sleep 2
>         echo "8:0 1024" > blkio.throttle.write_bps_device
> } &
> dd if=/dev/zero of=/dev/sda bs=8k count=1 oflag=direct
> 
> 2)
> cd /sys/fs/cgroup/blkio/
> echo $$ > cgroup.procs
> echo "8:0 1024" > blkio.throttle.write_bps_device
> {
>         sleep 4
>         echo "8:0 2048" > blkio.throttle.write_bps_device
> } &
> dd if=/dev/zero of=/dev/sda bs=8k count=1 oflag=direct
> 
> test results: io finish time
> 	before this patch	with this patch
> 1)	10s			6s
> 2)	8s			6s
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

For 2-4,

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
