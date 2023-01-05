From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -next 3/4] block/rq_qos: use a global mutex to protect
 rq_qos apis
Date: Thu, 5 Jan 2023 08:34:17 -1000
Message-ID: <Y7cYKdOwSlfHtj7t@slm.duckdns.org>
References: <20230104085354.2343590-1-yukuai1@huaweicloud.com>
 <20230104085354.2343590-4-yukuai1@huaweicloud.com>
 <Y7XyIzGptuqO8EAt@slm.duckdns.org>
 <Y7YZnM/nqb0gxOei@slm.duckdns.org>
 <df2f7a60-467f-08ce-2a3e-1dc7853424aa@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2mQKhwxd6wO5ViZt789nL1Ad7LwoQ9znLjQqgKEtgoc=;
        b=PLmnhW6S/xa9/GRccEErxoGsX8p0bhIfLgXwql14zIkCBWjVtDCYlHmGQLvE31isNO
         tVJ1CstNrlD0nBt/dBg5AvGe0E4XKNhI6mbH/PilnX2lXQB/pp+BhhWNW8yWynT2ZMjP
         O0oaobYqAg4iYrn8VCx/tSwgyAud0Ua0yr6ohF4kZKd75dhVsoMcZttGL4+TkOeWxdZY
         OxFdj47cNiGxRiLzqF7l1+4VDB3dklXsdNjhJ9Ye7tTTTWMeUuRFZL+3zqzA4/gcmPnl
         3HyN+fjmR0Qo8p7Vp+g30s1g9wg5mpF96GXmubWMCjhOF5NkSs1ky6ug9HgyZyQ/DXCz
         zB2w==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <df2f7a60-467f-08ce-2a3e-1dc7853424aa@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@infradead.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hello,

On Thu, Jan 05, 2023 at 09:35:21AM +0800, Yu Kuai wrote:
> > Can you please take a look at the following patchset I just posted:
> > 
> >    https://lkml.kernel.org/r/20230105002007.157497-1-tj@kernel.org
> > 
> > After that, all these configuration operations are wrapped between
> > blkg_conf_init() and blkg_conf_exit() which probably are the right place to
> > implement the synchronization.
> 
> I see that, blkg_conf_init() and blkg_conf_exit() is good, however there
> are some details I want to confirm:
> 
> 1) rq_qos_add() can be called from iocost/iolatency, where
> blkg_conf_init() will be called first, while rq_qos_add() can also be
> called from wbt, where there is no blkg_conf_init(). Hence it seems to
> me we need two locks here, one to protect rq_qos apis; one to
> synchronize policy configuration and device removal.

wbt's lazy init is tied to one of the block device sysfs files, right? So,
it *should* already be protected against device removal.

Thanks.

-- 
tejun
