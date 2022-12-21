From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH -next 1/4] block/rq_qos: protect 'q->rq_qos' with
 queue_lock in rq_qos_exit()
Date: Wed, 21 Dec 2022 02:34:39 -0800
Message-ID: <Y6LhPwnAns/R5NS7@infradead.org>
References: <20221217030908.1261787-1-yukuai1@huaweicloud.com>
 <20221217030908.1261787-2-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=EZOx6hZJqFrvGMRUreIdO6L7sB
        Hk7plpe8asFJ7bT6cZIYNpUsKwJr7Yvla9zFjv11M8bfxfghtK3F6NbipUw0hzsh0ZQIZe3ea7R2M
        HislXoZzdx7cTfrplRaMvGMlg1v/uaUIvqtD/p0UuO83dsmzo2k8mJ+gUOBQQICTLI0bwyv8f2MGA
        Wpwpe4vQBPvjXKC/g24BnzxJ/T4OVk9K0Pq4DejZ6IB5/2wvMVRqQpOAG4savvYV/EUWtwGBYt47l
        nrqUtQyhO4fI+NSoCXi0lMX82PIMAIE1X9u+X6Sxnk5SX0f0hBos6+zOTT21bi2Nb9DMZt+67reVA
        gtcsuXjw==;
Content-Disposition: inline
In-Reply-To: <20221217030908.1261787-2-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: tj@kernel.org, hch@infradead.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
