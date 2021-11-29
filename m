From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/4] Revert "blk-throttle: remove tg_drain_bios"
Date: Mon, 29 Nov 2021 03:45:36 -0800
Message-ID: <YaS9YPSAZgkNgxTb@infradead.org>
References: <20211127101059.477405-1-yukuai3@huawei.com>
 <20211127101059.477405-2-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Zr4yGvG1oSJLft11tGwyOTizPULLeTWpauYnh23nKIU=; b=qRq17tcdjDfrmVPqdGTaujU82V
        USUu58An8ugaQWMaf2IWlA84cAcGSoO5C8pzpMMR6W3Fjv5V2CiX2jPdY4ge+zyXoBp74pw5MBxTu
        cShHoey1ReqanWov8SRIBO8VV/MshJl8YBdaV9zMx2Aqvv6dg2yPmndz9kH5Abjp1d228oKv6vZFM
        9TdC3buoDMJ2fktQVWjtbnhcYNkrHZJVjBB+a7K2EkneHHTHlkNTnd0GI6Atf5j2r14TEqX52nwsQ
        n8tY3nqzv76YXi42ZyFUEZyuf7I5CEwkIkLjZf+jXlGqwimfWtThOVw/HKXpS45Wt6TwiywrGZ+tS
        rQwLzKig==;
Content-Disposition: inline
In-Reply-To: <20211127101059.477405-2-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Sat, Nov 27, 2021 at 06:10:56PM +0800, Yu Kuai wrote:
> This reverts commit 32e3374304c7c317c05a61f3ddc315dbd46424f2.

Please re-add the function together with the actual users in a commit
that has a proper commit log.
