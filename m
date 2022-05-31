From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Tue, 31 May 2022 08:24:24 -1000
Message-ID: <YpZdWNGW1bTGnApp@slm.duckdns.org>
References: <20220531181821.187834-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aASmjf/pnI60SUyA+vo4oipwPmuVquT6UTuMWtth16E=;
        b=b0id0ljyEJ0A/BY68TcNQin8MFxEUP8/YY3UNzivhDGBEenqWTe/+aVQCXUF8mOaFa
         YOO0EU29eTkoKmgRpmqlacunMUw0EUoR6CTK9iZruDkT2J2rlorxz5r6+eLgaMSUcCV6
         ACYvJ+0bZWXhVxPwtNmTgxg5agQ5hhotR0skd6dDH1x2NIpYa+bHadXaCmklo+xSmQAp
         3cDk1C7/OL4VRpAPQwYsTYJbu32wrZ1mfMznQhu3UidlC4xzZpX2Nh5WrtFGjxf5vzbe
         RrU44InIpqTW71q+AT4Tz847CoAO23+wD1Kyri81QgGgK2fYkWGaZSJ1rtR8Hfq55JUh
         JhFA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220531181821.187834-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>

Hello, Waiman.

On Tue, May 31, 2022 at 02:18:21PM -0400, Waiman Long wrote:
> For a system with many CPUs and block devices, the time to do
> blkcg_rstat_flush() from cgroup_rstat_flush() can be rather long. It
> can be especially problematic as interrupt is disabled during the flush.
> It was reported that it might take seconds in some extreme cases leading
> to hard lockup messages.
> 
> As it is likely that not all the percpu blkg_iostat_set's has been
> updated since the last flush, those stale blkg_iostat_set's don't need
> to be flushed in this case. This patch optimizes blkcg_rstat_flush()
> by checking the current sequence number against the one recorded since
> the last flush and skip the blkg_iostat_set if the sequence number
> hasn't changed. There is a slight chance that it may miss an update
> that is being done in parallel, the new update will just have to wait
> until the next flush.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  block/blk-cgroup.c | 18 +++++++++++++++---
>  block/blk-cgroup.h |  1 +
>  2 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 40161a3f68d0..79b89af61ef2 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -864,11 +864,23 @@ static void blkcg_rstat_flush(struct cgroup_subsys_state *css, int cpu)
>  		unsigned long flags;
>  		unsigned int seq;
>  
> +		seq = u64_stats_fetch_begin(&bisc->sync);
> +		/*
> +		 * If the sequence number hasn't been updated since the last
> +		 * flush, we can skip this blkg_iostat_set though we may miss
> +		 * an update that is happening in parallel.
> +		 */
> +		if (seq == bisc->last_seq)
> +			continue;

Is this a sufficient solution? The code assumes that there aren't too many
blkgs for the cgroup, which can be wrong in some cases. Wouldn't it be
better to create a list of updated blkg's per blkcg so that we don't walk
all the dormant ones?

Thanks.

-- 
tejun
