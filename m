From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 4/5] blk-iocost: fix sleeping in atomic context
 warnning
Date: Tue, 22 Nov 2022 14:42:08 -1000
Message-ID: <Y31sYFdA2lHIvjt3@slm.duckdns.org>
References: <20221104023938.2346986-1-yukuai1@huaweicloud.com>
 <20221104023938.2346986-5-yukuai1@huaweicloud.com>
 <Y3K8MSFWw8eTnxtm@slm.duckdns.org>
 <3da991c6-21e4-8ed8-ba75-ccb92059f0ae@huaweicloud.com>
 <Y306xJV6aNXd94kb@slm.duckdns.org>
 <1f52ccb1-c357-a2a0-ef9d-48d7e2eb51f8@kernel.dk>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QBgNP0HxZqEmc/2hnmKVV8WQI9992gjmzgYgDwpjSpA=;
        b=AMxaAaqozpiEIqVSD0dnERL7aTmBQ+mWEkbAkNKt57+j7WUWbOEYANuBlKIshObE7V
         FtRNcmRfpQYu6RVscVuW2wJEBjLW/APviQcpCqWhkRfWEQbpHb4RHBx8DVhAfXLdkopA
         aRY2Qoo9/iB/mo9wd3jZIQEmr8ohNIPISRDiSLNpj11QoG4igApiy8SZHr9v9WDcCGsC
         68dZNoVEPocgQXaf2sxmHLlRqBCrimoKD5Ou1+/f60sQl1M42NS7+c/0iLX50G1I0TDl
         XUqkCueyjZdyoaITTPMSK9NwX/FsmV8feYdp4Opfi5pulqkKp64DsutTrOBnlwqLrZh9
         hXOg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <1f52ccb1-c357-a2a0-ef9d-48d7e2eb51f8@kernel.dk>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, hch@lst.de, josef@toxicpanda.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

On Tue, Nov 22, 2022 at 05:14:29PM -0700, Jens Axboe wrote:
> >> Then match_strdup() and kfree() in match_NUMBER() can be replaced with
> >> get_buffer() and put_buffer().
> > 
> > Sorry about the late reply. Yeah, something like this.
> 
> Doesn't local_irq_disable() imply preemption disable as well?

Right, I was thinking about spin_lock_irq() which doesn't imply disabling
preemption in PREEMPT_RT. local_irq_disable() is actual irq disable even on
RT. It should be fine on its own.

Thanks.

-- 
tejun
