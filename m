From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] blk-throttle: remove THROTL_TG_HAS_IOPS_LIMIT
Date: Fri, 23 Sep 2022 17:31:57 -1000
Message-ID: <Yy56LetUKrB8ycLP@slm.duckdns.org>
References: <20220921095309.1481289-1-yukuai1@huaweicloud.com>
 <20220921095309.1481289-2-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=7UxaMSnoHFzKmnse8cgID7UiEyz32CZmEXoNfbymFKQ=;
        b=PcmPyGgiv4lXxe+D5CPejl9Scwfvp5/ZJtRkJGO2J9qugHSZFM7Afyn1mGXZ3xQp8S
         sSrY8GNFqbsAjwF6oyBd28uTehERinOP+wpQS/C9IwFIXCQ7g0jQkUECEK5jmCfrhuT3
         BtDIMNCQLsPdQ0vTm2nYuPzfAKKKCdAgTQ+luINniSNY0Hs8474Jtj6OAXJKLh4zWBFQ
         fzoGQshcv27S+NBTsS9PhIE8kNxA+NVQucj61j7skWo3KBt4OUsgb520mqHSXc1WAeBX
         Ie2mQ3u2E4cgY7x3WcYAbgit+OZMdg/w1fG0RO6sg+BTkoJNlfEkI7tLDw0lgQxiS5Ns
         XYVg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220921095309.1481289-2-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

On Wed, Sep 21, 2022 at 05:53:08PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Currently, "tg->has_rules" and "tg->flags & THROTL_TG_HAS_IOPS_LIMIT"
> both try to bypass bios that don't need to be throttled, however, they are
> a little redundant and both not perfect:
> 
> 1) "tg->has_rules" only distinguish read and write, but not iops and bps
>    limit.
> 2) "tg->flags & THROTL_TG_HAS_IOPS_LIMIT" only check if iops limit
>    exist, read and write is not distinguished, and bps limit is not
>    checked.
> 
> tg->has_rules will extended to distinguish bps and iops in the following
> patch. There is no need to keep the flag.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Acked-by: Tejun Heo <tj@kernel.org>

> @@ -183,11 +182,6 @@ static inline bool blk_throtl_bio(struct bio *bio)
>  {
>  	struct throtl_grp *tg = blkg_to_tg(bio->bi_blkg);
>  
> -	/* no need to throttle bps any more if the bio has been throttled */
> -	if (bio_flagged(bio, BIO_BPS_THROTTLED) &&
> -	    !(tg->flags & THROTL_TG_HAS_IOPS_LIMIT))
> -		return false;
> -

This temporary removal would break the double accounting until the next
patch, right? That might be worth noting but this looks like an okay way to
go about it.

Thanks.

-- 
tejun
