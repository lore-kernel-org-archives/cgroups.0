Received: from mta0.migadu.com (out-3.mta0.migadu.com [91.218.175.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4886A480320
	for <cgroups@vger.kernel.org>; Wed, 12 Aug 2026 23:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786578269; cv=none; b=qqo0+K7mgGmrHYQmuuooNNfyA7Jy2f6po5rSzaPXr2x/F0V+PkU/2GQA7zGdUWzOshiLG3HrZtE/IazMTEFQtjgkxZ1AFJfR3TplanSQ9u5+7ngUOQyjAvbJJ1n8Lk06Jjew1al/vTEv9/ukkOecxgcIxHEOSw4ppPmh0LR1fQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786578269; c=relaxed/simple;
	bh=GRGPu0x1sRERIuQs56PTW8nQYd9NgZlk3OlXceQWbKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g6E9DybaWkugXroMQCj+RY1KSo7y77Tq8cmSgliAwKbknjXQuy0Fq4d+YMPW5GFCMGsmh4RBHzG8+kRfzEYibrAJ9nsyaIRtNb3zZi1EAgojFGPAXxpfaN/pSyrQPP1O1Fgwe3rbXAo+seJNgpEQ+dahvHOFko6T1USreGrJv9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=V7Au1q1M; arc=none smtp.client-ip=91.218.175.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="V7Au1q1M"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=GRGPu0x1sRERIuQs56PTW8nQYd9NgZlk3OlXceQWbKE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786578265; v=1; x=1787183065;
 b=V7Au1q1M522y8KIDAXqAu3KtyfWzd2A2IYxgxXkZPwVPEnBlOOFlRiy2BRPHLE6WeS/cJkgO
 smiZye2sltUNYM69JXanNC58hwcca1b+HXG21ihDSu5ecs5SRDDJf8S76gg919S5ej7BlVE+wHK
 jfKBlhCtrZcR9868IexsKYZU=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff::)
	by smtp.migadu.com with ESMTPS id d0345f5f1396112a;
	Wed, 12 Aug 2026 23:44:25 +0000
X-Migadu-Flow: FLOW_OUT
Date: Wed, 12 Aug 2026 16:44:19 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Harry Yoo <harry@kernel.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Guopeng Zhang <zhangguopeng@kylinos.cn>, Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: Re: [PATCH] mm: memcg: fix slab over-accounting for in-object objcg
 metadata
Message-ID: <an0E_lt2_53GBWjt@linux.dev>
References: <20260812124858.73487-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812124858.73487-1-guopeng.zhang@linux.dev>

On Wed, Aug 12, 2026 at 08:48:58PM +0800, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> obj_full_size() adds the size of an obj_cgroup pointer to s->size to
> account for slabobj_ext storage, which normally resides outside the
> object.
> 
> Since commit a77d6d338685 ("mm/slab: place slabobj_ext metadata in
> unused space within s->size"), slabobj_ext can reside in object padding
> already covered by s->size. The extra charge then accounts for the same
> memory twice.
> 
> The per-slab obj_exts_in_object bit introduced by commit b5bc35ace2c5
> ("mm/slab: replace slab.stride with obj_exts_in_object") identifies this
> layout. Use it to omit the extra charge only for in-object metadata.
> Unlike in-object metadata, slab-leftover and separately allocated metadata
> are not covered by the per-object s->size charge, so retain the existing
> charge for those cases.
> 
> Reported-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> Link: https://lore.kernel.org/all/20260310113804.245647-1-ranxiaokai627@163.com/
> Fixes: a77d6d338685 ("mm/slab: place slabobj_ext metadata in unused space within s->size")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

This looks good to me but would love to have Harry's comment on it.

