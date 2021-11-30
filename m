From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 2/2] block: cancel all throttled bios in del_gendisk()
Date: Tue, 30 Nov 2021 06:26:18 -1000
Message-ID: <YaZQqjjygHGFEdbx@slm.duckdns.org>
References: <20211130011730.2584339-1-yukuai3@huawei.com>
 <20211130011730.2584339-3-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c5SAYFCCSK5GacjcTQ47eQM20SEI2kSoxxYyDX/fm7g=;
        b=WuEA+bpfKYR9NLIIrwBgv9GJy2Sqs3GbI0IIf9pwMJMXsSCI1YQlAwXknLH/wTYAJD
         iGJxHYd9gWOMumxRX60SU8m9X3a96QJvwABQJSaLk/UwYX0oTzfvE1+mD/pTCPZVc0wX
         nwyTRT6H3nMscuCpww4ouTekbvVnImtzQkpCVviTPQrvcD3++XkUgRUtDbtMgc7kfIOS
         v9YgrBcEvackhH95vp53qGHa4xAKTe1iz3Dcs5hW3xJm1hr3bo+M8kG/vVt5vEAtyGLx
         pvSMzYNsPvDpfVl30+ppF1Aec1+VsyI9Ru7Iz3AJ2tJGdoavpTMIp8Og6Cbz837agOq1
         KPdQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20211130011730.2584339-3-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3@huawei.com>
Cc: hch@infradead.org, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

Hello,

On Tue, Nov 30, 2021 at 09:17:30AM +0800, Yu Kuai wrote:
> +void blk_throtl_cancel_bios(struct request_queue *q)
> +{
> +	struct throtl_data *td = q->td;
> +	struct blkcg_gq *blkg;
> +	struct cgroup_subsys_state *pos_css;
> +	struct bio *bio;
> +	int rw;
> +
> +	rcu_read_lock();

So, all of the draining is being performed without holding the q lock, which
*might* be okay given that we're in the del_gendisk path but is likely risky
- ie. there can still be timers or whatever racing against it.

Thanks.

-- 
tejun
