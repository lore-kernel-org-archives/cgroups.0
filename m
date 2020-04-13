From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET v2 block/for-5.8] iocost: improve use_delay and
 latency target handling
Date: Mon, 13 Apr 2020 13:08:33 -0400
Message-ID: <20200413170833.GD60335@mtj.duckdns.org>
References: <20200413162758.97252-1-tj@kernel.org>
 <dd55f890-740c-16b5-77bd-4c6fdb710b3d@gmail.com>
 <6f69d35c-c593-f140-c351-c7fd2c13069e@gmail.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NFNHfE7F1rrYFA5HLaqChE2dtGQCPN6coS8rdPNSigI=;
        b=hMvMIFkUh4+zKif04z4ScUfhsqi7SEl+A+mrbPrruG/ETMUk9MSMbdQuV+ZR7jkh3N
         J0dtg9bsXCxgugxr47p9P970lB3mLeXEl1+dvVvePWz0RAdaz/HKS9DkxqtVRssfjzz3
         WsnPlYz8DMA4ziVwz9BT6kPhHkaQ8UbLHH2o2QrG37vg6K6zL+C9Ns0+E3cpCa5Yr6lg
         pz39Lh4j6AOWTYBZOFbnjAsgZLTLjjKlGPKFSXrK0D+nlVPiGu2cLa8a1KZImJ/aDOPm
         /ruh8zkhxm/8oyNqJEz8FUOmopUR6CjUyrxGuMhEJAdkGzvu14q107uAQLarg3nczumZ
         0XFA==
Content-Disposition: inline
In-Reply-To: <6f69d35c-c593-f140-c351-c7fd2c13069e@gmail.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, newella@fb.com, josef@toxicpanda.com, ming.lei@redhat.com, bvanassche@acm.org

On Mon, Apr 13, 2020 at 08:00:29PM +0300, Pavel Begunkov wrote:
> On 13/04/2020 19:56, Pavel Begunkov wrote:
> > On 13/04/2020 19:27, Tejun Heo wrote:
> >> Changes from v1[1]
> >>
> >> * Dropped 0002-block-add-request-io_data_len.patch and updated to use
> >>   rq->stats_sectors instead as suggested by Pavel Begunkov.
> > 
> > rq->stats_sectors is set only when there is QUEUE_FLAG_STATS, see
> > blk_mq_start_request(). I don't see blk-iocost requiring it. Did I miss something?
> 
> And there is no reason to not initialise it unconditionally.

The updated patch turns on accounting when iocost is enabled on a queue.

  @@ -2267,6 +2295,7 @@ static ssize_t ioc_qos_write(struct kernfs_open_file *of, char *input,
   	spin_lock_irq(&ioc->lock);
 
   	if (enable) {
  +		blk_stat_enable_accounting(ioc->rqos.q);
   		blk_queue_flag_set(QUEUE_FLAG_RQ_ALLOC_TIME, ioc->rqos.q);
   		ioc->enabled = true;
   	} else {

Thanks.

-- 
tejun
