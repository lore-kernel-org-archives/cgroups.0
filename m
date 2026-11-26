Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.188
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795706557;
	b=hYDkKY8XsDe3bngFdRGS5sZ8e1dM5zHsRdJmWSeENjwLlZyIETYLgc1036P2NmSCEOLU
	 lCK2/Ap8YL5VupAshUvBmvwb+1z3JhmBt5flnqx6B13BkKCgY1YSz9j7NNYweLm69YTfv
	 1I9nPBTpaqz0azmaUKQh3iWvJ13/n1YnJazFsPGZGmWnN3OAhN4VwEB6RHBXU80U447ZG
	 er7qdMM3Sy6mkp1OFIOoznDcuxpSTgID4NyHkoyw5iYqN1yv8gDnpDsQzR3Xzn7FNsl+G
	 wc6EvqEWs/haRGO2+Ihgy5w5fe5zlJ+9U44p2J0/rxjS47TuxmO2aQMJSS+m0P/xhXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795706557;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ZvT7tk3P1HeqkH7Q6Z2/RmsaVAZjfaSe3LTozOquko0=;
	b=EB6dUcl0AnEmdwle8Lh2U4SIUXXmQu0BJryvQfLnZjc/GteTwmQuhmJ2qmO7oQhWai1e
	 igG/SrkB86KHzA47YCqoO8Q0gC1mzI66gAzc/HIu1Gqd24ehUq19rCTb0vOYBMKV4mQZ1
	 m+d0tzaavV0A3om9vtvviJp+RGh7oxvDVrk4OEvYm4LRFeih9V3szT2YscYzcCLPuXIk5
	 Q8k5JETbYhGvU2Fzno+mi514dA+ALnhqVQOolzYeJhIDziqnihVe8dAysDK1cTTYTZ7Se
	 lvrIiCI/WIQZhLMXoK57gI/DwBdCFDCE5dks3R9TVQW7qMjCipe/CwARYn4PdMREgQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Ks17Enb5;
	arc=none smtp.remote-ip=91.218.175.188
Received: from mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3FB606A321
	for <cgroups@vger.kernel.org>; Thu, 26 Nov 2026 15:22:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E3FB606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Ks17Enb5
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=XxWyPvAJ0IroYsLOy5V5ybJak6wZ0/ht/VqjPuOuhjc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795706554; v=1; x=1796311354;
 b=Ks17Enb5Bv5JBp2cuKuvKzhoShVMZG4mRbSJwl7OZUw3wz/j843U/gHujp3PmAtYu5LSdZi0
 s0bhcvYbkh0XYprknwYneLk9cjUKIWo2y2SAW3gL9AnfJe10PfxWWYIdfm9z+nUut/o1Amh33/a
 sqlnI4/DUwy6GFey0+Qrx30M=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c2ce6ddd70b19568;
	Thu, 26 Nov 2026 15:22:34 +0000
X-Mizu-Trace-ID: c2ce6ddd70b19568
X-Migadu-Flow: FLOW_OUT
Date: Thu, 26 Nov 2026 07:22:26 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Greg Thelen <gthelen@google.com>, 
	Greg KH <greg@kroah.com>, Ming Lei <tom.leiming@gmail.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] mm/vmscan: Fix legacy memcg reclaim deadlock
 against filesystem freeze
Message-ID: <20261126152137.GA738059@shakeel.butt@linux.dev>
References: <17d0d1395c0237d201a1abb2473d51f5@kernel.org>
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
In-Reply-To: <17d0d1395c0237d201a1abb2473d51f5@kernel.org>

On Thu, Nov 26, 2026 at 02:08:56AM -1000, Tejun Heo wrote:
> Legacy memcg reclaim has no dirty throttling, and shrink_folio_list() waits
> for a folio that is under writeback and already marked for reclaim (case 3
> in its comment). That wait can deadlock against a filesystem freeze:
> 
> 1. A task in write() to filesystem B holds freeze protection on B, enters
>    memcg reclaim and waits for writeback of a folio of a filesystem on a
>    loop device backed by a file on B.
> 
> 2. A freeze of B waits for the task to drop its freeze protection.
> 
> 3. The loop worker has to take freeze protection on B to write the folio out
>    and blocks behind the freeze.
> 
> The same applies to any driver that writes to a file on a local filesystem
> to serve block I/O and takes freeze protection for it.
> 
> Reclaim can't tell which filesystem a writeback depends on. Count the
> superblocks that are being frozen and make the wait time out after 15
> seconds. If one is being frozen at that point, warn and give up. Until none
> is, treat such folios like case 2 and skip the legacy writeback throttle, so
> that the task a freeze may be waiting for isn't held up.
> 
> This trades the deadlock for premature memcg OOM kills during such a freeze.
> The wait also no longer hits the folio_wait_writeback tracepoint, and the
> hung task detector no longer reports a task stuck in it for another reason
> as the task wakes up every 15 seconds.
> 
> Fixes: e62e384e9da8 ("memcg: prevent OOM with too many dirty pages")
> Reported-by: Christian Brauner <brauner@kernel.org>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
