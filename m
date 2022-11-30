From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH -next 8/8] block: fix null-pointer dereference in
 ioc_pd_init
Date: Wed, 30 Nov 2022 07:59:41 -0800
Message-ID: <Y4d97Ui+3ORzRhxF@infradead.org>
References: <20221128154434.4177442-1-linan122@huawei.com>
 <20221128154434.4177442-9-linan122@huawei.com>
 <Y4YWQcb4PMmIdzIM@infradead.org>
 <e46fdde5-f320-9276-72ec-0f5fb5b48ffd@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZBaZLAQcwXpgoc/wypFSnGvG1ormvMqRTKZGjeGBWso=; b=YftUeZ3edM8lh3hLMLYkvoIm89
        BxMFibmnOQOwhtduBbuDosrHkBE1rrJvFUHUECFI5o7XPdRF5WPEl7+mVzRrOal09xRXlmNITBVqw
        wDuXPsFsczEXCNNxYsTurNDni9una+CM6XGZ+3nX1BxOhaqajdhwzizSzo+zJjx2RzW6TqS/kW4M7
        k+y7qxo2sIKMwObnqvc1CqSN7I7dXBwWkH+2jwuxQv8T18OtJfYRAb9dAkZu6rfmnY6RFhMcUNcUV
        HGEBNnZG1PekSCXVo73TulcJwICZTck1WBGvPHO5HvYywy/1lalyQ+InzvyjuI4VoTrdtSl8aIm4+
        Q1m2xNMQ==;
Content-Disposition: inline
In-Reply-To: <e46fdde5-f320-9276-72ec-0f5fb5b48ffd-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Wed, Nov 30, 2022 at 09:32:58AM +0800, Yu Kuai wrote:
> > No, that now means it is removed to later.  You need to add proper
> > synchronization.
> > .
> > 
> 
> Can you explain a bit more? Maybe I'm being noob, here disk is about to
> be freed, and I can think of any contention.

Right now we need synchronization with e.g. open_mutex and a check
for a dead disk, which I suggst to add insted of creating a lifetime
imbalance.
