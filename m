From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/4] blk-cgroup: Remove unnecessary blk_ioprio_exit in
 blkcg_init_queue
Date: Mon, 10 Oct 2022 00:37:38 -0700
Message-ID: <Y0PLwj/l/l4QPpTC@infradead.org>
References: <20221010023859.11896-1-shikemeng@huawei.com>
 <20221010023859.11896-2-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NMxgP/FowzLAsvzkIOCbfXDAaqlRHaeSOJVqOvK8ueY=; b=jfESnPEgf6DUuY25FlxRg/rFE7
        XJJAifuTda3jbdwAcm0O5obHOq0zPY9jRlzI9zT1fOXiJwvLvygK/G2T8xPpDEm0pjlVHXQI+gxkw
        3Ffn1eYqyYjp7OlTDFfUIsDXFaJwpCtZ/h7KCtDRIiCZh/9Cf7peiQCEQ0pPBz0py7f3cnH7oma2Q
        PIO4YZAs4x2gU1jX7B4Nn7TMFvP7lDLPWT9//+E09+QVTk3yQOruxTJewxCpjfNAeBcMdH6xiz/+t
        tavKqa8sKRJB5HHpl/mDSZHUctjpLCE5qx3Omgcy2UG1Pb+yNixnm54w38wl/tIg1FX4ZkfyTL1PL
        zvw70Lsw==;
Content-Disposition: inline
In-Reply-To: <20221010023859.11896-2-shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Oct 10, 2022 at 10:38:56AM +0800, Kemeng Shi wrote:
> Function blk_ioprio_init only alloc blkg_policy_data which will be freed
> in blkg_destroy_all, so no blk_ioprio_exit is called when blk_throtl_init
> is failed in blkcg_init_queue. Also blk_ioprio_exit is not called in
> blkcg_exit_queue for the same reason. Just remove blk_ioprio_exit to
> keep behavior consistent.

This code looks very different in current mainline.

