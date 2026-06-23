Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B945236A342
	for <cgroups@vger.kernel.org>; Tue, 23 Jun 2026 01:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782178435; cv=none; b=cyvdYj6ynWS8l2M2TvAlx5Gmha5GonZN+8XouPV5q92QcIJJlfR6OaSMU4r1icBzqyKNWXzyBfyPsxjLE3hmHadyacfdzvjzvt7P9JhkUFWZ0ZvYHCIaKDmWWCgWY4pn3PpN92kWFfZelyTYEoR5O3Y0jFmawDMnoHbo9D9UUlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782178435; c=relaxed/simple;
	bh=5L9DX9oqKDlgDsJTijyiFSJdSHzrES276FS+VIXBFOw=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=JKVIZvth4fWoQAzsiyrK9BqWedjfOxO1Y4EZOgoVyCE+V7awxtLb/lW7PN9jDFpSZVi5KEaUCJi4CZ7UPCFZAuFutVkRvZyDxM8NLVqdOluYc0xr/A4NQIa0gVd/4ix2zKGPQfkB5tjSMpYjJjm+WzgVeCJAA11Iy4QHBk5wJWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Dh+I3r0F; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Dh+I3r0F"
Message-ID: <97aa10a4-0632-46a1-ac34-ab4fdccef73e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782178421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5L9DX9oqKDlgDsJTijyiFSJdSHzrES276FS+VIXBFOw=;
	b=Dh+I3r0F/aGWYrKZp/CP8UZDX32V0zXSLodpVy77f4D6GH2klrwfBOc86HlIXceOjmpigB
	kGOVzG51fvCmLGR+MrnSAhMOlnjXflxC3/b31fG36X5L5TUtlaec0Ce8KTOak697hY8wSD
	yD2Br4u1VP/XY575zRM2+AD2vtuSrf8=
Date: Tue, 23 Jun 2026 09:33:23 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Cc: cui.tao@linux.dev, cgroups@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH] block/cgroup: Drop stale -EBUSY retry from
 blkg_conf_prep()
To: Yang Xiuwei <yangxiuwei@kylinos.cn>, Tejun Heo <tj@kernel.org>,
 Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>
References: <20260622085623.520209-1-yangxiuwei@kylinos.cn>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260622085623.520209-1-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



在 2026/6/22 16:56, Yang Xiuwei 写道:
> Since commit 8f4236d9008b ("block: remove QUEUE_FLAG_BYPASS and
> ->bypass") nothing in the blkcg blkg lookup/creation path
> returns -EBUSY anymore...

Correct. I traced every error path in blkg_conf_prep() (and blkg_create()
underneath it): the only possible values are -EINVAL, -EOPNOTSUPP, -ENOMEM,
-ENODEV and -EEXIST (from radix_tree_insert). The -EBUSY source was indeed
the blk_queue_bypass() check removed by 8f4236d9008b, so the retry branch
has been dead since 2018. Clean removal with no behavioral change.

Reviewed-by: Tao Cui <cuitao@kylinos.cn>
