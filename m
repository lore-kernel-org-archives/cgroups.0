Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF80F3451A9;
	Wed, 18 Feb 2026 17:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771434239; cv=none; b=eNMY1QO2QwS8eboNq4rgihkOuPQkfkIOCVrWe2rleRLWsvjvIq0rjV/MSmsQNcYQWMZNLWtanskZYL52GTXV/X2jkFsJgV9lrZ1sYHxB7s2NWDApkB85HdTIMOfVg20r/U42E1cd/eIa0zepMM2g9ejxREAsHjm6fpXKJq7l3g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771434239; c=relaxed/simple;
	bh=+k0PgHhrvvyg6ccYpP5IwGNH1Kdb8jcyStKeoksRPno=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=c67JXt1/nZKfrZzgJuqZGGuHnTQSSlcFRSt0RrhffxXEd5erIjiJ+yAJ54FUnrR0P/ZgExiibcF6q+MzNE5Vjw5E4r1KdPD3kfYdYHhoxadCU6yu5SgA6A91D7EZd4HCcbmPkdnhxdMXoquTzdyoOor2feteUQYmscTKLOEzi34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U/2wFFvo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U/2wFFvo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54730C19422;
	Wed, 18 Feb 2026 17:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771434239;
	bh=+k0PgHhrvvyg6ccYpP5IwGNH1Kdb8jcyStKeoksRPno=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=U/2wFFvoyHPXoTgMtWuPOnD1QbNEGNVqafZ+ze1A12NTILjzwR0pnkfoWyEkKP8Pa
	 W3ZQLhkHzUOqgzKpdbjIdhdGTWhH7HpJBAMUnCaxZ6TGLY8ODecUDxa2ZE3pbz2dvn
	 j8+26D5oI268YWgcP5EHh2A8+vrBKMqMYQVZf/8QH9KK4bm+w4CocgiwNO3ndtLIvs
	 ac7w8giq99HBB4oxYCyGaEbjV5nPCMw18ZucJIHpi/7fAASUOj2AhCNHHvFph7DKgM
	 870rfYN7n7NT4BbiaGKy1SOSo1XjbWjnILdKXZKOvubTYWm7fcsIp8xMSGlI+IxI1h
	 g/C2y9RcQPPSw==
Date: Wed, 18 Feb 2026 07:03:58 -1000
Message-ID: <9a26e18bb0ff00bc6cf894dab8443242@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Cc: lizefan.x@bytedance.com, hannes@cmpxchg.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: free cset links on find_css_set() failure
In-Reply-To: <20260218120543.1113594-1-kaushlendra.kumar@intel.com>
References: <20260218120543.1113594-1-kaushlendra.kumar@intel.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

[This is an AI-assisted review.]

On Wed, Feb 18, 2026 at 05:35:43PM +0530, Kaushlendra Kumar wrote:
> When the recursive find_css_set() call for the domain
> cset fails, tmp_links allocated earlier are not freed,
> causing a memory leak.
>
> Free tmp_links before returning NULL to prevent the leak.

tmp_links entries are consumed by link_css_set() which list_move_tail()'s each
entry off tmp_links and into cgrp->cset_links and cset->cgrp_links. The
BUG_ON(!list_empty(&tmp_links)) right after the linking loop (line 1281)
confirms that tmp_links is empty by the time we reach the threaded cset
handling code below.

The links, now owned by cset->cgrp_links, are properly freed by
put_css_set(cset) which is already called on this error path.

So the added free_cgrp_cset_links() call would just iterate an empty list and
is a no-op. There is no leak here.

Thanks.

--
tejun
