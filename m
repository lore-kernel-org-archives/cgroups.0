From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 1/2] blk-iocost: add refcounting for iocg
Date: Thu, 5 Jan 2023 08:32:49 -1000
Message-ID: <Y7cX0SJ0y6+EIY5Q@slm.duckdns.org>
References: <20221227125502.541931-1-yukuai1@huaweicloud.com>
 <20221227125502.541931-2-yukuai1@huaweicloud.com>
 <Y7XzUee5Bq+DoIC1@slm.duckdns.org>
 <c63ee2ad-23d5-3be0-c731-28494398b391@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3EeGNF5xHs7sa7n7ZiCZflKuJGwYRLGHpWxAaRy01+4=;
        b=kUNN2cTNsj/b/55vlzGN+y0U6V9ZyiXDdNzPzxqqj9oo7Roqr6UEJ9qqTk4+6j9f6J
         61L1iPQS88OfzaJZVuayJzm9pl15tC+jOmAMCU6JQ9HkKFBgNhmiUUk0uAShnufjANDU
         h2oM3xF4cdvftyhjsNPxRRhbXwTgx2vG0CXsHgbL4vV0H1PdHs9WbBba1QEa2HgxZb+L
         MhkW5xMVcx/d2Nd0jBJO7HWSNJrMEoRw2RurqciPBx+C5S58cfqdp5vONRlraL165Wnz
         kerx6YfAoBdwHqJwzwtaqmeUfK8oupeAI/vT400AbrbpGSWyOqpGhTZUbbl5BxEhYV51
         NlXQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <c63ee2ad-23d5-3be0-c731-28494398b391@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@infradead.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

On Thu, Jan 05, 2023 at 09:14:07AM +0800, Yu Kuai wrote:
> 1) is related to blkg, while 2) is not, hence refcnting from blkg can't
> fix the problem. refcnting from blkcg_policy_data should be ok, but I
> see that bfq already has the similar refcnting, while other policy
> doesn't require such refcnting.

Hmm... taking a step back, wouldn't this be solved by moving the first part
of ioc_pd_free() to pd_offline_fn()? The ordering is strictly defined there,
right?

Thanks.

--
tejun
