From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 05/11] blk-throttle: simpfy low limit reached check in
 throtl_tg_can_upgrade
Date: Wed, 23 Nov 2022 08:26:37 -1000
Message-ID: <Y35l3cRfYNgCzBgC@slm.duckdns.org>
References: <20221123060401.20392-1-shikemeng@huawei.com>
 <20221123060401.20392-6-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4as57wCvzop8813r3sliHAbaPmxH6ev1auHMwbNdJIo=;
        b=q5rmbKCsyxcX9QqNlu0c2EogSV6OPZ0rXgI0AWmUGlsn6T2cqXAl7igKciAlxyJ5ro
         GQh8tLG5VsdJgCYuyHiFuBPZbLx5qiYLxP11cqxAkaoivBXcaEMcD3Fl0SJwdjeJ0Kzm
         P2LbtGrMKAStFpoQhjZgkgoJ5P4A77HKfdBacxMCDQWLQZ4fOu9vujP2Tkw865riEvVy
         kHIaGkczm4l3CNWEB9lp2GUJgJvNiCmw/XEPl1vmtqklW3PHH6z8Xm1wiiUML/Jt8usc
         h+iAm8CYHS0m8fD9auKC9g62A6VYQL2l1AIM67SSjQ4nlVnwYPgVl3m8nqSRQCGCSgrR
         Ptdw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20221123060401.20392-6-shikemeng@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kemeng Shi <shikemeng@huawei.com>
Cc: josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Nov 23, 2022 at 02:03:55PM +0800, Kemeng Shi wrote:
> -static bool throtl_tg_can_upgrade(struct throtl_grp *tg)
> +static bool throtl_tg_reach_low_limit(struct throtl_grp *tg, int rw)
>  {
>  	struct throtl_service_queue *sq = &tg->service_queue;
> -	bool read_limit, write_limit;
> +	bool limit = tg->bps[rw][LIMIT_LOW] || tg->iops[rw][LIMIT_LOW];
>  
>  	/*
>  	 * if cgroup reaches low limit (if low limit is 0, the cgroup always
>  	 * reaches), it's ok to upgrade to next limit
>  	 */
> -	read_limit = tg->bps[READ][LIMIT_LOW] || tg->iops[READ][LIMIT_LOW];
> -	write_limit = tg->bps[WRITE][LIMIT_LOW] || tg->iops[WRITE][LIMIT_LOW];
> -	if (!read_limit && !write_limit)
> -		return true;
> -	if (read_limit && sq->nr_queued[READ] &&
> -	    (!write_limit || sq->nr_queued[WRITE]))
> -		return true;
> -	if (write_limit && sq->nr_queued[WRITE] &&
> -	    (!read_limit || sq->nr_queued[READ]))
> +	return !limit || sq->nr_queued[rw].
> +}
> +
> +static bool throtl_tg_can_upgrade(struct throtl_grp *tg)
> +{
> +	if (throtl_tg_reach_low_limit(tg, READ) &&
> +	    throtl_tg_reach_low_limit(tg, WRITE))

Are the conditions being checked actually equivalent? If so, can you
explicitly explain that these are equivalent conditions? If not, what are we
changing exactly?

Thanks.

-- 
tejun
