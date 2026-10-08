Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1A03D1CAE;
	Thu,  8 Oct 2026 09:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791452388; cv=none; b=g3I7iF/1LOdW5dE+YHSi1kFDb8PzymU+hAGAYvVZoYo9gcWs/OMKVxXLTqbD14kRDUI0kHEPcBuzsrQmF8PN7BalqASJp8/NTBDeRZLoZzvNV/J6XWl/yftb5VmRNtjPMXgZJtlVgKND7y4R3pYAvej8hupAm3bGoQkDTzxvG8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791452388; c=relaxed/simple;
	bh=SXGH9Z2sKf9gd5EF+DR8x54cjdZ36U6rmco1+5f+14s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tlc+vYZYCS0x1Bc3gEdI+5w42BFHv/m8b8MQqFZBPOnL+L0yuKpCaaI1o3eT85G+Dw5yX6axmm9CwFQgH9+BOeC8ywy/xISwsS5kTzEh/wjYmfjhxdRk7lIWDBQHLBgFrC7v8kQZ7ew7CBTirMUFrJAeKRArpiEWls1uxeGk2Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gqi0G9mb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gqi0G9mb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SXGH9Z2sKf9gd5EF+DR8x54cjdZ36U6rmco1+5f+14s=; b=gqi0G9mbFX9h3tQxOi8M1kjNU+
	lXE+9FcOKN08OhEE3n9BpzNpbCiWaTYNI4VDB6Xa7Pd5QDMSLRaIePjWCpZIRkoK7FScuRyGNDLZW
	jL2s+38BefoFKe7l0mToh7TnkHe4zjvd+qvgCoC+Yp66yzEYe3LHes8ARn9dc5EMs1mwydCdWez49
	qUqsIPJ0WaOAQnfLga0b+pZAr5/OahGUp9mgO44cN8p1VbqHNAt2QrG+GVxpt/4/er5i17xJd4eQE
	hlrzq/aG/Wq9+Pv/m8y2cfp7SR3HEZPccQ38eGKAFRm+oLfhyJgc6ozF7fv/HD3tpapJLHKqbPlJN
	l3Zq2pgg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xEkbH-000000041Hy-439N;
	Thu, 08 Oct 2026 09:39:43 +0000
Date: Thu, 8 Oct 2026 02:39:43 -0700
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
Message-ID: <asdk330xyUL8xDyR@infradead.org>
References: <20260925064444.3944820-2-sunjunchao@bytedance.com>
 <arYaMbJUh6unvz_t@infradead.org>
 <3w6vfwfkojmfqy2qs5j4q2s2366ajqiwmqf624lyn3odrv42v2@va2r7a6ngfz6>
 <aroIAqoCNDBPlB2A@infradead.org>
 <9e9c02fe-e94d-4f70-a21b-47b46bab2c3b@bytedance.com>
 <5my3hyw54ej2tw24dqnacsy7xppywdjovvnwvrevmczsllzq7c@berxapmobgfa>
 <asNfNHd-kcsI4B1S@infradead.org>
 <bsb5vk2s3vyqglw6bv6pgpoqqvkho2p5kfnskfwfban5azi2vt@sceqd6t36yai>
 <c4d76912-581f-4174-95a7-d0ecaae79d3d@bytedance.com>
 <dzq3d5yosbsdeml4fdb3rpowxxnjau6edluw4xoewwwbv4hykg@ywkjm3xlbimv>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dzq3d5yosbsdeml4fdb3rpowxxnjau6edluw4xoewwwbv4hykg@ywkjm3xlbimv>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 08, 2026 at 10:51:08AM +0200, Jan Kara wrote:
> In principle, the mechanism looks good to me but I'd place it in
> fs_bdev_file_open_by_dev() & fs_bdev_file_release() so that all block
> device based filesystems are handled. ext4 is the most used filesystem that
> has this problem with bdev memcg accounting but in principle exactly the
> same problem happens for other filesystems using buffer heads so I'd prefer
> handling it in the generic code instead of fixing them one-by-one as people
> complain...

Yes, this should be in the common code.

