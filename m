From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH -next 3/5] blk-iocost: don't allow to configure bio based
 device
Date: Sun, 30 Oct 2022 02:41:47 -0700
Message-ID: <Y15G2zBpor5flDLy@infradead.org>
References: <20221028101056.1971715-1-yukuai1@huaweicloud.com>
 <20221028101056.1971715-4-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mGekaAOdIja1Coan0T/XXSeb3SnqS47JFAz2HGqAANA=; b=h7eeAKOst8GmseL3Ly3xX57sZP
        eYrLBzlbIi8+fy2qAhn4gfhf/B3MeoR5WVcg2HPvfckUYTT1MtpvRtk9G8yd3UnqQ/DqGIaWCaLg/
        i3za0UnvN9m4OCwq80+4TVSmEkE8WIwTID9x3i7UR6c1hnDFuflasw1gjffbkVwQw8D2RNg9ANEvT
        kTwQiwxgw3MTC3goiJLBZkSWrNXw8R4gy9U2nPRnCxBpZQkMoiXU+Fq0cvEtHciExojvLSmVHEy2m
        NP82jmZ0jT3u/oEkdCZTnjr4tH6sBdXmZ6Z4NwV4KxZyGa21iHKgGJ/AiT6zBM0ZJae+bi8cxvPMC
        wBNtQL8Q==;
Content-Disposition: inline
In-Reply-To: <20221028101056.1971715-4-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, yukuai3@huawei.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

Looks good (I actually stubled over this a few days ago as well):

Reviewed-by: Christoph Hellwig <hch@lst.de>
