Received: from mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09C34BA9EF
	for <cgroups@vger.kernel.org>; Mon, 28 Sep 2026 12:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790597322; cv=none; b=LDlJIkP9dKE+Lox5vBseHmRvIH/x/h4+Aoz0TZRvUIL/+gkzSP13cfIiycjNn/itJrFSWj92aAOdotv3QRPi+KRZVd/sUqCOCqh8WCbIaPZZhGKYmtvKi4C4wJdn9GFop/NdxDQZgaMWO0XkNoqy6k0sNxGLqKx2mE1iXLJ3TdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790597322; c=relaxed/simple;
	bh=ngTtFusTfZr+Of7JLZyU1CxmNJum730Dky6yyjZX8hM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=lyXriN0PVXrsJ9Nr+E+iPuB/Gup/tpreDq7etjHOG4yoo60koCuNuB70JONA9JTcgcqQsvFaVQQiuBdmC/qyCvdrKGMQjZlHmgeMie3cQ6o86fVgB43i4lHrQO9sXT9VgucTUi4u9bzwmcIYRo6oSN17zLfFBUIL46nEODbLVAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=exO8AcIo; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="exO8AcIo"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ngTtFusTfZr+Of7JLZyU1CxmNJum730Dky6yyjZX8hM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790597317; v=1; x=1791202117;
 b=exO8AcIopGtVEY45vqBpq1JN4Temm8AG2wOgr+XOdedY/hhBYnHRN9wRIFREBNxwQt/MQzyP
 +Dn6cSne7XZbaXI8ORzFEqIBZU2bNnvn0jdWYJMU9QsSydJD9ipLPi8jeY3NxG2JzlN4pLlvbGv
 QUm9aXmEP7ljh7C0pXZCjNMo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 17011efc67c7e6a9;
	Mon, 28 Sep 2026 12:08:37 +0000
X-Mizu-Trace-ID: 17011efc67c7e6a9
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH RFC v2 1/7] mm/memcontrol: drop unused vmscan tracepoint
 include
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260928114625.3609130-2-ridong.chen@linux.dev>
Date: Mon, 28 Sep 2026 20:08:16 +0800
Cc: Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>,
 Ridong Chen <chenridong@xiaomi.com>
Content-Transfer-Encoding: 7bit
Message-Id: <FFCBD11C-B723-441A-B6ED-6AD6E59648E7@linux.dev>
References: <20260928114625.3609130-1-ridong.chen@linux.dev>
 <20260928114625.3609130-2-ridong.chen@linux.dev>
To: Ridong Chen <ridong.chen@linux.dev>
X-Mailer: Apple Mail (2.3901.100.1.1.11)



> On Sep 28, 2026, at 19:46, Ridong Chen <ridong.chen@linux.dev> wrote:
> 
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> memcontrol.c includes <trace/events/vmscan.h> but does not use any of
> the tracepoints or macros it defines: all tracepoints invoked here come
> from memcg.h and writeback.h.  Removing the include still compiles
> cleanly.
> 
> Assisted-by: Claude:claude-opus-4-8

Since commit 816d9992d9ed, the label we recommend is Assisted-by: LLM.

> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
> mm/memcontrol.c | 2 --
> 1 file changed, 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index aad0498a7bd6..95c2322d4a6f 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -77,8 +77,6 @@
> #include <trace/events/memcg.h>
> #undef CREATE_TRACE_POINTS
> 
> -#include <trace/events/vmscan.h>
> -
> struct cgroup_subsys memory_cgrp_subsys __read_mostly;
> EXPORT_SYMBOL(memory_cgrp_subsys);

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


