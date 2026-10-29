Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.85
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793235044;
	b=JPZit9l0OFHRKrAaTURiHp9F//DaUbinX8UnBMRO6yRABlEoq4q+dyZClBjvXzEnwQac
	 QZ2zuXR2PBzWmdkiENroLhY7VJA/zivXMErnUs9q7DoIRwfMsHZH0hfmee5pNavFcLIJX
	 gpQsnxgLss+p3z0YusWPyYW1SN+j/5pF/bEG+RAj1pxwS8chEi29Brj9BTMXW6hj/5651
	 ZK2MrV13R1KGG659jG8mdVIyIxuUE7ajWrx0KTMujTZk5+Mq7HhhFNl97cJb7gwJVm3Aq
	 KyC0YrdNk7H30FxpjSa9aOPU28diqsq+yxaCMKDPSIw2pHSAUwJci85l5b1WyxnuemA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793235044;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=9jlkrZUAzuKmhcNXjcRTmtM2YznGkNKDrF/0myHv2bo=;
	b=fedA+BKLjCjJ3V+GBwzPTVIHSCVXN7X+NEE7HZERFUyymaGyrvkvo4Fe5C8ii+pApkvx
	 0ATTk/VEEtPAV5ynrdXh1MKFjsyJs1aQeP3MlVc8AZfRv9b8HcTg/7R/yInDhPe39bbfV
	 Qi8hVHnxHUz85Hj3nIVoAlribRJ5jYyGivbKB4clU92KRQVXZAdsj0WA/yRpC1s8PLo0i
	 yWRo2p6qUMP39RN6NXq4VmanCALk1WhfKUvrlqfMbu8Ob1XuFW2jAL/3ktxRcWd4rltYR
	 ZN9q6i//jw1giIdAr9P2V/70cj7/VUr080If0Ctw/DtkkIxOgNn4VfRsu/puRdAeQ/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="N1LHKI//";
	arc=none smtp.remote-ip=95.215.58.85
Received: from mta1.migadu.com (out-85.mta1.migadu.com [95.215.58.85])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45AA606A31A
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 00:50:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B45AA606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=N1LHKI//
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Q3XJhfTS0tfm47sz6O7siJZeY3EESnjTM2GiE8srlRo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793235040; v=1; x=1793839840;
 b=N1LHKI//MPgf+iXRcT4Q3OYr9L/FbixptrASJHlK+mZPgUk4ZO+aswz3d6BrUGMjs8b7kBvg
 RXAtIY3F3/3avJOnTJ6JHQnobGRSiq9E71ZpUfJJ3JIbcJHsIsZFyZg36N5V1hPl1lVmAxDYmyr
 UeQRMKHMdAf/SSR4Wn3L/WDg=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 59cfc123b442d9e5;
	Thu, 29 Oct 2026 00:50:27 +0000
X-Mizu-Trace-ID: 59cfc123b442d9e5
X-Migadu-Flow: FLOW_OUT
Date: Wed, 28 Oct 2026 17:50:21 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 2/6] memcg: Reduce nesting in consume_stock() and
 refill_stock().
Message-ID: <auKYO3MwelgnWKgc@linux.dev>
References: <20261028185034.3607746-1-kuniyu@google.com>
 <20261028185034.3607746-3-kuniyu@google.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028185034.3607746-3-kuniyu@google.com>

On Wed, Oct 28, 2026 at 06:50:14PM +0000, Kuniyuki Iwashima wrote:
> A later patch adds more code to the most nested block in
> consume_stock() and refill_stock().
> 
> Let's reduce the nesting to make the later change cleaner.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
