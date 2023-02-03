From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 19/19] blk-cgroup: move the cgroup information to struct
 gendisk
Date: Thu, 2 Feb 2023 14:24:46 -1000
Message-ID: <Y9xUTlC0MaDzCCTj@slm.duckdns.org>
References: <20230201134123.2656505-1-hch@lst.de>
 <20230201134123.2656505-20-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ThsZNAEjunCzoIbygWl1s3g5YVj7pWLNnV0t+0ju9b8=;
        b=qPtS9CsNKmok6OXROA5LDwsstn4DlJpkPIsLk1XbNP3D/lN7r0OApaNOqQmVpYhCUu
         rlnX47Q78n1iRUBBQSGpsNdcU2B/nSfzjwhQOMXUwLUajLVSbxARXthAL1LMm5PtEJmH
         44ClLdXTf6jusIHGIsi7bYWvT6iO03WMuymSMzVFrokhWggaqSts7ITooIOoUHTu9zrP
         b0GH1qrVP5oiZmGIDM5CZ6Iboh6Xth6RzHrr4SiaC1s0LgyfTdA6JZlA0pKc2i3VV5hU
         64uPssxmCrjxd3yGaiZvgfwM0knJlze0TAYjKeHd3QMVsGbRfauAAOsQvcRye4amPk6e
         CecQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230201134123.2656505-20-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Andreas Herrmann <aherrmann@suse.de>

On Wed, Feb 01, 2023 at 02:41:23PM +0100, Christoph Hellwig wrote:
> cgroup information only makes sense on a live gendisk that allows
> file system I/O (which includes the raw block device).  So move over
> the cgroup related members.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Andreas Herrmann <aherrmann@suse.de>

For 08 - 19:

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
