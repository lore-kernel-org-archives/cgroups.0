From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next] blk-throttle: Set BIO_THROTTLED when bio has been
 throttled
Date: Mon, 13 Dec 2021 10:12:30 -1000
Message-ID: <YbepLpyMPqP2ao3J@slm.duckdns.org>
References: <20211118131551.810931-1-qiulaibin@huawei.com>
 <YaUZExR6v8IdZUeM@slm.duckdns.org>
 <03964258-10ff-7f19-10cb-ca4eccf72848@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QM1WAkY5YIMPrYMzabdIsY5OA29nkvFhJSOPtvU2Xn4=;
        b=dmuBtYLm45LtIGeASk99mFXcNTg3IU1OAEVj+ztZ16POfo065yspmzZYp719mjjwjR
         W8NJNmcZBk38GNTNM/cDIGma0Wm8NtPjieMM8s1OQYrM4p+ilUBBKIYurAoTR9hftGLe
         i+wxLVip4lH7GPDPDuyCra0FojnE2D6785Lmg51eCKZLbLJZsH40fICz4R2Yx0ObCqKT
         S9MVHxechiSnwyhE4psgBlm6yLjWq5dFftHBaq+vKEJJ1wbm8P7VSy92NKk5lJyfr77i
         I7CKJqHvT5Z7mmCyXz6wgQ9FwNBc88556xtvHGwNh7MMDjaXA3nC/zIpi/4VVy2oo9PB
         4DaA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <03964258-10ff-7f19-10cb-ca4eccf72848-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: QiuLaibin <qiulaibin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Dec 13, 2021 at 05:24:00PM +0800, QiuLaibin wrote:
> > * This function is called synchronously on the issue path. The bio isn't
> >    seen by the queue and device driver yet and nothing can race to issue it
> >    before this function returns.
> > 
> 
> The bio is under throttle here, this submit_bio return directly. And
> current process will queue a dispatch work by
> throtl_schedule_pending_timer() to submit this bio before BIO_THROTTLED flag
> set. If the bio is completed quickly after the dispatch work is queued, UAF
> of bio will happen.

You are right, the timer can get to it. Can't it be solved by just
reordering spin_unlock and setting BIO_THROTTLED?

> > * Now we're not setting BIO_THROTTLED when we're taking a different return
> >    path through the out_unlock label and risks calling back into blk_throtl
> >    again on the same bio.
> > 
> 
> In my opinion, This flag can prevent the request from being throttled
> multiple times. If the request itself does not need to be throttled, the
> result of repeated entry will be the same.
> If necessary, I think we can use other methods to achieve this effect for
> request does not need to be throttled.

So that we don't change anything regarding this?

Thanks.

-- 
tejun
