From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH -next 4/5] blk-iocost: fix sleeping in atomic context
 warnning in ioc_qos_write()
Date: Sun, 30 Oct 2022 02:55:23 -0700
Message-ID: <Y15KC8Zb3rHlfTPu@infradead.org>
References: <20221028101056.1971715-1-yukuai1@huaweicloud.com>
 <20221028101056.1971715-5-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=g7Lk2AACYfeSSiMJolbOzZmDEQzhYOjjt7qCWTh9D7c=; b=ppG1biGCc1of+Ow35yp36kix63
        jxcRvFnP4kJarQFIsgiJcoL1fby9wRTSG/y4WgqohBEYmonaa+FUYe0Rh6HJj75Dxb8TlbmaEcbor
        uUbCyScp6AlduacOrjubqONaTRUMcGm+etDbIs+royqhL9LxRhvGLbRWGc3pg9Zp6PLkpDpqGZRe1
        lRsZZdFCIPFoYdrdy4ShrBJEYuwzG1bwy+IFqc3wLeS/D0smO5ZRk59TNPVQjZ/owHbE4C/Gvj8Ei
        W0wADly4N6Dnawu4BxLJhGJZjEqSDu5sgbOhiDuFwRzmeBojCGwou0eoeXrzLEwIPrjdk9rhbvVuY
        Mq6DleTg==;
Content-Disposition: inline
In-Reply-To: <20221028101056.1971715-5-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

This seems a little convoluted to me.  I'd suggest to add a new
sleeping lock that protects the updates, then you just take the
spinlock after parsing without much other changes.

(The same comment also applies to patch 5).
