From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v7 6/9] blk-throttle: use 'READ/WRITE' instead of '0/1'
Date: Tue, 16 Aug 2022 10:03:16 -1000
Message-ID: <Yvv4BOx92l20VqD1@slm.duckdns.org>
References: <20220802140415.2960284-1-yukuai1@huaweicloud.com>
 <20220802140415.2960284-7-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=iu5TF+HIlWiXRw5i84jKcV9q+7psfaQE0MbUzyZYC7E=;
        b=O3oVKSvWFx+BJ+PtWLrwXiOht9Qt4PcjXLTlznB0lOSM1vPpC8l/Hf/u8Qp1CLrLzX
         g4roEEdbTsG4xNqJtyg6mHgyjUMegIeqRw3SK5BhxUd8LoNPbuKU/Iki8KPxjCI8yb7D
         l3xAVlPRkgATEu7i0iRii3EsRrgZFNGxjZAfg6YSx5Pg8nET3PtYtHsvHxYAZ/TQ185k
         H7K+VFmZLr3JPlNSY7uW8aBF7L9uxpWzf4eaAcP3SAYjeTCIxXEQlQCT5LA1raTx8M3w
         fmbC1dqRezdDDbarDLCZ7mvNwUOqEFVcw/6l4v14+b15vnnGpOK9X2OpRhKM9QhR1Prp
         WVUw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220802140415.2960284-7-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mkoutny@suse.com, axboe@kernel.dk, ming.lei@redhat.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

On Tue, Aug 02, 2022 at 10:04:12PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Make the code easier to read, like everywhere else.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> Acked-by: Tejun Heo <tj@kernel.org>

Let's float trivial acked patches to the front so that they can applied
without waiting for the rest of the series.

Thanks.

-- 
tejun
