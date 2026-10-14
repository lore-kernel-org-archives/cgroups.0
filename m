Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F189447FAFF;
	Wed, 14 Oct 2026 23:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792022260; cv=none; b=klahIXouhZ2Oz31PPSNUKnHd/lpEPZykoTEsanfLby7piEMmEvVc11sXOUafeEM1Avj5jVApGJMDRUnmvN17k7oMAc3onaAA/vyLJRBVIN6/qOKwvuFWPvQFdlWLnNw9ptuwGs7tG+fR++1+zZFzjE1J7I0990kNm6DWJWsnIxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792022260; c=relaxed/simple;
	bh=1BKK9nQBgrz1YMJMNfDANpvI9O9XROHUtWwCM83BlBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ghdby8N6lLlPF+XnRiWYgIQLOxUX/eBDIo+VP/E9GdA1p/G6jzPNx30SsboB4jpR2YIXVV1hVHB9Lp5ASiUpTou/cp9U2N2AlGWulIbr7+mX0QIjluUpZoYxNQDOyeEEyYnPaRh/sNpljkbpXjhR5+LqIl2xW22sPpofrGMnH6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V0dvHgBE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V0dvHgBE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386821F000C4;
	Wed, 14 Oct 2026 23:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792022259;
	bh=lq2yiqf7IKcfbpJMDFOVhRDq022nhbRLUnX2UIpFd4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V0dvHgBEtYHJJe/gvaBfRPvwLAiM5Bu1SbGf4X2mUouI5ixNKKLFy+YaJZTF8HuLS
	 GnTX55DzpJSsRWZ3X2oQ5vYzHXkyQ2eHezAb7x9p0RPJB+MNbgX9hUekUbVtNBvNzp
	 fE5ruAwaZTctogR2uNZOHx1XjwoGarz1wRVMSOn2w/lG6nxjuddoVi0FDJx2OOnvyf
	 IWDs4WDR8ZeJ3kLp1TqPytBNhw7gjQ4+JBR+6Ebx9o0ICZlJE1GEf2y51l/hvleclV
	 pLmcwT04lWC3uvabP+LL0YH0vEQoKE1s5UqOL7n5XmZXM2BYgk3Wys2InAlgwOM72r
	 uOT52HdYr65TQ==
From: SJ Park <sj@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: SJ Park <sj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: memcontrol: remove mod_memcg_page_state()
Date: Wed, 14 Oct 2026 16:57:30 -0700
Message-ID: <20261014235731.3646-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261014-memcg-unused-page-helpers-v1-1-240b37c53831@columbia.edu>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 14 Oct 2026 13:08:20 -0400 Tal Zussman <tz2294@columbia.edu> wrote:

> The last caller was removed in commit c466412c73c3 ("mm: memcontrol:
> switch to native NR_VMALLOC vmstat counter"). Remove it.

Looks correct to me.

> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]
