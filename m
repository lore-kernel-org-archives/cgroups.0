From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/2] block: Add helper for queue_flags bit test
Date: Mon, 17 Oct 2022 00:47:18 -0700
Message-ID: <Y00IhghhGgVQBknL@infradead.org>
References: <20221011145246.8656-1-set_pte_at@outlook.com>
 <TYCP286MB232392B1D23662DE81B0D2D5CA239@TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=N3DhelgxeJD6609Ma0kcmpLW0VW7ci1zuKd0emkDasI=; b=4fQDVYDXyHEvBhehq1JK9VdDW0
        R3tMd/QDPEtKsjFGyFUg5svkVWeas3otDLcoY5ADt9NTdCDdXhQyvOSW0DiE+Ha40wEVm/WfkzT/P
        2ch6qZHi1dMjetjJmmIpImeTfa6H8ZZIkQJ5A7xdpLLo5NXFdAN8dqifLlAyZKASYGEEnlfL06jmG
        yElmdEt09/1MHOslxcYuYYBVYM/zyj4Cb8W/6WUxoR+nYxhbg+dlVS3nz2/T4FBe6Pb/3hYyNRHvI
        3YHeorVPSs9m3r3Mfq/GgQdazSE7bATFMgq6NUCBUwMIZHJOLAuHVUoWLH3zLEoaYTfJ2ti5bhaI7
        9m8SZYMg==;
Content-Disposition: inline
In-Reply-To: <TYCP286MB232392B1D23662DE81B0D2D5CA239-UecL6YWTnteHfTTpfZeTCOydXaKyItSjiGd9ebBGJoev3QGu/rdwKA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dawei Li <set_pte_at-1ViLX0X+lBJBDgjK7y7TUQ@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

>  	if (op_is_flush(bio->bi_opf) &&
> -	    !test_bit(QUEUE_FLAG_WC, &q->queue_flags)) {
> +		!blk_queue_wb_cached(q)) {

The formatting is wrong here.  And I really think these helpers do
nothing but obsfucating the code.  Now instead of a grep telling
me exactly what is going on I now need to walk through the macro
first.  (nevermind that this particular one is also horribly misnamed).

