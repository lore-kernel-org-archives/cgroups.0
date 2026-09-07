Received: from mta1.migadu.com (out-197.mta1.migadu.com [95.215.58.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5162937C0F5
	for <cgroups@vger.kernel.org>; Mon,  7 Sep 2026 23:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788823536; cv=none; b=YODaHVk0Kl/5v0UdbhibDG4qa/YU4GdJHty1jONkU5t0Um9X6i+3eEiJgV2tEUScZKKzVyXDqT+UhrNx3kL3tG9aw2K0xZsAy6FybA0Eo5AJSz2f0Yx7vqEtmw2MV4MJsVKmLouLb7XDIHa7tFHCivRZUYnwESIESAzBN2wqQjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788823536; c=relaxed/simple;
	bh=PtebkO6fHQqVEN+q6vEw0kJNHvFekDfGiYSLlcOjT4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dFGrjNSIVIZqIl0cSGUZ6qc08KZENMMfnAz7ixqvU/1qklrlAuh/pB247eIgKE57NWJqxv9DjCElQiNfeg/93VsLWnTs8iCB3K0hyuCDYW5F6Ut+9SED6O/senJWyjY6XGZ936XWMpaUJOfrpuOHUi8glDovpnBpOb8+1BrOJ5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QRMHfJnI; arc=none smtp.client-ip=95.215.58.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QRMHfJnI"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=PtebkO6fHQqVEN+q6vEw0kJNHvFekDfGiYSLlcOjT4k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788823533; v=1; x=1789428333;
 b=QRMHfJnIOX0wn1+t3ROZQa/neKVPuqoeelwU6jZWwq8bkye/pufy39LaUF03aq9suHIFE+l0
 1Sj2BJ+QrCEM/tqpyVhxe0CYztCpiRTppqjbAMa808+ws7CmvGkcZOKk5vkwmut8iOgfvKRphfw
 SWfeemSixCUKHRdyEi/5BpFI=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 096a1c17d24f69cc;
	Mon, 07 Sep 2026 23:25:33 +0000
X-Mizu-Trace-ID: 096a1c17d24f69cc
X-Migadu-Flow: FLOW_OUT
Date: Mon, 7 Sep 2026 16:25:31 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	dev@lankhorst.se, mripard@kernel.org, nat@pixelcluster.dev, tj@kernel.org, 
	mkoutny@suse.com, osalvador@suse.de, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, kernel-team@meta.com
Subject: Re: [PATCH v5 5/7] mm/page_counter: introduce an asynchronous drainer
Message-ID: <ap9HiQv7_9cyIe2e@linux.dev>
References: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
 <20260831163752.2193337-6-joshua.hahnjy@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831163752.2193337-6-joshua.hahnjy@gmail.com>

On Mon, Aug 31, 2026 at 09:37:49AM -0700, Joshua Hahn wrote:
> The existing percpu memcg stock drainer schedules a stock drain worker
> per-cpu, one for every CPU containing the target memcg's stock.

But you are introducing remote draining. Why do you need async drainer at all?
Just always drain synchronously.

