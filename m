Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.96
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792615175;
	b=ngmm8mTTcNygXhfTGp8tjuFiVV8rFeVyHJtPm303envM1P0+c8MKenw0FJAw0db7LG4A
	 UyAA3i3WzxrjKNA36x8a8Xc1NM/Yu1BfcCNQTMNRY+HtAw85GnuLp3X792o/TU/4+zQLo
	 wypqE1lLNYZJuE4ZNQEX6ubPpq4JWoE5GoEFzuxoX8ztuFlntXzbywOFRtX39TsurrwxB
	 9GtLOh/3WyKdwZX7FZ/9P765crF50eczNqcDi6UUIabnHwPvm09/yqsQMVdbJAji7pPpw
	 L0kHu5aDzzVKUAvHMc91PUYgcxPKnf32JvVcrjqQLPoQs8qLsm7rnoekjth7J0H2bZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792615175;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=Xwh1aSFPGegHIoQoVmZYZJuIasUj9zMikVvUOAaV0Dg=;
	b=rn75h8yF0mm+iwy1qDvgd73hzAA6+7qTt6rvS8D2zqlUfMO9eqsZNk6/OKRFs90EyoK7
	 WgAXk3gKnj5jCEblP2xX+KdQeZCuU3sZ5E18lBM9NeH2lhSXinEMqG9fR1wmqbndCghKW
	 smU0O+laATuzMn1fpz0BrVBkXLFNY21LJrUwqU2ljDCldhHakCSEOKp2CKtn0YGcFkr5Y
	 tZ23hbaJRd9pMPGCCYBsBHGeX1R/qIFqEL3dWN7/hGkQ9o+BEVjloYkOJUOOmOVwbK2wB
	 hjElXLEoBn4cWRmVykijIDWBb5mwH0mnODThZ8HBoJryosZOVhAbWC8S9jEVvTL8V4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=agM7aTRp;
	arc=none smtp.remote-ip=95.215.58.96
Received: from mta1.migadu.com (out-96.mta1.migadu.com [95.215.58.96])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0B3606A319
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 20:39:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB0B3606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=agM7aTRp
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=vClqkVTrJPkFYg5VhfJJpI0t2mCXeKvHhObIxE+Ggik=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792615172; v=1; x=1793219972;
 b=agM7aTRpgrVVNIvEBdzc+AzCrrXGmqKdLwlSSfeBLwT428NEbTqdx1lrTmfBO/DA55bB/jZr
 R/Tr9v6a1G/d0vFNjAmGZou5C4kS65zrPrj0SsoMj0BBtI94l+SJx9nrYw58Fp+R7YK6/A3376F
 jewissj2UA5AW0xN2ZbPV+RY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7c45c0e98498beff;
	Wed, 21 Oct 2026 20:39:32 +0000
X-Mizu-Trace-ID: 7c45c0e98498beff
X-Migadu-Flow: FLOW_OUT
Date: Wed, 21 Oct 2026 13:39:27 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1] memcg: fix cacheline contention between lruvec stat
 updates and LRU lists
Message-ID: <atkiieAmMFxImIXI@linux.dev>
References: <20261020200730.250189-1-joannelkoong@gmail.com>
 <atfrhsr6bft4t7SI@linux.dev>
 <atjhiAxEyoP48e0X@linux.dev>
 <CAJnrk1Z=ZqTvfO_VYjG=KnHRvwmhNBfYfxpiZiKWPdMYnsA2qg@mail.gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1Z=ZqTvfO_VYjG=KnHRvwmhNBfYfxpiZiKWPdMYnsA2qg@mail.gmail.com>

On Wed, Oct 21, 2026 at 01:04:36PM -0700, Joanne Koong wrote:
> On Wed, Oct 21, 2026 at 9:12 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
[...]
> 
> Sounds good, I'll go the layout rearranging route then. I verified on
> the Intel machine that rearranging + the pgdat change gives the same
> results as this v1. Do you want me to include your rearrange patch in
> v2 (with your authorship and signed-off-by) or do you prefer to post
> it yourself and I'll send the pgdat change on top?

You can take the patch and the ownership/authorship as well and post both
patches.

Shakeel
