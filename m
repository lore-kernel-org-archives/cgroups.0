From: Tejun Heo <tj@kernel.org>
Subject: Re: switch blk-cgroup to work on gendisk
Date: Thu, 19 Jan 2023 07:03:31 -1000
Message-ID: <Y8l34/qeHPLV4rKJ@slm.duckdns.org>
References: <20230117081257.3089859-1-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CQoTJcoI0zudP9kqEp3QP7XD1mX3VxGZCw8MlkN3oyA=;
        b=hYG6+PIItfIJ8RaYvrETkb1iEq22Peoj6RQaavU/zimVQAD1HERJ+3gkMl1FEPriVS
         Bb80iDejEzIY050s7ahNT6VLftXVfGWSX/VBKCmhcCzZsUndo44FmyJgpBTIaWCIyI27
         h25sq8scf7twn/fjK2cqZdOj33D4EttK+Oq/QCGwktPToLV/YpuBR3ckpQZHQnjKdUFS
         sc3Hw5fxdfg3akD1Ew8I65aIaVOhEhO8jNRaugq9ihIEIdgeZtYpAef5dO7g+pAb4fUb
         MlCeresDFfHSBlKCBLHAlkim1el8jHIlNSFjPn3ji3UXy+Mz4rI7uW6y/7oC/fGcK1cB
         WEmg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230117081257.3089859-1-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org, cgroups@vger.kernel.org

On Tue, Jan 17, 2023 at 09:12:42AM +0100, Christoph Hellwig wrote:
> blk-cgroup works on only on live disks and "file system" I/O from bios.
> This all the information should be in the gendisk, and not the
> request_queue that also exists for pure passthrough request based
> devices.

Can't blk-throttle be used w/ bio based ones tho? I always thought that was
the reason why we didn't move it into rq-qos framework.

Thanks.

-- 
tejun
