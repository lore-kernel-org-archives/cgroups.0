From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 3/4] blk-throtl: introduce blk_throtl_cancel_bios()
Date: Mon, 29 Nov 2021 03:47:11 -0800
Message-ID: <YaS9v+x2ofp+9jQn@infradead.org>
References: <20211127101059.477405-1-yukuai3@huawei.com>
 <20211127101059.477405-4-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=sS1UF3+KLoSiOG3o2982PPolKEnQICmz9dBEx8rZQgw=; b=3ozHs8KOkUIsJOlFd0kIUXHuQE
        8W7ozvGgn/gfccir/W0Zdzs1P+oLIVQmqy9uvTxeViJ0XUHe4og1HjqPJH5PAP0TvoPcAZGeQuUZm
        NgsUmcU4MvqxyRSRCq1g5+3cW23OYcK1wTmLTNP/C1db3o0/2X0bQKnC1wpR6LIx1DMoQRISHv8ry
        sFpVFPeTskMa2fNZ70RJ022TbWhKFn5e4aWGVq61F5oB19iSA2jzatZMFLhCCsafrq9lAVNAtkPTC
        tJVcPI085lNsnv+aZHS8m/VOVjKqYXIkYqJ5scgGik1GzjEJ03K6I18UpmAI9lZsFRPzbvXxcrt99
        ImFKw4IQ==;
Content-Disposition: inline
In-Reply-To: <20211127101059.477405-4-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Sat, Nov 27, 2021 at 06:10:58PM +0800, Yu Kuai wrote:
> This function is used to cancel all throttled bios. Noted this
> modification is mainly from revertion of commit b77412372b68
> ("blk-throttle: remove blk_throtl_drain").

This should also go into the last patch.
