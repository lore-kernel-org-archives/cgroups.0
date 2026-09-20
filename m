Received: from mta1.migadu.com (out-144.mta1.migadu.com [95.215.58.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCF554704F
	for <cgroups@vger.kernel.org>; Sun, 20 Sep 2026 07:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789888399; cv=none; b=aQFkR/9Co9/hlK9cJcB/nOd+SSjvDn8ueETIuVpHBbjwzG6icAdws70IpkHv03T8VXuc8omvGrgr3vo1gb7J17+ykAJ4FgWr4ZzIQ+2ooYRkmWCwkN/f3KTJQvWqTNJYPrh6YrDlpRi65atVkndgtNeeSqrwQ/z8XskPw7VMw+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789888399; c=relaxed/simple;
	bh=AmpQvYC+661I5Z6XBFyOhYJJR3FumQ2cqGqfiZD1Gtg=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=BnIpTDFUtNwHz8XQNbm1vzUyZEBklJHnoV5xDmB2YAtY10uAu+tHMDSA9WNnmshdAMf6Y7RuMrkjvI6SjANvWWqJRt7qC5zl9Ypvm6gAfsbJBmiyXSqJUsucpjKoCay5WbeiPt5tbQoSR8+jzJj3R083z4KmYZci4G3MwNr+OGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ved1K0YU; arc=none smtp.client-ip=95.215.58.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ved1K0YU"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=AmpQvYC+661I5Z6XBFyOhYJJR3FumQ2cqGqfiZD1Gtg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789888395; v=1; x=1790493195;
 b=Ved1K0YUAUGAOCtw1/I4YIudHikNJ5JergFMDhMB/61g7cVnno8RPaPQjOcgITqLyWEEhzbK
 U/WyGVbdGMaf4zXp+XydFtM2pDb7GcLSvfDH5ufjGbw01+4Ur6zKmgeac/tB4uf+n+vVdMBNGq2
 4dKGq6VBGKOjiZxpIAxvRuss=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 412a9c1ee22be783;
	Sun, 20 Sep 2026 07:13:15 +0000
X-Mizu-Trace-ID: 412a9c1ee22be783
X-Migadu-Flow: FLOW_OUT
Message-ID: <7674b311-52a9-4a88-80c9-65a37383b4ab@linux.dev>
Date: Sun, 20 Sep 2026 15:13:12 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, Josef Bacik <josef@toxicpanda.com>,
 josef@toxicopanda.com, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@infradead.org>, cgroups@vger.kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cuitao@kylinos.cn
Subject: Re: [PATCH v2 2/4] blk-iocost: charge zone appends as page-counted
 sequential writes
To: Tejun Heo <tj@kernel.org>
References: <20260916085304.1080271-1-cui.tao@linux.dev>
 <20260916085304.1080271-3-cui.tao@linux.dev>
 <084ec3b97432a6d1520948417d9b9bc1@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <084ec3b97432a6d1520948417d9b9bc1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello Tejun,

在 2026/9/19 23:00, Tejun Heo 写道:
> Hello, Tao.
> 
> On Wed, Sep 16, 2026 at 04:53:02PM +0800, Tao Cui wrote:
>> A zone append advances the zone write pointer and is therefore
>> sequential from the device's perspective; the actual sector is only
>> returned after completion, so the cursor-based seq/rand classification
>> doesn't apply.  Price it as a page-counted sequential write.
> 
> Whether an append is cheap depends on where the previous IO went, the same
> as for a regular write, and the cursor already tracks that. The sector is
> the zone start rather than the write pointer, but the cursor gets set from
> the same sector, so back-to-back appends to the same zone are a bio length
> apart and classify sequential, appends to different zones are a zone apart
> and classify random, and emulated appends already arrive here as regular
> writes at the write pointer.
> 
> It isn't exact. A read or regular write into a zone being appended to is
> measured from the zone start rather than the write pointer, so it drifts
> toward random as the zone fills, and the last append in one zone and the
> first in the next are contiguous but compute as a zone apart. Both are
> bounded by the difference between the seq and rand base costs of one IO,
> which is small on the flash devices that do native appends. Mostly right
> is fine here. Can you just add REQ_OP_ZONE_APPEND to the REQ_OP_WRITE case
> and leave the cursor update alone?
> 

That fits the existing model better than the special handling I
introduced.  I had missed that the cursor is set from the same
zone-start sector on every append, so back-to-back appends classify
sequential as expected, and that emulated appends already take the regular
WRITE path.

I'll drop the special case and the cursor skip in v3 and just add
REQ_OP_ZONE_APPEND to the REQ_OP_WRITE case.

> Also, the Fixes tags on this patch and 3/4 should point at 0512a75b98f8
> ("block: Introduce REQ_OP_ZONE_APPEND"), which added the op without pricing
> it, rather than the iocost commit that predates it.
> 

Agreed, that's the right anchor - the gap appeared when the op was
added.  Both Fixes tags will be updated.

Thanks.

> Thanks.
> 

