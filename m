Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1086390C81;
	Mon, 28 Sep 2026 06:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576646; cv=none; b=dmH7tsWkrkgz0QYu1C1Bvm4h5uGQuM4OAbRfTZZ/DQ2bg+58/ymDomEc0BsH6n6T8H/YnklhYXmMJc2bHPUHbDcgPzggH+ld8TM0toOrdf1rFqIxlPjsHAUpFd4mZLMsGm9uTQ2r4C/yFCuZ3IjsUbshWd6lRAsrch4H5pAGYj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576646; c=relaxed/simple;
	bh=Z8hcR5Go5z5dVx+mFfXo4yccX9Q0+zJAOiaLnyrUtTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LuK46Ds6W5AhlJ3d0b7GwAW/ckjDTc0+CAhTmIPtDdzmxoKAQsPUonC4QuG1wNwmqtfcaewZKVYagcv6JCaf/fdX8lPuw7O+qwzm2g8tnlg+S5yclCIhUa2nCOqRKgeq1vh+rxGETB3dr355KXxBUpI2v9Df+e5+HRz/7WidcbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=keukrEB2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="keukrEB2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DR/hwaEZILg/9rvVDgZU74EvXnZO71agIm5YgCpk650=; b=keukrEB25vjEoqL/8zVNNWoGFM
	2FBJRmD+w+My6XUr8jIFsV/2GBFZ2lG14Za7h23vhi1GJDZi9mMJtwcASd+HqE+mJ0ah8L66hc7a2
	3HG8FJStZ8ItddZyxkLFDuerZh4rpvbjp1c1tGJPxKjpE4vdKHTtfjAVjF6/ffMIf4nMsWl+RYrmP
	Sob/bxS39PhpKuYbIZThEFM2e9HyDBcLjN9dZQRNXoW6IBZ5BT5/AUvSsKnUvFbURriMxPPPd0P21
	HOiTaTHd3KzuYOVj/wmFcvAK49SbIB3DqGqmi28XpaYDnZamfZNx8BgAoseyofHdpsGIvv/mnsAK5
	Pog5nVMg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xB4mQ-0000000HRoj-1T7I;
	Mon, 28 Sep 2026 06:24:02 +0000
Date: Sun, 27 Sep 2026 23:24:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>,
	Julian Sun <sunjunchao@bytedance.com>, linux-block@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, willy@infradead.org, tj@kernel.org,
	akpm@linux-foundation.org, Boris Burkov <boris@bur.io>
Subject: Re: [PATCH v9 1/3] block: introduce bdev_flush_by_dev()
Message-ID: <aroIAqoCNDBPlB2A@infradead.org>
References: <20260925064444.3944820-1-sunjunchao@bytedance.com>
 <20260925064444.3944820-2-sunjunchao@bytedance.com>
 <arYaMbJUh6unvz_t@infradead.org>
 <3w6vfwfkojmfqy2qs5j4q2s2366ajqiwmqf624lyn3odrv42v2@va2r7a6ngfz6>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3w6vfwfkojmfqy2qs5j4q2s2366ajqiwmqf624lyn3odrv42v2@va2r7a6ngfz6>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Sep 25, 2026 at 12:34:52PM +0200, Jan Kara wrote:
> On Thu 24-09-26 23:52:33, Christoph Hellwig wrote:
> > On Fri, Sep 25, 2026 at 02:44:42PM +0800, Julian Sun wrote:
> > > Add bdev_flush_by_dev() to submit page-cache writeback for a device
> > > identified by dev_t without requiring callers to hold a persistent
> > > device reference.
> > 
> > This isn't really a flush is it?  This is writeback.
> 
> So bdev_writeback_by_dev()? Fine by me.

Yes.

> Well, Julian is explaining that in the cover letter. We don't want memcgs
> to hold bdev references just for foreign flush tracking. There's no easy
> way to get rid of them so they could pin bdevs for a long time leading to
> strange artifacts.

I have to admit I didn't get it when flying over the cover letter.
But this also really belongs into the patch where it is more obvious,
or even better into code comments.

> 
> As you write, we could just hold a reference to the bdev inode. Those get
> unhashed when the device dies (__del_gendisk()) so memcgs would be just
> wasting some memory by holding these inodes alive. But still, transitioning
> from inode to proper bdev reference verifying bdev is still alive will add
> a bit of hairy code (essentially what blkdev_get_no_open() does plus
> verification inode is still hashed). Plus when replacing foreign flush
> entries you're under irqsafe xa_lock so doing iput() from there is kind of
> a nogo.
> 
> So I think tracking devices by dev_t is a good way of dealing with these
> problems. But then when flushing you have to transition from dev_t to
> struct block_device and blkdev_get_no_open() is the canonical way of doing
> that (and note this use is just internal to block/bdev.c).

I'd really prefer not to grow more blkdev_get_no_open users.

But the more I look at this I wonder why we even bother.  Trying to
attribute individual bits of dirty metadata to cgroups is pretty much
insane.  Why don't we bypass memcg accounting for buffer_heads like we
always did for the XFS buffer cache, and what btrfs switched to last
year? See commit b55102826d7d ("btrfs: set AS_KERNEL_FILE on the
btree_inode") for the btrfs side.
