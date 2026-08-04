Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B195446D578;
	Tue,  4 Aug 2026 15:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785858452; cv=none; b=IZCOsw+xiLSikfTopLzPoH0nugCVb7hk6yrCkl7VQibYqCwOe6cC3Z0RD8slUh5ZwIl+zdq7wCmHmw6Qyv01WjTULr14Leu6LU1dVU6YCNp1fiXfX0Nd1EL1lfQGAKy1ID90Div7uxpHF8G7aXyirAGH+o1dmp1MHoFvDn3Kk2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785858452; c=relaxed/simple;
	bh=3INYlQKobLh4mMVUFvPghDpGiNw6y0KRfCXHtoDWGyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b0OGpwgR5rt1AqBqYKRLf3odcHD7+5HMg/z2RcfITQ9e+noOqNj73DO+c+WEWMGeDbsqrVWdAsC2vjjdm3vpnQosfue62FsqoNGOHrADUVR1/IaYW6E7owCtFF4jLdzNl6j080VQjZRVc55gbNVDO3ax0m0JE/sAUhAKUeNYzh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5789C6732A; Tue,  4 Aug 2026 17:47:22 +0200 (CEST)
Date: Tue, 4 Aug 2026 17:47:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: yu kuai <yukuai@fygo.io>
Cc: Christoph Hellwig <hch@lst.de>, Tao Cui <cui.tao@linux.dev>,
	Yu Kuai <yukuai@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>, Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Nilay Shroff <nilay@linux.ibm.com>, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev,
	gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v1 2/3] blk-cgroup: store blkcg in bio instead of
 blkg
Message-ID: <20260804154721.GA11379@lst.de>
References: <20260804065313.2092022-1-yukuai@kernel.org> <20260804065313.2092022-3-yukuai@kernel.org> <a677f581-344b-4d99-846d-a00801e26033@linux.dev> <20260804133208.GB8078@lst.de> <0fc5dd22-7a8d-43f0-8555-d2ca966efff6@fygo.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fc5dd22-7a8d-43f0-8555-d2ca966efff6@fygo.io>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 04, 2026 at 11:30:55PM +0800, yu kuai wrote:
> The problem here is that remove a cgroup can also remove the blkg from radix tree,
> even through it still has active refcounts. I think this can be fixed by checking
> the cgroup online_pin first, if it's zero, we can search the blkg from the
> request_queue blkg list, where blkg will not be removed until blkg_free_workfn().
> What's better, if we can convert the blkg list to hash table with key as blk-cgroup,
> it will be much better as we can lookup from this table instead of blkcg radix tree.

Yes, I think you can really easily do that with the rhashtable.

