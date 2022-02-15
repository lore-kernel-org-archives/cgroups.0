From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v2 4/4] memcg: synchronously enforce memory.high for
 large overcharges
Date: Tue, 15 Feb 2022 15:27:32 -0800
Message-ID: <Ygw25FypLsN9ZQaZ@carbon.dhcp.thefacebook.com>
References: <20220211064917.2028469-1-shakeelb@google.com>
 <20220211064917.2028469-5-shakeelb@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=9YjoEPMJYd+J9jPuyADgLhWKC5Rsz82AyQjg0ogfSgw=;
 b=cv6r/R26IwDLGpQQDvmB8iZxRTpDEbeQrW4co9PGz77pUCg8W6ERW+mrpNKDlLP6IERJ
 cs5Yn51ECW9Euwm7ATOq+mptungI0hKzw46TnMX1LKULWO7B6OeKurOBmrzJ90YtJj3q
 J+2S/ZtQvt7hrxYs3rwphmX/R/TOHizRprA= 
Content-Disposition: inline
In-Reply-To: <20220211064917.2028469-5-shakeelb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Thu, Feb 10, 2022 at 10:49:17PM -0800, Shakeel Butt wrote:
> The high limit is used to throttle the workload without invoking the
> oom-killer. Recently we tried to use the high limit to right size our
> internal workloads. More specifically dynamically adjusting the limits
> of the workload without letting the workload get oom-killed. However due
> to the limitation of the implementation of high limit enforcement, we
> observed the mechanism fails for some real workloads.
> 
> The high limit is enforced on return-to-userspace i.e. the kernel let
> the usage goes over the limit and when the execution returns to
> userspace, the high reclaim is triggered and the process can get
> throttled as well. However this mechanism fails for workloads which do
> large allocations in a single kernel entry e.g. applications that
> mlock() a large chunk of memory in a single syscall. Such applications
> bypass the high limit and can trigger the oom-killer.
> 
> To make high limit enforcement more robust, this patch makes the limit
> enforcement synchronous only if the accumulated overcharge becomes
> larger than MEMCG_CHARGE_BATCH. So, most of the allocations would still
> be throttled on the return-to-userspace path but only the extreme
> allocations which accumulates large amount of overcharge without
> returning to the userspace will be throttled synchronously. The value
> MEMCG_CHARGE_BATCH is a bit arbitrary but most of other places in the
> memcg codebase uses this constant therefore for now uses the same one.
> 
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> ---
> Changes since v1:
> - Based on Roman's comment simply the sync enforcement and only target
>   the extreme cases.

Reviewed-by: Roman Gushchin <guro@fb.com>

This version indeed looks more safe to me.

Thanks!
