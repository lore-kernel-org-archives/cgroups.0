Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3B86FC5;
	Tue, 15 Sep 2026 06:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789455050; cv=none; b=cwMSGdr9ssqDkvQxR1qQQ5imSQKBnIDEG0SWLhJ3JgTqDmQh/JjolQh0A5+77XWyhDMmUDffuOeSOd28WRZeJpmH+8r2bcLeV8d26Gti0h/dJxsgPGSg5GrHpSMC/7NKecLQ5v1KniPIr2IR5kWOXNgNY2AMKcIKr+Alt4o/WqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789455050; c=relaxed/simple;
	bh=/ZCmi4r14tZwDHCeMmDXzyYacNyDfq438K9Zf9rDAIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jsz7pKn8aZJjYYy3pAkvVL/BQCRsJrgmOffASr0qJId8rkOCVY737XwytlNo7k346WcBnuuuHp06iBH3q7OLOj5u7nCtU6oFSy+DTmgxNnYIwVXOXFeUkBDYK/Yc6hxG4PnlyA1QEZJr75/yeJ5I69tH0n8vBbyZFzyAGSjeoYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BA6DC68C4E; Tue, 15 Sep 2026 08:50:44 +0200 (CEST)
Date: Tue, 15 Sep 2026 08:50:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: Nilay Shroff <nilay@linux.ibm.com>
Cc: Yu Kuai <yukuai@kernel.org>, Jens Axboe <axboe@kernel.dk>,
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
	Justin Stitt <justinstitt@google.com>, Yu Kuai <yukuai@fygo.io>,
	Christoph Hellwig <hch@lst.de>, Tao Cui <cuitao@kylinos.cn>,
	linux-block@vger.kernel.org, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, gfs2@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	llvm@lists.linux.dev
Subject: Re: [PATCH v2 3/3] blk-cgroup: move async bio punt state to blkcg
Message-ID: <20260915065044.GB13417@lst.de>
References: <cover.1789237876.git.yukuai@fygo.io> <326e4904402440323532168095f2eb0c6f697836.1789237877.git.yukuai@fygo.io> <f27ee89f-5a52-4cfc-a14a-e5019ae61d89@linux.ibm.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f27ee89f-5a52-4cfc-a14a-e5019ae61d89@linux.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Sep 13, 2026 at 06:59:25PM +0530, Nilay Shroff wrote:
>> +	/* as long as there are pending bios, @blkcg can't go away */
>> +	{
>> +		guard(spinlock)(&blkcg->async_bio_lock);
>> +		bio_list_merge_init(&bios, &blkcg->async_bios);
>> +	}
>>
> Instead of using guard(spinlock)(...) here, I think we could use the
> simpler spin_lock()/spin_unlock() helpers. IMO, they are easier
> to read and reason about for these short critical sections.

Yes, guard() is a complete mess that makes code unreadable, please
don't use it.  scope_guard is a bit better, but given that it doesn't
mix with goto based unwdinding it still is too dangerous to actually
use.

