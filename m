From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: bpf: use cgroup_lock()/cgroup_unlock() wrappers
Date: Fri, 3 Mar 2023 10:56:39 -1000
Message-ID: <ZAJfB/LuHtE5Iq3i@slm.duckdns.org>
References: <20230303095310.238553-1-kamalesh.babulal@oracle.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677877002;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fjh9IEpIRyNQHewWnw6H4mE9vVwZa4PIB3habustRYM=;
        b=YcOgEPLI7Pxk40hWD3Mrc61wy5H7d33RmImy1dSuT0n4jGUj8+bCu3IGc/pduDoDNP
         D1qe5VQ7yxuzuyqc3/evqmE8QqXcgX0OVNLrCQARJcIhlNXePr0f5m+RdBIjuxKmxgAE
         Ny1FrXP+3lDFuxJrmwArqa5MNDU8AL80bYRhAHPKZN9yKxNUEG2/XnbPi2uMjuAouwim
         7QGe7PZoVhz2SMwK3BOoiE9ORtcdrHAumSQzzZM4SFcycRnJSbsy+7Wu+fxpSIfTlTO+
         tynTtNrbxYrXe9PVRjftdClTEsLfEsILK7GlAllCaveqepfzveMDwsDP8XuqDt2KTIqL
         3j1g==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230303095310.238553-1-kamalesh.babulal@oracle.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamalesh Babulal <kamalesh.babulal@oracle.com>, Alexei Starovoitov <ast@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Christian Brauner <brauner@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Tom Hromatka <tom.hromatka@oracle.com>, cgroups@vger.kernel.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

On Fri, Mar 03, 2023 at 03:23:10PM +0530, Kamalesh Babulal wrote:
> Replace mutex_[un]lock() with cgroup_[un]lock() wrappers to stay
> consistent across cgroup core and other subsystem code, while
> operating on the cgroup_mutex.

cgroup_[un]lock() were added because multi-gen lru wanted to lock
cgroup_mutex from code which may be enabled even when cgroup is not enabled.
That's the only place where that's the case. Hmm... it doesn't really matter
I guess. Yeah, let's do this.

  Acked-by: Tejun Heo <tj@kernel.org>

Alexei, if you wanna take it through the bpf tree, please go ahead.
Otherwise, I can route it through cgroup tree.

Thanks.

-- 
tejun
