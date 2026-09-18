Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1FB3630B2;
	Fri, 18 Sep 2026 07:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789715805; cv=none; b=azOjqRzoqPP/MqZ8psH/VO8AqrejNd/tYZ+LNm/0wQCiTGuF2Y4Gz+ssmi38Rz0KmIQXyLc/8z67mmYCFffvWFpWcoFqbwzV6a39hmHf5sr4TvhRJXebfxKImbvqv7dH9niii+Fo4OgFc6l0mi79vYE2/8nyTycG7dlDIQ8yruU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789715805; c=relaxed/simple;
	bh=LiM7zkLpUX7MIBOG7kJrUoQaNQaMFXdSWvG3PwItrhE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A0tFgVxPMTQmJGE6eHyoVNx6XyQCLNLXN0bZqvXWKsnhsdlysGyhx7Mi+dr6bJO6zspKj3trxOl6/lmLb8wIRizmLmG3eG+E4fNnV/26v6Vsd3LdX61As9RIewOMS5GKywNsxTDknZ+UXmGOBewKt7i33ua/iyPUNmFUGX9+YzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 619B168C4E; Fri, 18 Sep 2026 09:16:34 +0200 (CEST)
Date: Fri, 18 Sep 2026 09:16:34 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>,
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
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
	Justin Stitt <justinstitt@google.com>, Yu Kuai <yukuai@fygo.io>,
	Christoph Hellwig <hch@lst.de>, Nilay Shroff <nilay@linux.ibm.com>,
	Tao Cui <cuitao@kylinos.cn>, linux-block@vger.kernel.org,
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, llvm@lists.linux.dev
Subject: dm review needed, was: Re: [PATCH v3 2/3] blk-cgroup: store blkcg
 in bio instead of blkg
Message-ID: <20260918071634.GA10884@lst.de>
References: <20260918041744.1526924-1-yukuai@kernel.org> <20260918041744.1526924-3-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918041744.1526924-3-yukuai@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Sep 18, 2026 at 12:17:43PM +0800, Yu Kuai wrote:
>  static inline void dm_bio_record(struct dm_bio_details *bd, struct bio *bio)
>  {
>  	bd->bi_bdev = bio->bi_bdev;
> -	bd->bi_flags = bio->bi_flags;
> +	/*
> +	 * Restoring BIO_BLKG_REF would not recreate its associated reference.
> +	 */
> +	bd->bi_flags = bio->bi_flags & ~(1U << BIO_BLKG_REF);

But do we need to restore the reference?  I have to admit that
this surrounding code is very confusing and I would really like
to have the dm maintainers look over it.
