From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH -next 1/5] blk-iocost: cleanup ioc_qos_write() and
 ioc_cost_model_write()
Date: Sun, 30 Oct 2022 02:40:14 -0700
Message-ID: <Y15GfkfPNF7koVIa@infradead.org>
References: <20221028101056.1971715-1-yukuai1@huaweicloud.com>
 <20221028101056.1971715-2-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=dw8Bcab+STkBnrLeOp10Rwn1tH
        v89M0oZzyJgeAXhvmw+L6/WbN/cxniF6Q9NeCi2/aiqwFlbZBjScEMTx4a+1hlf+pgKGuWRCer8CD
        0vYnNUWkbfLp2v9s3wMzEf8IFWTwysJHE/qcffWZB8s0CPFSwj3E/s/Ca2+T5RxCLNUKsiiQXu3zW
        kpKCNfW87R4tcajAOUbd1VCsoZeDxI6K/ADOf0L434OpxYrOMjT+xxeeFIfyOgaxmTWfzfxneqnbF
        2Y+hDf/dOGn4ACgBka7QHbLrz+pO1u5mL6PTPorlf+uRG+Pqi/rZYJAzj9WPouiIoqGrjBx+w4FYF
        Ssl4Uzyw==;
Content-Disposition: inline
In-Reply-To: <20221028101056.1971715-2-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, yukuai3@huawei.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
