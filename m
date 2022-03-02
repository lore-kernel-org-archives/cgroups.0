From: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v9] block: cancel all throttled bios in del_gendisk()
Date: Wed, 2 Mar 2022 08:51:00 +0800
Message-ID: <Yh6/dH2CERzsBPJd@T590>
References: <20220210115637.1074927-1-yukuai3@huawei.com>
 <YhuyBgZSS6m/Mwu6@infradead.org>
 <Yhxnkg0AEaj36t+a@T590>
 <YhyYpWHGVhs3J/dk@infradead.org>
 <Yh31bQu3gbXoDBuK@T590>
 <836f0686-4ac8-327d-2bab-64a762ea8673@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646182274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PSE7XhaCLoK3lvixPJtHiDdmfP+vYGOwXq3x81uSukw=;
        b=dSJsgPpRHCQ1jgbKljjd6pRUPrEFezAffRn2B8o3XXU3gPOdWucGtl3oJDo3kEFEoG07ub
        aZ9C23uZaqi+RSAM8RNXkIZ3vlYx/OzEXLuBYRV1DQu6CZP3gIEhH6Ue+ywT5BfBOHxIL5
        861OQFA3DWNBKxv6EfQv6zvi52uEYyk=
Content-Disposition: inline
In-Reply-To: <836f0686-4ac8-327d-2bab-64a762ea8673-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Tue, Mar 01, 2022 at 09:54:28PM +0800, yukuai (C) wrote:
> 在 2022/03/01 18:29, Ming Lei 写道:
> > On Mon, Feb 28, 2022 at 01:40:53AM -0800, Christoph Hellwig wrote:
> > > On Mon, Feb 28, 2022 at 02:11:30PM +0800, Ming Lei wrote:
> > > > > FYI, this crashed left rigt and center when running xfstests with
> > > > > traces pointing to throtl_pending_timer_fn.
> > > > 
> > > > Can you share the exact xfstests test(fs, test)? Or panic log?
> > > > 
> > > > I can't reproduce it when running './check -g auto' on XFS, meantime
> > > > tracking throtl_pending_timer_fn().
> > > 
> > >  From a quick run using f2fs:
> > > 
> > > generic/081 files ... [  316.487861] run fstests generic/081 at 2022-02-28 09:38:40
> > 
> > Thanks for providing the reproducer.
> > 
> > The reason is that the pending timer is deleted in blkg's release
> > handler, so the timer can still be live after request queue is released.
> > 
> > The patch of 'block: cancel all throttled bios in del_gendisk()' should just
> > make it easier to trigger.
> > 
> > After patch of "block: move blkcg initialization/destroy into disk allocation/
> > release handler" lands, the issue can be fixed easily by:
> 
> Hi,
> 
> Thanks for locating this problem,
> 
> Perhaps this patch should wait for the problem to be solved.

BTW, please see the top 3 patches in the following tree:

https://github.com/ming1/linux/commits/my_v5.18-pre-rc

xfstests generic/081 can run for hours without problems, without the fix,
the crash can be triggered in 10 minutes.


Thanks,
Ming

