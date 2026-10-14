Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E284E0B74;
	Wed, 14 Oct 2026 16:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791996564; cv=none; b=mEAPMVBTnIbnCJijCc/E8F9vEaNUbfxAZ0Dr9LxtCw+wh2UWoyoJazGau/D7fU20S2A4DNRVfLl4whT5jt4KGkXkhq2/59pG/GNe4Upcro1es3PkbIJFsT3ClN3uwqjJ1VzXthwLZG/0H3IWZZt5X8Hr9KIDjXzwbmBb4Q/C/QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791996564; c=relaxed/simple;
	bh=iSzaasvYvUiPzay+T0vJl6ArYMMDfH1SvrRmE73kiCI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RQPeWrldQfgV680T1cIwcYIGp9M20MmeYyNPyShdXDmJ1VEuc4GWgVKaQroH8+gBomYM7uqNn9l5IzK8wu2LxAJ2TdUv8ykyhOYpLDc1TxF6WuesptIeOrrGb2TUaMyrYhcMtIDUAhjIXjxDvr0uTGW09GG++qqSfpXTrV2k3c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; dkim=pass (1024-bit key) header.d=goodmis.org header.i=@goodmis.org header.b=ZDjXae7y; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=goodmis.org header.i=@goodmis.org header.b="ZDjXae7y"
Received: from omf03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 02FCF8066A;
	Wed, 14 Oct 2026 16:49:17 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf03.hostedemail.com (Postfix) with ESMTPA id AE89A6000A;
	Wed, 14 Oct 2026 16:49:12 +0000 (UTC)
Date: Wed, 14 Oct 2026 12:49:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Johannes Weiner
 <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Andrew
 Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Muchun Song
 <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Kairui Song
 <kasong@tencent.com>, Barry Song <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, cgroups@vger.kernel.org (open
 list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
 linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER
 (MEMCG)), bpf@vger.kernel.org (open list:BPF
 [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)), Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH RFC v3 2/7] mm/vmscan: move vmscan tracepoints to a
 local header
Message-ID: <20261014124914.21c21559@gandalf.local.home>
In-Reply-To: <20261013131309.2790253-3-ridong.chen@linux.dev>
References: <20261013131309.2790253-1-ridong.chen@linux.dev>
	<20261013131309.2790253-3-ridong.chen@linux.dev>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: AE89A6000A
X-Stat-Signature: m7phkurr8zpyipefydjfncabm6u6cuns
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+2sabA8ApyQWp0KnP/HFLarVznZroqxp8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=a+jcCItmaVXvg0z3J5thFi2DsdWgCqN1j0EvdcEpj+w=; b=ZDjXae7yuY6daMhM/4jUFORVKfWrh7M3m7I1np8JJtIWO0CX68GmjeT7EEVC1ueFMeDDVtX+N0muCfk5WRWHbSgc3XbOFNIkK4Nj34ba3mrfYqHMKXppwgYEcaSgfHzFG3iN+YEgpe7FhA3ei48+cNoN4yD25t67Ejic1h5NyCw=
X-HE-Tag: 1791996552-398790
X-HE-Meta: U2FsdGVkX19WVIU50DbwQWQ1335aLD0DaAIUgIjNIvQ8PuHEzItAimjZ4jWFcbqXC2uQEeUl7OKKLjZZpqhlsOaTbjlt0g5JFPmtMPCLWd9sgUdQcyxnOwQ9CrJywM/QBRoqk8hbQOdJ5cDAQ38RYSlBz42nBJ9pNyLbe1tCYpApGPKp22Oa2OjUc3CRjYiV0EMElzxmGb+AOBSJE1PpBYmHO62axI0wg8DN/AGB2Fz/pcSXsN9QshQLIDo4IsZLu842OjTboQLK+3/GThFKibADAVexEZE1mMy7lMzdC84/ITa6ABJ7EBW9GFfPexV4kY5mT03a2mPMNhzIeu716uT2F3rGLy6OzmbqiER2EFUx9vVE/uNHHDyOU4TQUvYUCeaVChZwsFA4sPdaMEuwILWLuKMZRRdliS2SdjRcvmM=

On Tue, 13 Oct 2026 21:13:04 +0800
Ridong Chen <ridong.chen@linux.dev> wrote:

> From: Ridong Chen <chenridong@xiaomi.com>
> 
> Move include/trace/events/vmscan.h to mm/trace_vmscan.h so that the
> tracepoints can be extended to reference vmscan-internal structures such
> as struct scan_control, which is not visible outside mm/.  This mirrors
> what several other subsystems already do with their trace headers (e.g.
> arch/x86/kvm/trace.h, drivers/gpu/drm/drm_trace.h, net/xfrm/trace_iptfs.h).
> As they do, use a relative TRACE_INCLUDE_PATH so that no Makefile change
> is needed.
> 
> No functional change.
> 
> Assisted-by: LLM
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  MAINTAINERS                                        | 2 ++
>  mm/shrinker.c                                      | 2 +-
>  include/trace/events/vmscan.h => mm/trace_vmscan.h | 4 ++++
>  mm/vmscan.c                                        | 2 +-
>  4 files changed, 8 insertions(+), 2 deletions(-)
>  rename include/trace/events/vmscan.h => mm/trace_vmscan.h (99%)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c5519d67b6f4..80d2a9dd0525 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17575,6 +17575,7 @@ F:	Documentation/admin-guide/mm/multigen_lru.rst
>  F:	Documentation/mm/multigen_lru.rst
>  F:	include/linux/mm_inline.h
>  F:	include/linux/mmzone.h
> +F:	mm/trace_vmscan.h
>  F:	mm/vmscan.c
>  F:	mm/workingset.c
>  
> @@ -17722,6 +17723,7 @@ R:	Shakeel Butt <shakeel.butt@linux.dev>
>  R:	Lorenzo Stoakes <ljs@kernel.org>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> +F:	mm/trace_vmscan.h
>  F:	mm/vmscan.c
>  F:	mm/workingset.c
>  
> diff --git a/mm/shrinker.c b/mm/shrinker.c
> index 7ec2a9704f6f..3c3e87c4b61c 100644
> --- a/mm/shrinker.c
> +++ b/mm/shrinker.c
> @@ -3,7 +3,7 @@
>  #include <linux/rwsem.h>
>  #include <linux/shrinker.h>
>  #include <linux/rculist.h>
> -#include <trace/events/vmscan.h>
> +#include "trace_vmscan.h"
>  
>  #include "internal.h"
>  
> diff --git a/include/trace/events/vmscan.h b/mm/trace_vmscan.h
> similarity index 99%
> rename from include/trace/events/vmscan.h
> rename to mm/trace_vmscan.h
> index 8a872990b4be..c5d824fef554 100644
> --- a/include/trace/events/vmscan.h
> +++ b/mm/trace_vmscan.h
> @@ -648,4 +648,8 @@ TRACE_EVENT(mm_vmscan_kswapd_clear_hopeless,
>  #endif /* _TRACE_VMSCAN_H */
>  
>  /* This part must be outside protection */
> +#undef TRACE_INCLUDE_FILE
> +#undef TRACE_INCLUDE_PATH
> +#define TRACE_INCLUDE_PATH ../../mm

The proper way to do this is to have:

#define TRACE_INCLUDE_PATH .

And update the Makefile with:

CFLAGS_vmscan.o := -I$(src)

-- Steve



> +#define TRACE_INCLUDE_FILE trace_vmscan
>  #include <trace/define_trace.h>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 29b31446fc11..6207dad9e644 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -71,7 +71,7 @@
>  #include "swap.h"
>  
>  #define CREATE_TRACE_POINTS
> -#include <trace/events/vmscan.h>
> +#include "trace_vmscan.h"
>  
>  struct scan_control {
>  	/* How many pages shrink_list() should reclaim */

