From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] blk-ioprio: Introduce promote-to-rt policy
Date: Mon, 27 Feb 2023 14:03:05 +0100
Message-ID: <20230227130305.2idxwmz2kdnacolc@quack3>
References: <20230220135428.2632906-1-houtao@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1677502985; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B7AF3j/D3PPFmjhvHIOXz9dOZpP3jlwrUSkvsPwPPVw=;
        b=R9cpBWOqSKYamPQ0smruJPhZi21kgSt1HeK8Vd6MYJuf4nRYXLqJpylLgAeW2clXo8eJoB
        G3m8QZO209XhYy0EmxZBUTwNTakGpQ2vjzId9qXQDzU4w+9CKuYRq8xpHfYe6b0/fXwjOU
        ySs2nBeLQ0mpUBF34MDCsfqUi8dO2rg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1677502985;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B7AF3j/D3PPFmjhvHIOXz9dOZpP3jlwrUSkvsPwPPVw=;
        b=I8LQCm2Z+35iE4ZfbLhlBJ+67ZQfu3wNTkoodTYnJfXfWH5uG/Pj4pp3CrV73TmGcqTX3t
        1Uc6HAXePxCcTgCw==
Content-Disposition: inline
In-Reply-To: <20230220135428.2632906-1-houtao@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hou Tao <houtao@huaweicloud.com>
Cc: linux-block@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, Jan Kara <jack@suse.cz>, Bagas Sanjaya <bagasdotme@gmail.com>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, houtao1@huawei.com

On Mon 20-02-23 21:54:28, Hou Tao wrote:
> From: Hou Tao <houtao1@huawei.com>
> 
> Since commit a78418e6a04c ("block: Always initialize bio IO priority on
> submit"), bio->bi_ioprio will never be IOPRIO_CLASS_NONE when calling
> blkcg_set_ioprio(), so there will be no way to promote the io-priority
> of one cgroup to IOPRIO_CLASS_RT, because bi_ioprio will always be
> greater than or equals to IOPRIO_CLASS_RT.
> 
> It seems possible to call blkcg_set_ioprio() first then try to
> initialize bi_ioprio later in bio_set_ioprio(), but this doesn't work
> for bio in which bi_ioprio is already initialized (e.g., direct-io), so
> introduce a new ioprio policy to promote the iopriority of bio to
> IOPRIO_CLASS_RT if the ioprio is not already RT.
> 
> So introduce a new promote-to-rt policy to achieve this. For none-to-rt
> policy, although it doesn't work now, but considering that its purpose
> was also to override the io-priority to RT and allow for a smoother
> transition, just keep it and treat it as an alias of the promote-to-rt
> policy.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

Just one question regarding doc below:

> ++----------------+---+
> +| no-change      | 0 |
> ++----------------+---+
> +| rt-to-be       | 2 |
> ++----------------+---+
> +| all-to-idle    | 3 |
> ++----------------+---+

Shouldn't there be preempt-to-rt somewhere in this table as well? Or why
this this in the doc at all? I'd consider the numbers to be kernel internal
thing?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
