From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 01/10] blk-throttle: correct stale comment in
 throtl_pd_init
Date: Wed, 30 Nov 2022 11:08:13 -1000
Message-ID: <Y4fGPUBBExrm51IH@slm.duckdns.org>
References: <20221129030147.27400-1-shikemeng@huawei.com>
 <20221129030147.27400-2-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8GLeq4y1VkLChDK5qxV6t3jjI/iORg+c6M0TmX7kjP0=;
        b=Apb1iWUbB5ph59NuwWq3GeIe1SG2Xnc2Ghfh+Z512kKQUVy0BHy8Xe+4CIpU3ulszy
         ub8Y8NyUuKCdKtNJLSmNvH4De+/haJKxfuhQ7yUKzGvKD1mvcWbguLuzaHQmzJJTc1S6
         /33FyHfpujuR0xIbLnLep+jOM+VjSELx9XKKIcX3B71jHSbtdZbUMu51k2Oq4nuBYwbO
         ulz6t7yHPpy26DRout3+gghJB/gLn8kQ1gWJZrzKRVxd811jlCPKStDzfP24BW0sAJvL
         wtUHeT/WqoRZm5jQ9rEiykrgkPYa8C8TCSNaPo3WKCnH5E4kabr+VplL0w8PkcLQW1Ah
         kiBQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20221129030147.27400-2-shikemeng@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kemeng Shi <shikemeng@huawei.com>
Cc: josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Nov 29, 2022 at 11:01:38AM +0800, Kemeng Shi wrote:
> On the default hierarchy (cgroup2), the throttle interface files don't
> exist in the root cgroup, so the ablity to limit the whole system
> by configuring root group is not existing anymore. In general, cgroup
> doesn't wanna be in the business of restricting resources at the
> system level, so correct the stale comment that we can limit whole
> system to we can only limit subtree.
> 
> Signed-off-by: Kemeng Shi <shikemeng@huawei.com>

Acked-by: Tejun Heo <tj@kernel.org>

> +	 * read_bps limit is set on a "parent" group, summary bps of
> +	 * "parent" group and its subtree groups can't exceed 16M for the

but why the quotes around parent?

-- 
tejun
