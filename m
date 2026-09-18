Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C43D175A74;
	Fri, 18 Sep 2026 09:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789723894; cv=none; b=rjo+dIrT2R3c/C8FLgrThqS3lAplJo8UX/BgEtAf2DT+qZ0SH7uYHmG7EmHUxRvxBkk+gFGjKPHL/tEtChm37lBkJmglusGTAjfpBxOHE7zR1XzN7bNGlRa7pRcv8AX4V9gbDrFSuzsawdbtLtLSSgurG29TAyWkaWqOcGoWH3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789723894; c=relaxed/simple;
	bh=3SDdD0NJSU0xAATGfwgHh+/wHcM1MvUbHeRyTyK6n6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XSTq+8C74ZLMyWvcVUauMxEWWnEJ1eRDyfGfi/8H1bQGuPLU1ClKPe4xkeWseN2QQQdtLtXv2XxJJIdIMqzVUNaGMSi0FRqSR+kGIY9ZPheWXAmUUuyGpqGzlbngjEfPlA2s00BPNxdZ3l9ig9pie9aclOYoNYJvdsT9KU45hxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6547168C4E; Fri, 18 Sep 2026 11:31:24 +0200 (CEST)
Date: Fri, 18 Sep 2026 11:31:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: yu kuai <yukuai@fygo.io>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Josef Bacik <josef@toxicpanda.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>, Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Nilay Shroff <nilay@linux.ibm.com>, Tao Cui <cuitao@kylinos.cn>,
	linux-block@vger.kernel.org, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, gfs2@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	llvm@lists.linux.dev
Subject: Re: dm review needed, was: Re: [PATCH v3 2/3] blk-cgroup: store
 blkcg in bio instead of blkg
Message-ID: <20260918093123.GA13158@lst.de>
References: <20260918041744.1526924-1-yukuai@kernel.org> <20260918041744.1526924-3-yukuai@kernel.org> <20260918071634.GA10884@lst.de> <daf4ba77-4c25-4993-900d-ee1fe713d9b6@fygo.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <daf4ba77-4c25-4993-900d-ee1fe713d9b6@fygo.io>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Sep 18, 2026 at 05:19:53PM +0800, yu kuai wrote:
> So I think we don't need to restore the reference, BTW, there is another approach to
> avoid such problem in blk-throttle I don't take for now:
> 
> For bio entering blk-throttle, we can clear the new flag and blkg reference directly
> after the bio is throttled and before this bio is issuing to disk, because bio will
> not enter blk-throttle in the completion path. And since blk-throttle is the only rq_qos
> policy that can be enabled for bio-based disk, then dm_bio_record() will never see a
> bio with the new flag set.

That sounds much better, thanks!

