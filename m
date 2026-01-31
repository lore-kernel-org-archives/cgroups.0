Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764172E6CC2
	for <cgroups@vger.kernel.org>; Sat, 31 Jan 2026 22:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769896912; cv=none; b=U4BdL+nWY6uPi8FEpi3YZ8c5Yod26Q3s378nKbppEiWrMCkE7BrTsE48fCv+uXDTOsHMx9+c/g2xrs71UvP1UynuI5kfEP2QuIJOffbtv9+1Wzkw6yNCHw5rw9uqI3I81liBUXmIWa82bqeCc/Gg8JlJOCHki5MPjviHKCh8cPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769896912; c=relaxed/simple;
	bh=IoNp8lAUZggjMNRuBTjqXS6Ph/tNW9JXJ8GGl+eg/vA=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=epu+8cdtMmxAx9RkMRGwnvcfXY85+hJt1Oq4Y2/c3bUugCr7AYnyGhxTUAz5cGhf+gzEl9Gv0RJuD/MfR7tFRQeQTGmaK0ftS5kRnMPO3WMS8Tw1U9jBxudT8a0v4lUDoMEeuuwlWrrk3YYSzH29h8hFSjilVOsvBh2iWIpbm3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=R4KcuKBf; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="R4KcuKBf"
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769896908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IoNp8lAUZggjMNRuBTjqXS6Ph/tNW9JXJ8GGl+eg/vA=;
	b=R4KcuKBfhFTwYO7Y7Lv6/a8/QUrEjmRP6nSIE/P1vSGlydH2+kjcSnNwU/sQnDClTROohU
	uVU/e1oMBOAoJYTGkd9TBcNy2gkaEYc/PZUe7j0sAMR4xRjEXcUqOynIOwlS7aAiiTU7i6
	1KNlhbg23gME0V+AXLMccKscuWXxBCU=
Date: Sat, 31 Jan 2026 22:01:45 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Shakeel Butt" <shakeel.butt@linux.dev>
Message-ID: <d88b91766dc017e0705b7400b5b2aae313cc64e5@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v2] mm: khugepaged: fix NR_FILE_PAGES and NR_SHMEM in
 collapse_file()
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Johannes Weiner" <hannes@cmpxchg.org>, "Rik van Riel"
 <riel@surriel.com>, "Song Liu" <songliubraving@fb.com>, "Kiryl Shutsemau"
 <kas@kernel.org>, "Usama  Arif" <usamaarif642@gmail.com>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Zi Yan" <ziy@nvidia.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, "Nico Pache" <npache@redhat.com>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Matthew
 Wilcox" <willy@infradead.org>, "Meta kernel team" <kernel-team@meta.com>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260131131511.e5f1ec520fec066b22ca04c1@linux-foundation.org>
References: <20260130042925.2797946-1-shakeel.butt@linux.dev>
 <20260131131511.e5f1ec520fec066b22ca04c1@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT

January 31, 2026 at 1:15 PM, "Andrew Morton" <akpm@linux-foundation.org m=
ailto:akpm@linux-foundation.org?to=3D%22Andrew%20Morton%22%20%3Cakpm%40li=
nux-foundation.org%3E > wrote:

> As the bug is 10 years old I think I'll queue this for 6.20(?)-rc1 with
> cc:stable. Just to get it a bit more time-under-test before -stable
> kernels pick it up. Sound OK?
>

Yup, sounds reasonable.
