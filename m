From: Christoph Hellwig <hch@infradead.org>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 bio_associate_blkg_from_css
Date: Sun, 30 Oct 2022 02:57:10 -0700
Message-ID: <Y15KdiUuYJxKBa6P@infradead.org>
References: <CAO4mrfdCeFWo4Nq=OYyiOa2qhuu3Jkft3KSosympvrFzxt+iQg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=53bCqPVe3GpAKeh9tw+daPPTYDSxNswAb2cUcIEPPJg=; b=vqoDNLJqMfoF/cxY4N5AfAVyxp
        vffWxkZxCxtVl6GCVSTVqVlIVH03xFG9Y1I+WqghoyA5tDF1lnRvkK2nKlo1engOnKWOGSCsH0D6r
        1mj9ezf/3ZZ0CPezYnUbQtIZoBU5W4bwxrmB3Y4dTX4QH5AY0yT22oY5jKi54OMNNs/Ob3fYQnvMO
        5Im13CDbj+xCc0lHsLeY+eKRTC+Jxl2yhsfYNK28Za792WVLGIbTyDQkOuoRLKWaxuY8fw2iohLQJ
        Q9MPDzerW+4Rk+CJuaJLlE7nnQk0WxnGpzfL8KTyth+JhltIgazyWPinNuYtzpjmFO51it2tHSRVW
        Kpi2FAeA==;
Content-Disposition: inline
In-Reply-To: <CAO4mrfdCeFWo4Nq=OYyiOa2qhuu3Jkft3KSosympvrFzxt+iQg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Chen <harperchen1110@gmail.com>
Cc: tj@kernel.org, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, Oct 30, 2022 at 05:39:59PM +0800, Wei Chen wrote:
> Dear Linux Developer,
> 
> Recently when using our tool to fuzz kernel, the following crash was triggered:

This looks like jfs somehow not setting log->bdev before doing I/O.
