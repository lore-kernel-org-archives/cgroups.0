Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.222
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793676254;
	b=ghN6wWhquDHbDZ8Nyy3jEU9JuuARqPLGXFfFAS4yzVUT86SENt9+6Yz/mos3VpzuXjkf
	 zeQjOSiAvvcWTDRJY4UX18Q5mA0UNkqpDcW83tDaurLtGHNyOq9FmyNdLg/hU4nrs8j4A
	 gaR5zvNTzyP1WWeVUVazPKWKG6elBElLePA+nP6b551bQS5L39fiBbAadUP29woQWQZWE
	 Eguy/s2z1D5zS+9/sSACB8erbeKB//xjK61veDQUgmHcpLLQGQR76Z3A/60PcqW+4vYgq
	 orO7P+TN5FanOWVXC8sg2zbYr5HuC5LbrqPKoFnj1cBPKiuqvSRjqF+oHCVV73kJ64Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793676254;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=wp5wIsqhtLnbvTQSbQDkpP6Lf3VZf9FET+wJGcOPy6c=;
	b=T1HfA5Jvwprc4xNj3ZNoJ2XTxaXh2mo36HwRvkMe2Y+t5wYR77Jz6QUlyTVJsZgpNwUH
	 WwLBU7GFhwQ+q8H5r3wOZcJsmOp0WEkdLGSLDy2BOOYmkW8YJ6FxHyDJXl3hEmrBB/i8U
	 gEDi+mNd6v6cW5eQMW+OxVg4PQ41raB4uxNXjq3Oal4Sg6sy4WIy9+3QJt40QA33oJKRS
	 zvQIv0UDO7malJz0Sks6kf8IIPQSFH/mdlE1WWN0NCrmii95fUyw8iMw99lLP6+SkTYS/
	 8U2LZQiR/nGPhorRpQHmiTTeWdFYn2hvrp/6ft+tek0hZ4TOd5jWXGPIkVuqbN+uEfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pg7DV0Uf;
	arc=none smtp.remote-ip=95.215.58.222
Received: from mta1.migadu.com (out-222.mta1.migadu.com [95.215.58.222])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F0F606A324
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 03:24:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65F0F606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pg7DV0Uf
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=WfKCC0CPaetlNjBgBzLRFTMpxvJUSOO4JuL3J0g1AR0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793676251; v=1; x=1794281051;
 b=pg7DV0UfbU/4/aLLusRljQNxRNlkAqmaOmpsqc4y1d2UF3zLuDciHx5aDHN4Lc+F5klOhuVX
 XAwf/+2h8Iq9tlKh8V7EbQJzEAmHDi6WoaL42DY7jCdS+Y4YPSCKX3VSqV83ILCdoMJp1WzPs8R
 a+RI7qify95RqBGNqTwmYnhA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 9e2c220236658063;
	Tue, 03 Nov 2026 03:24:11 +0000
X-Mizu-Trace-ID: 9e2c220236658063
X-Migadu-Flow: FLOW_OUT
Date: Tue, 3 Nov 2026 11:24:02 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	"open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v5 2/6] mm/vmscan: move vmscan tracepoints to a local
 header
Message-ID: <aulT0u_DOUufMrZZ@fedora>
References: <20261031090041.58574-1-ridong.chen@linux.dev>
 <20261031090041.58574-3-ridong.chen@linux.dev>
 <aufpQS0XL-CD9YW_@bogon>
 <2f272a9b-ea83-4157-8968-0081990cb709@linux.dev>
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
In-Reply-To: <2f272a9b-ea83-4157-8968-0081990cb709@linux.dev>

On 11/02/26 at 06:46pm, Ridong Chen wrote:
> 
> 
> On 11/2/2026 9:37 AM, Baoquan He wrote:
> > On 10/31/26 at 05:00pm, Ridong Chen wrote:
> > > From: Ridong Chen <chenridong@xiaomi.com>
> > > 
> > > Move include/trace/events/vmscan.h to mm/trace_vmscan.h so that the
> > > tracepoints can be extended to reference vmscan-internal structures such
> > > as struct scan_control, which is not visible outside mm/.  This mirrors
> > > what several other subsystems already do with their trace headers (e.g.
> > > fs/fuse/fuse_trace.h, fs/gfs2/trace_gfs2.h, fs/lockd/trace.h).  As they
> > > do, set TRACE_INCLUDE_PATH to "." and add mm/ to the include path of
> > > vmscan.o, the only user that defines CREATE_TRACE_POINTS.
> > > 
> > > No functional change.
> > > 
> > > Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> > > Reviewed-by: Barry Song <baohua@kernel.org>
> > > ---
> > >   MAINTAINERS                                        | 2 ++
> > >   mm/Makefile                                        | 1 +
> > >   mm/shrinker.c                                      | 2 +-
> > >   include/trace/events/vmscan.h => mm/trace_vmscan.h | 4 ++++
> > >   mm/vmscan.c                                        | 2 +-
> > >   5 files changed, 9 insertions(+), 2 deletions(-)
> > >   rename include/trace/events/vmscan.h => mm/trace_vmscan.h (99%)
> > > 
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index aaf2825ac945..2ad01107fa05 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -17653,6 +17653,7 @@ F:	Documentation/admin-guide/mm/multigen_lru.rst
> > >   F:	Documentation/mm/multigen_lru.rst
> > >   F:	include/linux/mm_inline.h
> > >   F:	include/linux/mmzone.h
> > > +F:	mm/trace_vmscan.h
> > >   F:	mm/vmscan.c
> > >   F:	mm/workingset.c
> > > @@ -17802,6 +17803,7 @@ R:	Shakeel Butt <shakeel.butt@linux.dev>
> > >   R:	Lorenzo Stoakes <ljs@kernel.org>
> > >   L:	linux-mm@kvack.org
> > >   S:	Maintained
> > > +F:	mm/trace_vmscan.h
> > >   F:	mm/vmscan.c
> > >   F:	mm/workingset.c
> > > diff --git a/mm/Makefile b/mm/Makefile
> > > index 2a3ec53d62ee..277b97f7f8d7 100644
> > > --- a/mm/Makefile
> > > +++ b/mm/Makefile
> > > @@ -32,6 +32,7 @@ KCOV_INSTRUMENT_vmstat.o := n
> > >   KCOV_INSTRUMENT_failslab.o := n
> > >   CFLAGS_init-mm.o += -Wno-override-init
> > > +CFLAGS_vmscan.o += -I$(src)
> > 
> > One nit:
> > 
> > Does it really need the above line? It affects mm/shrinker.c too, did your
> > shrinker.o building fail?
> > 
> > Seems it's redundant because kbuild adds -I$(src) -I$(obj) for every object
> > in the directory since commit cdd750bfb1f7 ("kbuild: remove 'addtree' and
> > 'flags' magic for header search paths"). Please correct me if I am
> > wrong.
> > 
> 
> Hi Baoquan,
> 
> Thanks for the review.
> 
> The line is needed for vmscan.o, and mm/shrinker.c is fine without it,
> because the two files include trace_vmscan.h in different ways.
> 
> mm/shrinker.c only does a plain #include "trace_vmscan.h". The lookup
> starts from mm/, where the header lives, so no -I is needed.
> 
> mm/vmscan.c defines CREATE_TRACE_POINTS before including the header.
> In that case <trace/define_trace.h>, included at the end of
> trace_vmscan.h, includes the header again to generate the tracepoint
> definitions:
> 
> #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)  /* -> "./trace_vmscan.h" */
> 
> This #include is in include/trace/define_trace.h, so the lookup starts
> from include/trace/ and only finds the header through -I. Without the
> flag, vmscan.o fails to build:
> 
> ./include/trace/define_trace.h:118:42: fatal error: ./trace_vmscan.h: No
> such file or directory
> 
> As for cdd750bfb1f7, it doesn't add -I$(src) for every build. kbuild
> only adds -I$(src) -I$(obj) automatically when building with O=
> (see "ifdef building_out_of_srctree" in scripts/Makefile.lib). So
> with O= the line is indeed redundant and vmscan.o builds fine without
> it, but a plain in-tree "make" fails with the error above. The
> explicit flag keeps both working.
> 
> To be honest, I had the same worry at first: I thought every .c file
> that includes the header would need a Makefile change. That's why v3
> used a relative TRACE_INCLUDE_PATH (../../mm) instead. Steven corrected
> me and pointed out that the proper way is TRACE_INCLUDE_PATH "." plus
> -I$(src) for the one object that defines CREATE_TRACE_POINTS [1]. That
> turned out to need only this one line. Thanks again to Steven for
> that.

You are right, my nit was wrong. Learned it from you, thanks for the
detailed explanation.

> 
> [1] https://lore.kernel.org/all/20261014124914.21c21559@gandalf.local.home/
> 
> 
> > Other than the nit, this patch looks good to me,
> > 
> > Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> > 
> > Thanks.
> > >   mmu-y			:= nommu.o
> > >   mmu-$(CONFIG_MMU)	:= highmem.o memory.o mincore.o \
> > > diff --git a/mm/shrinker.c b/mm/shrinker.c
> > > index 4fb424e721bc..4fbdade6d2f6 100644
> > > --- a/mm/shrinker.c
> > > +++ b/mm/shrinker.c
> > > @@ -3,7 +3,7 @@
> > >   #include <linux/rwsem.h>
> > >   #include <linux/shrinker.h>
> > >   #include <linux/rculist.h>
> > > -#include <trace/events/vmscan.h>
> > > +#include "trace_vmscan.h"
> > >   #include "internal.h"
> > > diff --git a/include/trace/events/vmscan.h b/mm/trace_vmscan.h
> > > similarity index 99%
> > > rename from include/trace/events/vmscan.h
> > > rename to mm/trace_vmscan.h
> > > index 8a872990b4be..ad90f0e9bf2e 100644
> > > --- a/include/trace/events/vmscan.h
> > > +++ b/mm/trace_vmscan.h
> > > @@ -648,4 +648,8 @@ TRACE_EVENT(mm_vmscan_kswapd_clear_hopeless,
> > >   #endif /* _TRACE_VMSCAN_H */
> > >   /* This part must be outside protection */
> > > +#undef TRACE_INCLUDE_FILE
> > > +#undef TRACE_INCLUDE_PATH
> > > +#define TRACE_INCLUDE_PATH .
> > > +#define TRACE_INCLUDE_FILE trace_vmscan
> > >   #include <trace/define_trace.h>
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index 9959ca158ce8..79d2d614afd0 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -71,7 +71,7 @@
> > >   #include "swap.h"
> > >   #define CREATE_TRACE_POINTS
> > > -#include <trace/events/vmscan.h>
> > > +#include "trace_vmscan.h"
> > >   struct scan_control {
> > >   	/* How many pages shrink_list() should reclaim */
> > > -- 
> > > 2.43.0
> > > 
> 
> -- 
> Best regards
> Ridong
> 
