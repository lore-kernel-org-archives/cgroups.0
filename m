From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 06/19] blk-cgroup: pin the gendisk in struct blkcg_gq
Date: Thu, 2 Feb 2023 14:15:59 -1000
Message-ID: <Y9xSPzSO9BMEpMQE@slm.duckdns.org>
References: <20230201134123.2656505-1-hch@lst.de>
 <20230201134123.2656505-7-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pKEGQCCzdWypotNm7WYkoeCFjmvtMpWtkZlxKvwri/A=;
        b=CO95XYz7/bB9i/4EE0M4Wwtg8kqrsw2ACX/54im0SGAa2JPI6mqMtPWobbrVqcXXq4
         WJRlB4eXZn0ZHRBir2rp395f/rsL9vmohFD5sDv/r61i3drJ/KT/DO9oDHaD2184r15Q
         fTm9U8+4iZepuHhSyQzL4I1siv2ReEVKipVI8vY6DsL+ZFle460mvCyURvkYwo2Si0mg
         Fw9haxp40zIthmx+qUavZv95PzVJW//QE/aPb1PaBYgt1a0LQjfXnWCftyKZykgJM7th
         /tRNfsOi4HduBifqMV7fwTTu7ZTJUdYcoxHR5dvMTAeIUZkKrdKDlMZBgXJ+8gsYsVk/
         xnBg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230201134123.2656505-7-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Andreas Herrmann <aherrmann@suse.de>

On Wed, Feb 01, 2023 at 02:41:10PM +0100, Christoph Hellwig wrote:
> Currently each blkcg_gq holds a request_queue reference, which is what
> is used in the policies.  But a lot of these interfaces will move over to
> use a gendisk, so store a disk in struct blkcg_gq and hold a reference to
> it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Andreas Herrmann <aherrmann@suse.de>

For 05 - 06:

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
