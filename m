From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] block: cancel all throttled bios in
 blk_cleanup_queue()
Date: Wed, 22 Sep 2021 15:34:49 +0100
Message-ID: <YUs/CcSKqNoIIXoW@infradead.org>
References: <20210922125115.381752-1-yukuai3@huawei.com>
 <20210922125115.381752-5-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nHng5tIdS7Xn6BCJwl7sOAs/mlZQxYRxlcr0Xa3zcFk=; b=d5KDb4Prr992RAw/GFY1RWSeTa
        llNVgLQCmWqwpJ9JEciqBa+ARq9gF0XftN3ZJUTsyloNNDdiDQI3OmdDaH+X9My+XzMSAKGAn93uA
        yFwR2zypqoMgSNIuQT/mQrimgrfO+u3iCfWnLdFQxvlHHlnQKZSYK32iUAJMj2m4FEE1e8U70pKY/
        rhMKWOcvE8gsvY7MNVodijz20hqinhSIkM7wcTm1eD/wiaBmLJynw1nrkhh26aASYrmzVQZKPoVUq
        zNxjjF5SNzpo5xTycszrPX3VUMZ+LBz1KIFNs43+aG+Wr8V/nH6cVbBEmfgpJeJDm66+oIVlqXenI
        Drzp+MJw==;
Content-Disposition: inline
In-Reply-To: <20210922125115.381752-5-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3@huawei.com>
Cc: axboe@kernel.dk, tj@kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, yi.zhang@huawei.com

On Wed, Sep 22, 2021 at 08:51:15PM +0800, Yu Kuai wrote:
> Throttled bios can't be issued after queue is dying in
> blk_cleanup_queue(), thus it's better to cancel them immediately
> rather than waiting for throttle is done.
> 
> For example, if user thread is throttled with low bps while is
> issuing large io, and the device is deleted. The user thread will
> wait for a long time for io to return.

blk_cleanup_queue is too late, this will need to go into del_gendisk
and on top of my "tear down file system I/O in del_gendisk" series.
