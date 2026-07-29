Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E112468C02;
	Wed, 29 Jul 2026 19:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785352299; cv=none; b=RVCEC7i5JN9+sOKhmx+ZIpfPpvg+JpBQ1dGZ65T9n0PLOBsCwbux54dPEHnzMhC+bECKn2wI7phz466W+s/nKi6D8UHcLab5osuN0yn25RX/HRPiusSXwNi1mfpZC9qanSUHqcdqx17ZUYOH5JNsY7Q4j+0XzELwlzZXeNYMC3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785352299; c=relaxed/simple;
	bh=rB4Js7UYzqDiIh7MzO9cGraM2UTHgBwH50L9DoVcgGA=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=opk0rqh7FTMggiUm2WidI787M+ZcokHTNKeALyuaRdqHSt8QGkprdoCXsfigloq0H091SshUHlGOuVdFIySY6p6UCA8qhShcbgJquqL5/xLVGVFh4l/bCb/qyphxZuyornfg1MVvkyAYhJNvs4hrS/WQ4TI2fs8LejuvvFRmA5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nveK2vs1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nveK2vs1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACDA1F000E9;
	Wed, 29 Jul 2026 19:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785352297;
	bh=SeAVASLt1xfqzH2kWzyGKnQBktx/E+ICYqy+dRpovE8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=nveK2vs1xLamt1UbpK3AMBM7CbGuT7Ed0jQcN9YMvhn/YiSaiu/kcZ/Q8CKyQlZVs
	 G8reWDb1FZY+GbOUw52iYs5HtRT7h+Pn3GOGbylF7L9DkDMEGoUCMLZDDgUFPAjuUj
	 TwNSMhYBI+xcOCvurACPEi5/Hvm6MPu3XGu9X8qA=
Date: Wed, 29 Jul 2026 12:11:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Guopeng Zhang <guopeng.zhang@linux.dev>, Johannes Weiner
 <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel
 Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg: stop reclaim when a limit update is
 superseded
Message-Id: <20260729121137.7b451d2d00ca5a389ebeb848@linux-foundation.org>
In-Reply-To: <ammzjkUIADCxO2mP@tiehlicka>
References: <20260724021805.1234583-1-guopeng.zhang@linux.dev>
	<amcT75pLmA0hRUm1@tiehlicka>
	<615d091c-bd3b-4686-817e-5b29756542ff@linux.dev>
	<amdkHvSMj95DUri5@tiehlicka>
	<f706d139-53a7-436d-adc5-c691577ce53b@linux.dev>
	<ammzjkUIADCxO2mP@tiehlicka>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 29 Jul 2026 10:02:22 +0200 Michal Hocko <mhocko@suse.com> wrote:

> > > Is this trying to replicate any real workload? One would expect that
> > > writers to limit do some sort of coordination otherwise the exact
> > > behavior is not really well defined.
> > > 
> > 
> > No, this was not motivated by a reported production workload. We found
> > it through automated randomized testing for our cgroup observability
> > work and reduced it to the reproducer above.
> 
> This is an important detail to be mentioned in the changelog. Describing
> motivation for a change is really important, especially if it has direct
> impact in user interface behavior.

I've been adding details to the changelog as they are revealed to us. 
Below is the state of play.

I await maintainer guidance on how to proceed with this!

The worst-case effects look pretty bad actually.  Should I add cc:stable?


From: Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: mm: memcg: stop reclaim when a limit update is superseded
Date: Fri, 24 Jul 2026 10:18:05 +0800

kernfs serializes file operations only per open file, so separate open
files can update the same memory.high or memory.max file concurrently. 
Both handlers store the new limit before synchronous reclaim, but continue
to use the writer's local target in the reclaim loop.  If another writer
raises or removes the limit, the first writer can continue reclaiming
toward a stale target.

For memory.max, this can leave the writer looping indefinitely once
reclaim retries are exhausted.  The OOM path sees sufficient margin under
the current limit and returns true without killing, while the writer still
compares usage against its stale target and records another OOM event.

Check the current limit at the start of each reclaim iteration and stop if
it no longer matches the writer's target.

Reproducer:

Populate a cgroup with anonymous memory and disable swapping.  Lower
memory.max from one open file, then restore it to "max" through another
open file after the new limit becomes visible.

Without the patch, the first writer remains blocked and repeatedly
increments the OOM event counter.  With the patch, it returns normally.

This was not motivated by a reported production workload.  We found it
through automated randomized testing for our cgroup observability work
and reduced it to the reproducer above.

Link: https://lore.kernel.org/20260724021805.1234583-1-guopeng.zhang@linux.dev
Fixes: 8c8c383c04f6 ("mm: memcontrol: try harder to set a new memory.high")
Fixes: b6e6edcfa405 ("mm: memcontrol: reclaim and OOM kill when shrinking memory.max below usage")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Acked-by: Tao Cui <cuitao@kylinos.cn>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/memcontrol.c~mm-memcg-stop-reclaim-when-a-limit-update-is-superseded
+++ a/mm/memcontrol.c
@@ -4837,6 +4837,9 @@ static ssize_t memory_high_write(struct
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
 		unsigned long reclaimed;
 
+		if (high != READ_ONCE(memcg->memory.high))
+			break;
+
 		if (nr_pages <= high)
 			break;
 
@@ -4892,6 +4895,9 @@ static ssize_t memory_max_write(struct k
 	for (;;) {
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
 
+		if (max != READ_ONCE(memcg->memory.max))
+			break;
+
 		if (nr_pages <= max)
 			break;
 
_

