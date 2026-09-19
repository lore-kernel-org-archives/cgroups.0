Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3496D372ECB;
	Sat, 19 Sep 2026 15:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789830014; cv=none; b=Q+Q1BN6+8gwHmAWKyGGA50+u9Yh7oWQ+CvQoMrbPo6PKKWNLCX5Mm4SEriUsRaErxFhvmD34xDp+TpRmfPZPs0eVlyVKJ4YlP4C3OK42w6OEVaCpcHxfCggvfxwR3lGiFe5CA+3bniG5eluMy5e/ECy05S8ClsF2+Xm44ka0Bdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789830014; c=relaxed/simple;
	bh=6NLWoCpkjR1cSW/Aj+qWSMno/6JOq3xXDW8WKhOGAi8=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=PL/sXunMwFIW2uHE9oUHjnCVsOWw0vsiEbY1za/seLahg0EtMKWnol+U6SBQZplwLHn1iGA2vfsabQZs6LkH2x3fRNbqC6X8MPWvYzgJ7IicQW+jOsYZFA8hEk5O980jMQP1itcFHlOxF919uL0MVx/z6yBkKSuu9drVTDjOj7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C/9/oWDf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C/9/oWDf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72471F000FF;
	Sat, 19 Sep 2026 15:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789830012;
	bh=N0SRPEmy4Q1/oaLUGgV5UjqSLniLvx/2YO2EScSp0S4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=C/9/oWDfjmUt9/R4FSDrBn49E9BMmjrJOIvfIX8dglkbPi+gtBrpAaRqdGCE6Hh1o
	 hixoBBRQMRXWBnZqSwCppOe1DsVMsgSEny60v8KEefd9pEwJss5Om53Jud9TU50UkY
	 kkiYw8xvKh4GoJw7Z6+WhruKuVtp1ud/opoLHom/Q7CdZIMHcV6+hNMNfd2LilZrsk
	 NgQpAZ+/8+c/SK78dhqb5gf+LG0MbrcXKhX81iSmaZgPc3a7Yd0eFe0CIPxewdAeLs
	 1EpP8pLifaOJmk8k6fi4AAxnoV/ifZD+g3LZSPbi3GIMX0w+e9cXnNT2hU5ZpxF2vM
	 OhaqT/TkgTofQ==
Date: Sat, 19 Sep 2026 05:00:12 -1000
Message-ID: <084ec3b97432a6d1520948417d9b9bc1@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: Josef Bacik <josef@toxicpanda.com>,
	josef@toxicopanda.com,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cuitao@kylinos.cn,
	Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 2/4] blk-iocost: charge zone appends as page-counted
 sequential writes
In-Reply-To: <20260916085304.1080271-3-cui.tao@linux.dev>
References: <20260916085304.1080271-1-cui.tao@linux.dev>
	<20260916085304.1080271-3-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello, Tao.

On Wed, Sep 16, 2026 at 04:53:02PM +0800, Tao Cui wrote:
> A zone append advances the zone write pointer and is therefore
> sequential from the device's perspective; the actual sector is only
> returned after completion, so the cursor-based seq/rand classification
> doesn't apply.  Price it as a page-counted sequential write.

Whether an append is cheap depends on where the previous IO went, the same
as for a regular write, and the cursor already tracks that. The sector is
the zone start rather than the write pointer, but the cursor gets set from
the same sector, so back-to-back appends to the same zone are a bio length
apart and classify sequential, appends to different zones are a zone apart
and classify random, and emulated appends already arrive here as regular
writes at the write pointer.

It isn't exact. A read or regular write into a zone being appended to is
measured from the zone start rather than the write pointer, so it drifts
toward random as the zone fills, and the last append in one zone and the
first in the next are contiguous but compute as a zone apart. Both are
bounded by the difference between the seq and rand base costs of one IO,
which is small on the flash devices that do native appends. Mostly right
is fine here. Can you just add REQ_OP_ZONE_APPEND to the REQ_OP_WRITE case
and leave the cursor update alone?

Also, the Fixes tags on this patch and 3/4 should point at 0512a75b98f8
("block: Introduce REQ_OP_ZONE_APPEND"), which added the op without pricing
it, rather than the iocost commit that predates it.

Thanks.

-- 
tejun
