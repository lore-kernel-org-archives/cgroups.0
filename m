From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 1/2] blk-iocost: add refcounting for iocg
Date: Tue, 10 Jan 2023 08:36:07 -1000
Message-ID: <Y72wF/b0/xNRmP7f@slm.duckdns.org>
References: <20221227125502.541931-1-yukuai1@huaweicloud.com>
 <20221227125502.541931-2-yukuai1@huaweicloud.com>
 <Y7XzUee5Bq+DoIC1@slm.duckdns.org>
 <c63ee2ad-23d5-3be0-c731-28494398b391@huaweicloud.com>
 <Y7cX0SJ0y6+EIY5Q@slm.duckdns.org>
 <7dcdaef3-65c1-8175-fea7-53076f39697f@huaweicloud.com>
 <Y7iCId3pnEnLqY8G@slm.duckdns.org>
 <875eb43e-202d-5b81-0bff-ef0434358d99@huaweicloud.com>
 <Y7xbpidpq7+DqJan@slm.duckdns.org>
 <a71f997f-6cae-d57b-85dd-2fd499d238f6@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mx/8qw1hk0L/Apnt3h31WEr91WdxE2C/9NCB2yBSTjc=;
        b=o2u7cWdt7toQAtBB1r2+RF8CrYllIElK6OiiBW7wEL36HiAiGM6Y5Y+GSqXBnLwxof
         J2CX/fG3C6YW+hxVwI3eD3mFXEqOg0pczDLmkdUuC7ijnZVTZ7zLy8TTI6d+2SWSJE0P
         mCu0rClnWtooXrdXjRBb8yufcNeAk4c5ASu97PPYq1oL91DFQ3NbFOeFtPDTcRxTIHV6
         0ZcAcwd7KaO6JwF8M6jRYCQZJZ4RdGVQVHB6czKnlkllG/V4R2epPHHYLQ7H3JDqT7kq
         XbFF1cm+bjAAjJG7jXWjXI6N0/DHD9dcbNGLAB3FHCwiCggwtAh63+EFIxdhADoi3qPZ
         yIHQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <a71f997f-6cae-d57b-85dd-2fd499d238f6@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@infradead.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hello,

On Tue, Jan 10, 2023 at 09:39:44AM +0800, Yu Kuai wrote:
> As I tried to explain before, we can make sure blkg_free() is called
> in order, but blkg_free() from remove cgroup can concurrent with
> deactivate policy, and we can't guarantee the order of ioc_pd_free()
> that is called both from blkg_free() and blkcg_deactivate_policy().
> Hence I don't think #3 is possible.

Hahaha, sorry that I keep forgetting that. This doesn't really feel like
that important or difficult part of the problem tho. Can't it be solved by
synchronizing blkg free work item against the deactivate path with a mutex?

Thanks.

-- 
tejun
