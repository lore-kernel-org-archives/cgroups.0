Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A51F175A5;
	Mon,  5 Oct 2026 08:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791188791; cv=none; b=dmCbMBr/H5YUcicW4KQETwoyoNhy77Z2XmogONXX968XfbUbf1TrOzyRuw2vEdjinkpvOa27Q5OGaZq6eDaaaH6RLaUImYptdWFWJZzWKyTiMwF1r+jeKhU4WOAkMuRIIyhnfPZgfW1msKyX6sqz2rne9RSoqIdPXE2ODcO6iI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791188791; c=relaxed/simple;
	bh=N/25ilcKNe8kK9dekIEiG40fE2RxMeBzpf6sMxsYhtI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h06rZzqEpBqEO1oQCkjSGfK4yi3GPT+PKtWDv8tKP6x1Xo9QDzcXogglFQLUrE3ML2ZlyZgxLqXw19bDIIhNEqRpfQP6PNZNZ2Sb/wfppYYpNPnkXshAMfO3HQ6GfMHx97eBOJ+qPmznRSYitt5L4E/Evnax3hgmefEcUzqkzPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QTJb6Nwu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QTJb6Nwu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3RHPXjYw3ot+kYnaznQEYzuJhqEHSABJV8Imhq+QkwU=; b=QTJb6Nwuc9cCF83e6++BCnLJ/O
	32Jmf38rHZ7y1JBBHO27weAbf2HJfpJCib9VKdvB5ekAa8Q7O1ASRUVSZy9z3PxJpP48UDUpWIX8v
	ooZh9QP7yPkpW6VtTSTFYNrn81DUoZCOsdC6t101dbCfhygWZmDPzxW7TDYb/cikn0gwwRmInSzb6
	+B4ARmnsiAxFCgfQN4nktfpZtS30XGhjpoE410dLrC54nxYWrtsVmJlCVc0O5EQWBjdsDAlVlyw62
	GezjOVUCR9D5Sjl8pprZGvQge5NWpr4DYaSybJozybo07yGnP2J8ZWOLIzODk7sToSXvz6kRUo7E+
	tfv53fyg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xDe1k-0000000Fsd9-0Jg4;
	Mon, 05 Oct 2026 08:26:28 +0000
Date: Mon, 5 Oct 2026 01:26:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Julian Sun <sunjunchao@bytedance.com>,
	Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, willy@infradead.org, tj@kernel.org,
	akpm@linux-foundation.org, Boris Burkov <boris@bur.io>
Subject: Re: [PATCH v9 1/3] block: introduce bdev_flush_by_dev()
Message-ID: <asNfNHd-kcsI4B1S@infradead.org>
References: <20260925064444.3944820-1-sunjunchao@bytedance.com>
 <20260925064444.3944820-2-sunjunchao@bytedance.com>
 <arYaMbJUh6unvz_t@infradead.org>
 <3w6vfwfkojmfqy2qs5j4q2s2366ajqiwmqf624lyn3odrv42v2@va2r7a6ngfz6>
 <aroIAqoCNDBPlB2A@infradead.org>
 <9e9c02fe-e94d-4f70-a21b-47b46bab2c3b@bytedance.com>
 <5my3hyw54ej2tw24dqnacsy7xppywdjovvnwvrevmczsllzq7c@berxapmobgfa>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5my3hyw54ej2tw24dqnacsy7xppywdjovvnwvrevmczsllzq7c@berxapmobgfa>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Oct 02, 2026 at 01:10:42PM +0200, Jan Kara wrote:
> FWIW I share Julian's concern here. It would be fine to use AS_KERNEL_FILE
> for ext4 metadata but I think just unconditionally setting AS_KERNEL_FILE
> for bdev mappings will cause issues because some users may be using bdevs
> directly for their workloads and they could still expect proper memcg
> accounting to work in that case.

Agreed that it should not set unconditionally.

> We could set AS_KERNEL_FILE when opening bdev for a filesystem (and remove
> it when releasing bdev) but that would have to make sure there are no
> folios in the bdev mapping when changing the flag as otherwise the
> accounting would go wrong. Looks it might be doable but getting all the
> cornercases right will be hairy and overall not very appealing to me...

I'd rather not support special case writeback code just for this legacy
fs abuses bdev buffer cache case.  And we basically need to tear
down pagecache at unmount anyway, as i_blkbits can change, so while
we do need to be careful, I don't think it really is a major issue.

We might be able to restrict to setting it when
CONFIG_BLK_DEV_WRITE_MOUNTED is disabled to avoid the problem of non-fs
shared mmap writers, as anyone using a modern kernel and cgroups really
should have that disabled.

