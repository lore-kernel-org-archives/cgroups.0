From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 1/2] blk-iocost: add refcounting for iocg
Date: Wed, 11 Jan 2023 07:07:29 -1000
Message-ID: <Y77s0f741mFfGlTO@slm.duckdns.org>
References: <Y7XzUee5Bq+DoIC1@slm.duckdns.org>
 <c63ee2ad-23d5-3be0-c731-28494398b391@huaweicloud.com>
 <Y7cX0SJ0y6+EIY5Q@slm.duckdns.org>
 <7dcdaef3-65c1-8175-fea7-53076f39697f@huaweicloud.com>
 <Y7iCId3pnEnLqY8G@slm.duckdns.org>
 <875eb43e-202d-5b81-0bff-ef0434358d99@huaweicloud.com>
 <Y7xbpidpq7+DqJan@slm.duckdns.org>
 <a71f997f-6cae-d57b-85dd-2fd499d238f6@huaweicloud.com>
 <Y72wF/b0/xNRmP7f@slm.duckdns.org>
 <53b30ac8-d608-ba0b-8b1b-7fe5cfed6d61@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k4Ltazrwl/l2bFldORo8VUeEFxLxrMEFR8+gfbzAdUs=;
        b=UFZI8xA6j4lfGzbM+8ybzfcwAYyEF34IaXTIqMSvwvftTCWP9LC1faQd84iRVL4+jV
         FLLFGnk2vFj2dT7UTT/jZmZqv9xxQaMdNmr6o3vp+pNFs6pHSg4wt6q2qm5D+6yEum+6
         +L0s467ooed8epoM+osT2be4A08T70dM2vdnbZzqgbN3DFR4Jc6FPO8L6IyDaEH3rAb9
         QiY91aVQ4jjoTHOrJ6Wc6CW/AazOVENVedlX5hIL6lyuP4QZzHPqJQBxIEB1szKpOG9z
         tRjimvJNb8NkZCYdxnLQPTfKuSOE7dNaoUqA1zdGxvfSp5vCrEiemfAFc6a6vdxQaSw1
         83qA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <53b30ac8-d608-ba0b-8b1b-7fe5cfed6d61@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@infradead.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hello,

On Wed, Jan 11, 2023 at 09:36:25AM +0800, Yu Kuai wrote:
> I'm not sure, of course this can fix the problem, but two spinlock
> 'blkcg->lock' and 'q->queue_lock' are used to protect blkg_destroy()
> currently, add a mutex=EF=BC=88disk level?) requires a refactor, which se=
ems
> complex to me.

The fact that the two paths can race each other already seems buggy. e.g.
What prevents them from running pd_free on the same pd twice? So, it needs
to be fixed anyway and the intention always has been that these callbacks
are called in the correct traversal order.

Thanks.

--=20
tejun
