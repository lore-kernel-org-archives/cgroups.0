From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH -next 2/5] blk-iocost: improve hanlder of match_u64()
Date: Sun, 30 Oct 2022 02:40:42 -0700
Message-ID: <Y15Gmj3an8htu61s@infradead.org>
References: <20221028101056.1971715-1-yukuai1@huaweicloud.com>
 <20221028101056.1971715-3-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=2ykxlIqvDiS9rzx3CBCb1mMm3H
        pBONfqkpi2dveLHayK367OaXJsEtqaOioxkQcMtbN280RX2e/zvvjbJ4c0E6PpNPROqtqRS+vkKDz
        WYq1nrJ+h3phloAbPxPUNPN7bcG24dh9yiAbOlatOaQPK9nUtTKRUbOLyg3JkEia4MAgWD9ErtL0l
        jEGLJwGLEmLjHeIxN/S+e9Cb6eVpqvsGi0gsua4zMGR3Ro4K2q+Kt82x7xdb5bS22Vcr0a+GvmhTM
        KhPabtAig+NnVOiD6JIXFSlGiavITqtokgfmo7/v6ZeI1yonGHKeNjbT9/4wjWe1ujhHhd2So6fZQ
        ejridjYA==;
Content-Disposition: inline
In-Reply-To: <20221028101056.1971715-3-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Looks good:

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
