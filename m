Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BF43F482D
	for <cgroups@vger.kernel.org>; Mon, 13 Jul 2026 12:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783945904; cv=none; b=sFRilJefrfVqvwoL+tzXgJcjzd9BRtQM1tRH/CTaX6d5RS0W2tN+hOCTyE50Mc24LtiQx4BUAFCwPnseIyD14cxIUYS2gOBNK5UI2wpcKqqR4Pw3x44SrVnkvpjKIIGO7xifgeuFWaQ8ObKEYVz9uqOsc2fGfwvnnDIWcmegAWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783945904; c=relaxed/simple;
	bh=dthRE+BlFw+TWQNOPcF/CmxNRFrGwo5+fll8LJh0BLg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=CTABhtzqYq7LiQtxh7qJ9GzYwHbHUZi346mXUrqPQTI1W28vZhwIJreO/xa5wCgAxxtGurN6C10fek3LXEipOl0xNkPr2ewi99BLXNQlWVASIsUE4oTsO7VmkhJeE1t5jWH+gO8fyBAEzv2ebb3Asv/Ktg7AYhcAtvUsyC9agCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RAZ3e/aw; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RAZ3e/aw"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783945901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oUhcYPLrB310Teap/CNxFNyqUL3uVFa5TFThGRISyng=;
	b=RAZ3e/awoc1DjulIHHhH07ar3DMKCCaS7LV0be+jSRMj5t+uF6xC6dtAJMWahRHQnOVrk8
	fyzmpN6fbyGDtjsJVasRe5vXWFqrJU4OPnn5ourPhzqVF052/UBQPgAMKybKNAt91LIPz5
	kH0H3rRd3yUrb2Oxn5OgBHT3hsmou5Y=
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] mm: memcontrol: drop unused cpu argument from
 flush_nmi_stats
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260713090010.2991906-1-guopeng.zhang@linux.dev>
Date: Mon, 13 Jul 2026 20:31:08 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
Content-Transfer-Encoding: 7bit
Message-Id: <89877E8B-F3FB-439B-8683-EFA191D0286F@linux.dev>
References: <20260713090010.2991906-1-guopeng.zhang@linux.dev>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
X-Migadu-Flow: FLOW_OUT



> On Jul 13, 2026, at 17:00, Guopeng Zhang <guopeng.zhang@linux.dev> wrote:
> 
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> flush_nmi_stats() does not use its cpu argument. Remove it from the
> function and its !CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC stub. The
> caller still uses cpu for the subsequent per-CPU rstat flush.
> 
> No functional change.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Reviewed-by: Muchun Song <muchun.song@linux.dev>


