Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794290472;
	b=BCKYA1C3FrYsth7JhoGCWdIxJcmz1kolTFDuw9y452iQwl/hVOApFUV4ZSWaf89jxmbU
	 94oPM4t0UJcEYAkpvJ9N1nS3T9x7PUBfFZRCM3Z89eHKmjv/dOOz7D4zRyFi3yuJErc1T
	 PzWSdBRFRrNP47M1IyyotO/scnw7Oyp3sKFXRISj3HECSjJbCj6IrEETIvS2dBL4NE9q1
	 7Hp7Bd8K88MLRZjEdF9Sq8w/pGDiiUcL3G78pJwWQ/9ufojwNhuIUxEJjvWcZTNGnJe4Q
	 nK+QpCHBvMkWWKFjHFWGksFGEGAfLC5Pl+oHpOvdSaCLlZ3ZegqES+/wb9bJbsP9BuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794290472;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=VLh8JQ8NDxlXvfdd8nmZgCeYY6KJkmD5D5lm9FmA80I=;
	b=m5FdO9+cXdLd+FplkPBB0kQmitcwDLvzYFhKPymt8pz6gbWR4LZxgl/K0y/k0xSzZ1ai
	 qRjDaw66/o/Cn0odCJ3Pf9jUCQMhtDtm+JVRYse59+WJoh6ddkhjxZhhGVrSZCFURZUQ8
	 cIZA5rMxGD44O5b4AMRLIxiYt0OGZW8CL5RxFYohhIKKeNr9tC02js+k/hpHuREqQ0n12
	 6lDj9qUoFZNe9fgmAcZ5PrD7QLz4LlZcYvzxZjyXUg8/6L9dYLXa6Uud9fVITjX06g3ve
	 PYM0LSNbFhhSEd+JBOQIkZY7w9/0/IUe5xY+zokZMLJiF36NUOKsexZkaS3sDlRRF2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lXJjwAxu;
	arc=none smtp.remote-ip=91.218.175.10
Received: from mta0.migadu.com (out-10.mta0.migadu.com [91.218.175.10])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A830606A321
	for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 06:01:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A830606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lXJjwAxu
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=VA3K6iPo/olQKGrY3SmZDnY715mLMX0FXtR/KjMqe7Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794290469; v=1; x=1794895269;
 b=lXJjwAxuAyUigPchBpexbmn0zCmwp8bYRR0IhFKbYxZ6sAuSu9WOnlwmUqQmKmES4Zo6BmzD
 1OUYjlLuHFgvRVo8XSG2TZ+w4KGzA0AAXSf9Yu+IIPxqIqKXATyhQattCvw1mKezI6I7/e+4gWJ
 Uw+GzuJvSc0FC0JFea1QJnQw=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2ff0dc8c22bc786c;
	Tue, 10 Nov 2026 06:01:08 +0000
X-Mizu-Trace-ID: 2ff0dc8c22bc786c
X-Migadu-Flow: FLOW_OUT
Date: Mon, 9 Nov 2026 22:01:06 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mingyu He <mingyu.he@shopee.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	Muchun Song <muchun.song@linux.dev>, Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, littleswimmingwhale@gmail.com
Subject: Re: [PATCH] memcg: keep propagating stats updates to ancestors
Message-ID: <avKy9oMwDRjKjfzm@linux.dev>
References: <20260911032905.63683-1-mingyu.he@shopee.com>
 <aqRXqcynCx88D2QK@linux.dev>
 <CAAoBcuS=sqOAPFr9Gda9aTwuCMHMPzBMEee8qvPNHtNxrRWKuw@mail.gmail.com>
 <asy_L2s1TNcN7bOK@linux.dev>
 <CAAoBcuS5VJwsYyw9=77SaBUf3N1hL8NfRtGwpBhmyUUhT4+T8w@mail.gmail.com>
 <CAAoBcuRfhFf4p5qfWZnNs5=4foeE6jtGFggG5XHmMi6cXwje9w@mail.gmail.com>
 <20261109212410.ca24bffef1abcd50b3f58c13@linux-foundation.org>
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
In-Reply-To: <20261109212410.ca24bffef1abcd50b3f58c13@linux-foundation.org>

On Mon, Nov 09, 2026 at 09:24:10PM -0800, Andrew Morton wrote:
> On Tue, 10 Nov 2026 11:17:37 +0800 Mingyu He <mingyu.he@shopee.com> wrote:
> 
> > hi, gently pin this email.
> 
> I think Shakeel is suggesting that the bpf caller be altered to also run
> css_rstat_flush() regardless of the update threshold.

Sorry for the late response. Yes, just always force flush.
