Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B526C38657E;
	Mon, 10 Aug 2026 18:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786387671; cv=none; b=QdLAET8DpjWnMkF1lItNsPQgwrjLw2Vh6jcg5N0tFsDz7L1+CH8+rRBXQs7zzuILdf4uwLjd5XAtxKh3c50+zYmPUVBspdNkZEA/fTO1jaN07pOiEZqIOFEL2CHMdfCbwJYvCVhAhgw480HJgx7LNaLvFR6rYixq1Hhc8pxTROc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786387671; c=relaxed/simple;
	bh=NQMee7lj8b4cufJTkRz4n7UskU6d0JWCHr0J01tNg14=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=RCQFF1ABD3D0iOZWupmHVBtoVZcOAPBvaoMwlVxKiUdDv4YUhI2VL2JOgGxOaAJvkUHVSff3cm9TsqJ2BHbFUefFdHX2QrnopSUx0I0Th8YuDFYBlfyPJAqEGtCKaTQ9s5xgIfktBON17dKeTEoWVe043VKFOIPBmv29gWA3Fb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FDk/wa2h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FDk/wa2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB311F000E9;
	Mon, 10 Aug 2026 18:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786387670;
	bh=0w728h8icPOZezsigPZsZBoOdqBJYx/Mg08jfuV+mUI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=FDk/wa2hVQ/aXEiG+6BYcDeC2PkXBp/oq1Hl3vZgWrWjAynskGBSByAmCfYlitZpA
	 k0iI11PAv+AHVT9ktIXKr7OaS1cGfEO8M/YDq6W4CEUMCPAYr6ftCNr3Uf0Tzoy7Xy
	 7A6st2itWvV6nwfwlseYaZ80VwbdgFy5GYhZLeo0=
Date: Mon, 10 Aug 2026 11:47:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: shakeel.butt@linux.dev, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Guopeng Zhang
 <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg-v1: fix memory.memsw.failcnt accounting
Message-Id: <20260810114749.368140ad5be4fa10085bbee0@linux-foundation.org>
In-Reply-To: <20260810074247.52747-1-guopeng.zhang@linux.dev>
References: <20260810074247.52747-1-guopeng.zhang@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 10 Aug 2026 15:42:47 +0800 Guopeng Zhang <guopeng.zhang@linux.dev> wrote:

> Commit 0e2759afcaf9 ("page_counter: track failcnt only for legacy
> cgroups") made failcnt accounting conditional on track_failcnt. It
> enabled the flag for memcg->memory, but not for memcg->memsw.
> 
> Consequently, memory.memsw.failcnt remains zero when the memory+swap
> limit is hit. Enable failcnt accounting for the v1 memsw counter.
> 
> Reproducer:
> 
>     CG=/sys/fs/cgroup/memory/memsw-test
>     LIMIT=33554432
>     mkdir "$CG"
>     echo "$LIMIT" > "$CG/memory.limit_in_bytes"
>     echo "$LIMIT" > "$CG/memory.memsw.limit_in_bytes"
> 
> Start a child process in the cgroup and make it allocate and touch 96 MiB
> of memory, causing a memcg OOM.
> 
>     cat "$CG/memory.memsw.failcnt"
> 
> Without the patch, memory.memsw.failcnt is 0. With the patch,
> memory.memsw.failcnt is greater than 0.

Thanks.  Nice changelog.

> Fixes: 0e2759afcaf9 ("page_counter: track failcnt only for legacy cgroups")

I'll add cc:stable to this.

AI review thinks that memcg->tcpmem.track_failcnt should receive the
same treatment:

	https://sashiko.dev/#/patchset/20260810074247.52747-1-guopeng.zhang@linux.dev
