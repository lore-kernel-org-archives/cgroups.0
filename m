From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 15/15] blk-cgroup: move the cgroup information to struct
 gendisk
Date: Fri, 27 Jan 2023 14:13:42 -1000
Message-ID: <Y9RotmRIyv+2IEj9@slm.duckdns.org>
References: <20230124065716.152286-1-hch@lst.de>
 <20230124065716.152286-16-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fcu669nM+z2o5SFfsE7BkghAL02DbLfGfHTyhhM1+68=;
        b=UnSYqcDXBwiBNro4ZJ4iBT3fSVSziSa55q4eR7nZ4PL2nI9z58HOVgKY3LJB+AR4WV
         6CAhe3NzY5T8adzJiG8+J5uOXmPQu/jjEGm9BkTvHS2j3bMfHpiHGU76dn66tnNrR/j0
         +TNE/F/DsZlrWiMpa/1sxq4qRZ/YK9XEpiJrm0LMzp6Od6SjAiwbWeftU3Jwnekb3I8g
         jkCYH5FKw0mciGg4ntsuqv41388uSnQCJRkuIPDgDI4/5qdeDFAbxHjRP2LbHFjNPkeF
         dUrR3mN9SzSgEqL9T7xX/llBpmI1k5sPMpIh+btvrIcfabEaAjTYKPcfy6Ijsee1EF3z
         y9cQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230124065716.152286-16-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Andreas Herrmann <aherrmann@suse.de>

On Tue, Jan 24, 2023 at 07:57:15AM +0100, Christoph Hellwig wrote:
> cgroup information only makes sense on a live gendisk that allows
> file system I/O (which includes the raw block device).  So move over
> the cgroup related members.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Andreas Herrmann <aherrmann@suse.de>

The series looks fine to me other than the nits.

Thanks.

-- 
tejun
