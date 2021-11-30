From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 2/2] block: cancel all throttled bios in del_gendisk()
Date: Mon, 29 Nov 2021 22:43:59 -0800
Message-ID: <YaXIL3Kkwa56ANMe@infradead.org>
References: <20211130011730.2584339-1-yukuai3@huawei.com>
 <20211130011730.2584339-3-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ddVaDeU0Jvjl+Fe4JdR7EXlePtBzgo3q/f4WhbMSGg8=; b=zvinEgKsMo0VOvoNk6EqMfOTHA
        is82Ygjn7cQ+TV0DGLvAG6poLX6o+vpcCAYRCTLd88ob7yBNd5nqgWWxlpxCkIrsyFQ+6AmYq9EW/
        d0QgibAE31oSrDEWHigEeapOMOBq4LBXpJlHIxQoVWyVf8wuvLa5kfh64D2H/VoDuGk6YGydf2/lr
        l7T+8eMDaNU2lWYjmFDA7RCRe41Uikv8r2FMh6WNsZpYMPCeLrJY5AUecVjRLlYBRp3x15S6XwUXJ
        FQWZ85WTS/KJX22zZnBVlxpUlhFuNBh6I69Fz5zquYhAT0xjYOe00vvqHR9vE+PkyIA3ZHr8g8igp
        RdvGHtOg==;
Content-Disposition: inline
In-Reply-To: <20211130011730.2584339-3-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3@huawei.com>
Cc: hch@infradead.org, tj@kernel.org, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

This look fine to me, but I think someone who actually knows the
throttle code also needs to look over it.
