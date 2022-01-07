From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH v5 2/2] block: cancel all throttled bios in del_gendisk()
Date: Fri, 7 Jan 2022 16:05:19 +0100
Message-ID: <20220107150519.GA26824@blackbody.suse.cz>
References: <20211210083143.3181535-1-yukuai3@huawei.com>
 <20211210083143.3181535-3-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1641567920; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bfQ8dZ9iOK4ZLIWBef694BJBh3Yngy+CFp1E53a7Fws=;
        b=TRUs8e0/wDCB4ZYfNA5EzrqFuAGe6CqZ/UVofHtzCN9TPfzt/deK6cukXraObSOV6GYD14
        TZiq2nFdtxCgiNm7Aw5xZoCJo60ZOZv5uMKTkB9IZ4CrrU+Kw6L77ORM6Qa7UV2hGz/LNx
        xbA/xsvyOMr1DxCxspQocSbeLORPUdo=
Content-Disposition: inline
In-Reply-To: <20211210083143.3181535-3-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3@huawei.com>
Cc: tj@kernel.org, hch@infradead.org, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

On Fri, Dec 10, 2021 at 04:31:43PM +0800, Yu Kuai <yukuai3@huawei.com> wrote:
> +	 * queue_lock is held, rcu lock is not needed here.
> +	 */
> +	blkg_for_each_descendant_post(blkg, pos_css, td->queue->root_blkg)
> +		tg_drain_bios(&blkg_to_tg(blkg)->service_queue);

FTR, I acknowledge this can work due to RCU peculiarities, however, I
don't understand why is it preferred against more robust explict
rcu_read_lock().

(All in all, this isn't a deal breaker and I'm not confident evaluating
the rest of the patch.)

Michal
