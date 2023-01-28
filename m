From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 09/15] blk-rq-qos: make rq_qos_add and rq_qos_del more
 useful
Date: Fri, 27 Jan 2023 14:01:08 -1000
Message-ID: <Y9RlxFAbTLXmdeLV@slm.duckdns.org>
References: <20230124065716.152286-1-hch@lst.de>
 <20230124065716.152286-10-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LpMQgFXEefyXNUoYBfMtTjQTSA4v50OzgpKHMdUAv0Y=;
        b=YJVu2wQU5OSQO/JJ83OnSM/cP0ME9kQ+Ln4uX/iSrjyTyHBPm/lLCwAS08fPCDvIH5
         FYJFAMDtIBnDI6Y/Lgo+tSwAUgyBHox02ITFyx/Yjt9heQZWbbh/TZQbjG0JlhNunmBp
         TJys6Kx/wJODfbi4I99kcDrMCu5vDURITKTDbIXJDFsFWXjy354q+aip37wplh8eacYV
         MLMOOPz1ndvyucc5eeLPdHjYnUETdqIvq7ocWPuWba/mlCReYqfL/57LUao5JGHeqBYx
         g5EcFuiGCGwFmBXUd2tsQ1eTd5TskPNQBXCkP+hZndDyQI0Y4Ao516BmdG2+bUDoHiR3
         /9Ig==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230124065716.152286-10-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Andreas Herrmann <aherrmann@suse.de>

On Tue, Jan 24, 2023 at 07:57:09AM +0100, Christoph Hellwig wrote:
> Switch to passing a gendisk, and make rq_qos_add initialize all required
> fields and drop the not required q argument from rq_qos_del.  Also move
> the code out of line given how large it is.

Sorry about all the nit picks but can you please separate out the uninlining
into its own patch? Code move + small changes in the same patch can be error
prone.

Thanks.

-- 
tejun
