Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFB43DD52B;
	Tue, 29 Sep 2026 19:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790710323; cv=none; b=gm5yFZndVBN0UVtU+8+bdw6C93SlYNWPIlwLIRkjvKKxCZhAjXGrPfZrkahooGOq6xmkmBGLE/tjYU42/YM1C5h+Pf7OZs9ct+9jkF95B6PTG4+y6itzZkIIhTnErDVbTMkWOwwvEXr4nvy8t/Wkvy8rCEwrhkePI/C6AZ4NXnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790710323; c=relaxed/simple;
	bh=2DE3R3xTLFa/aCwxhY4Huq+rp+2dkgvN41qawVfDVKA=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FMQuXk0z2cJX5ySp6zlpH4D7sag8Ke6dtmyebmnmNZv5up701dkgyLn2W0rWDQL/MQrGIyDQFFp0OwiUhWuB88vFLedCa+dK2+efgjaghNSWQmEWj/05WQXG2aRU4W1K4oRRXAGUXk0GPtpLYGb1CF+QdmHPt/MOr8WSb5p5Zso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hUzCpH01; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hUzCpH01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946BB1F000FF;
	Tue, 29 Sep 2026 19:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790710322;
	bh=2DE3R3xTLFa/aCwxhY4Huq+rp+2dkgvN41qawVfDVKA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=hUzCpH016dhhQfIFFOTkj7wynEjxIF34pcXtGjdLgd4GJnOdCRLBDyoF5/x4CKqno
	 10hzxkun2w8/0qFO+Sp6M/IJEW/2ElTF83zCVNPCrXUvSO38NBmLHb1C2yxdL1GB8K
	 yOnk04sA9ZPsB2RfYMTxnPO+zVfaiGzFTR1yEqdVuq0jyRFAuFhOR2C6H77HfBkFPw
	 shG2tUdjtjbTh3y8g1WoW9Oy2aAwPZgfdQwLy2pFbondG//6GsDDt9j3bKDf4EZvHm
	 4mztCNap4h9n8XOpc+BoCq89/JsX/+T1ccrzLNOrMqr+96l+UWzZ8cS4t9kOkOCEaB
	 c6WiC+swFUkDw==
Date: Tue, 29 Sep 2026 09:32:01 -1000
Message-ID: <ffbfecce332d7f3a59f6533b6daa7f0c@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Liz Fong-Jones <lizf@honeycomb.io>,
 Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Jens Axboe <axboe@kernel.dk>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Xin Yin <yinxin.x@bytedance.com>,
 linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 ian@honeycomb.io
Subject: Re: [PATCH v3 0/2] writeback: let foreign flushes reach dying cgwbs
In-Reply-To: <20260928-wb-dying-cgwb-flush-v3-0-e35374884667@honeycomb.io>
References: <20260928-wb-dying-cgwb-flush-v3-0-e35374884667@honeycomb.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii

Hello, Liz.

On Tue, Sep 29, 2026 at 01:40:49AM +0000, Liz Fong-Jones wrote:
> 1.5s and 19.5s with it), because writing back the old wb's backlog took
> up to 27s and the sibling's foreign flushes reached the new wb in the
> meantime. Should foreign flushes also reach a replaced wb until it is
> clean, or is that not worth it for this case?

I don't think the old wb needs to stay reachable if the new wb takes
over its inodes. Instead of kicking writeback, can the takeover queue a
work item which switches all of the old wb's inodes to the new wb, like
cleanup_offline_cgwb() does for b_attached and b_dirty_time? The switch
carries the dirty and writeback page counts, so foreign flushes reach
the inodes through the new wb and nothing needs to be flushed right
away.

That would also mean switching inodes on b_dirty, b_io and b_more_io
while the flusher may be working on the old wb, which I'm not sure is
safe. Jan, would that be okay?

Thanks.

--
tejun
