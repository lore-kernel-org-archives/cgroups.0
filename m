From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH -next 8/8] block: fix null-pointer dereference in
 ioc_pd_init
Date: Tue, 29 Nov 2022 06:25:05 -0800
Message-ID: <Y4YWQcb4PMmIdzIM@infradead.org>
References: <20221128154434.4177442-1-linan122@huawei.com>
 <20221128154434.4177442-9-linan122@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ylwb4KCyca+jQJTbdW1raeSgIDIZEx3eWo3k4sH/7JI=; b=3jmd+PnWA2cHklZWXfXzE0YLxH
        P3Qt4u6ALN3HizAKCzkKmK+ufSt2091ZZsysN0o2kJLAqo3XpNU2hwD7duqzqdxKIqAIzG9/RkBPD
        0Nnpmd+8H+4zmuJwASUo2kjImy4VUZWKOM/rm2L8qseuxQquU+nZO2UOK50cVrck1PB46bjUHh2QP
        N2HHuOoWwcjpyBlGF0e540qKOr2VCwI4ImwR7szrlu3r7zK/+Q2SeBiYZE6ElUKqlJW56amItAyTU
        0F+vRxS/uoyh8RxMT3RDNXS/iKOZehuAXnPGMGJPTXgFJNhtQD7GoUwfe1jUXkgw7GyqJlANg09FF
        yLvUY30Q==;
Content-Disposition: inline
In-Reply-To: <20221128154434.4177442-9-linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Mon, Nov 28, 2022 at 11:44:34PM +0800, Li Nan wrote:
> Fix problem by moving rq_qos_exit() to disk_release().

No, that now means it is removed to later.  You need to add proper
synchronization.
