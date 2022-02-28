From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v9] block: cancel all throttled bios in del_gendisk()
Date: Mon, 28 Feb 2022 14:11:30 +0800
Message-ID: <Yhxnkg0AEaj36t+a@T590>
References: <20220210115637.1074927-1-yukuai3@huawei.com>
 <YhuyBgZSS6m/Mwu6@infradead.org>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646028720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=koDNyhpZRRWUbZFhH9KWUoWf+UDX5NXH16ZSUqLPEwY=;
        b=KygYL8GXXMd9+htAZDQw0Ye1IVMuKEi+xcQAUW/kppRaQoKqzAc++g8yMGwOpo9hTxXmBg
        VjSswtEUvC7ByJf/hThqHvRBnmiPxQRVBKqX086L07KgMPZH1i066U26xPi/xP1jtPeEVS
        Oz2EP75izlM1CZYn7b8Che1k/l3LoFc=
Content-Disposition: inline
In-Reply-To: <YhuyBgZSS6m/Mwu6@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>
Cc: Yu Kuai <yukuai3@huawei.com>, tj@kernel.org, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

Hi Christoph,

On Sun, Feb 27, 2022 at 09:16:54AM -0800, Christoph Hellwig wrote:
> On Thu, Feb 10, 2022 at 07:56:37PM +0800, Yu Kuai wrote:
> > Throttled bios can't be issued after del_gendisk() is done, thus
> > it's better to cancel them immediately rather than waiting for
> > throttle is done.
> > 
> > For example, if user thread is throttled with low bps while it's
> > issuing large io, and the device is deleted. The user thread will
> > wait for a long time for io to return.
> 
> FYI, this crashed left rigt and center when running xfstests with
> traces pointing to throtl_pending_timer_fn.

Can you share the exact xfstests test(fs, test)? Or panic log?

I can't reproduce it when running './check -g auto' on XFS, meantime
tracking throtl_pending_timer_fn().


Thanks,
Ming

