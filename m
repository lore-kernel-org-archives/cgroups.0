Received: from mta1.migadu.com (out-102.mta1.migadu.com [95.215.58.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38B83DCDA4
	for <cgroups@vger.kernel.org>; Sun, 20 Sep 2026 07:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789888292; cv=none; b=PXLs+JK93qO1Wnk/7P/xvPgES8LrYy9vq+otHhmE8j9IWL0WlnzFdppu86LuLGEP5RIAloow3vKbHDRNuIMd9YCgqudyjjClYVxkW1YI9QJUY0wPik+djB1dV5Msetwz+yQUwRVOHyKDLeHk8cx7AXvu3WH7W/V0rL6AOgUI6iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789888292; c=relaxed/simple;
	bh=uaMKR+7TECAtMUAIgi2oWd84zdS5lYH++1kxf6ZsatQ=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DVUDL7AbrYAIm9SoNP75oMtbPgRX4aa4hzZPSfJGbcYGyM5BaXjGwuh0eS+8P/O2f4bd1MDCuGOsqGaEJQwNKFuuYITGTs/Qz7eRUCcp/Ai/ScXyg8/sycRTQkBC0vbZJGEyFj7aD0QT7Q6uk/VrpwU/B5zVn76kPEK/2K85ulo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YtedRfGn; arc=none smtp.client-ip=95.215.58.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YtedRfGn"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=uaMKR+7TECAtMUAIgi2oWd84zdS5lYH++1kxf6ZsatQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789888286; v=1; x=1790493086;
 b=YtedRfGnv2MRNoF6mjRd0JH3+ZHsJvY/31aemWlo9poVeWdscf2e9HcmzaOwVDejUklRN0GZ
 +UOYHy26fJzGceuMHK7lLKJ26FGoXSUIRkfVqfEVh03hXJAcruratvAyYE6oNf1725+6f2tf7Mf
 KgiHTs/Uud5gyWSOaM23Y9A8=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 372c471ec016f75c;
	Sun, 20 Sep 2026 07:11:26 +0000
X-Mizu-Trace-ID: 372c471ec016f75c
X-Migadu-Flow: FLOW_OUT
Message-ID: <3fe79d1a-72a1-4a70-9d6b-af7297879149@linux.dev>
Date: Sun, 20 Sep 2026 15:11:23 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, tj@kernel.org, josef@toxicopanda.com, axboe@kernel.dk,
 cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, cuitao@kylinos.cn
Subject: Re: [PATCH v2 2/4] blk-iocost: charge zone appends as page-counted
 sequential writes
To: Christoph Hellwig <hch@infradead.org>
References: <20260916085304.1080271-1-cui.tao@linux.dev>
 <20260916085304.1080271-3-cui.tao@linux.dev> <aq07Di4FPtCUxpAl@infradead.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <aq07Di4FPtCUxpAl@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Christoph,

在 2026/9/18 21:22, Christoph Hellwig 写道:
> On Wed, Sep 16, 2026 at 04:53:02PM +0800, Tao Cui wrote:
>> From: Tao Cui <cuitao@kylinos.cn>
>>
>> Zone append is a primary write operation for zoned devices; zoned
>> btrfs and f2fs use it for data writes.
> 
> f2fs doesn't.  xfs and btrfs do.
> 

Thanks for the review.  I'll fix the commit message to remove f2fs and
mention xfs and btrfs instead.

Thanks,
Tao

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

