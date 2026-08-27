Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247CF3D75DE;
	Thu, 27 Aug 2026 22:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787870131; cv=none; b=gT4NPhwsF8TKMvYaV75/tc7FwwS+YvAPE9QlNLx7Sw9+PUvOmC4Az3Xg8ZF/5J/moJvXBgNih7SBrGdLsUtaKb29h3z2hyDC2j8uCaQNqlH0Q1AYB95Xfzg3ADdo6GdjY6XWqNJg9ovlIQ1kps4ssoJo6w2nl1eldDtL/viFqCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787870131; c=relaxed/simple;
	bh=COSX8uy4SnwMDt8ts9jOQMRspzXmH+az348HhZSnk1o=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Pm/smCMdmJtImI5cgrfWhrunmvGZUkA6l7VM/oKpSXvf+24cEts69vROhiZ1CRKjI29ctVrvmaGeSmKagX/9+go8iHR5pcraFXT47arDeS5Uy+hVDKL+sfqJETwE4rs+7nUZ8ErjHlbIxz/u1D95DiEovTA6So/MA4vsbZuW9mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p4dP3qdI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p4dP3qdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FF31F00A3A;
	Thu, 27 Aug 2026 22:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787870128;
	bh=NEGL3tkX29E+ZP0McEKVxJynzb895syCk3QM92mlNxU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=p4dP3qdIJCrBvW5kDTppeje6GliGUYcIFnG6Ywq7nlm4o84rRjlq0fUSIiO00MEyw
	 Sgi4r3ip95lL83gw1QmavrvRPLe5Et7gphzelVusOJVIcoKPDynxEl9O1d+Fu6cpKB
	 JZQ3QcFGoBjUtUGoyH++kybBReMBE1EdE7BskmfY=
Date: Thu, 27 Aug 2026 15:35:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@surriel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
Subject: Re: [PATCH] mm/memcg: fix UAF in drain_all_stock() async work
 during offline
Message-Id: <20260827153527.e0e968a22717f558a22fb893@linux-foundation.org>
In-Reply-To: <20260827124211.3b94b103@fangorn>
References: <20260827124211.3b94b103@fangorn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 27 Aug 2026 12:42:11 -0400 Rik van Riel <riel@surriel.com> wrote:

> drain_all_stock() queues drain work on remote CPUs via
> schedule_drain_work() -> queue_work_on(memcg_wq) and returns
> immediately without waiting. The worker, drain_local_memcg_stock()
> / drain_local_obj_stock(), dereferences per-CPU stock caches with
> READ_ONCE(stock->cached[i]) and does css_put() / obj_cgroup_put().
> 
> mem_cgroup_css_offline() calls drain_all_stock(memcg) to
> optimize reclamation latency, but never flushes memcg_wq. If
> that races with cgroup removal, free can happen while workers
> are still pending, causing UAF. The drain work could also have
> been queued by somebody else before offline started (e.g. high
> throttling), not just by the offline path itself.
> 
> Timeline illustrating the race:
> 
> ...
>
> Fix by having the offline path wait for the workqueue to be
> done with the memcg, before freeing the memcg.
> 
> Found through a code audit with kres.
> 
> Fixes: 591edfb10a94 ("mm: drain memcg stocks on css offlining")
> Cc: stable@vger.kernel.org
> Assisted-by: Hermes:muse-spark-1.2 kres

Sashiko might have found another thing in there:
	
	https://sashiko.dev/#/patchset/20260827124211.3b94b103@fangorn


