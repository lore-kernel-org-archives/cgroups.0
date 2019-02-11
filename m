From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 2/2] mm: Consider subtrees in memory.events
Date: Mon, 11 Feb 2019 14:01:15 -0500
Message-ID: <20190211190115.GC13953@cmpxchg.org>
References: <20190208224319.GA23801@chrisdown.name>
 <20190208224419.GA24772@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=s09oajM8sRG6VR42JLX9NXyJV4gfvXuCrn6cD3FbZqw=;
        b=fR9XwG2IpAJnHWw0MPBfz0HAX7xH++BkHbFzdYsjyY2FzzSQFnOya2QKZoELQ/IC5O
         8Dk/hBPxZ0V9ikPopvPDe6YxClqHJSPNu1lZ87Q2cVLMHwm3C8kKQ6WVmLFZXPEsz3HR
         nk0JyG9P2MV9qyR1u2B3Xw3gJO/S9XhKwPznBWi+552PjkO8ma2qfoEUpctr7+xltiHq
         U0S6AsRR2MhGChi8V+igCAz55oV0a1ftWgNSfONzCoxSz9AXXndTZ37wJ/dMBqvXEFXY
         +XOiZ81yTVgf8Ej4uzhR7/jhIkE2VBZSgSaFyAlZwRqoU0RCaJewWGnOx0Db/jxAlBs3
         WMrg==
Content-Disposition: inline
In-Reply-To: <20190208224419.GA24772@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

On Fri, Feb 08, 2019 at 10:44:19PM +0000, Chris Down wrote:
> memory.stat and other files already consider subtrees in their output,
> and we should too in order to not present an inconsistent interface.
> 
> The current situation is fairly confusing, because people interacting
> with cgroups expect hierarchical behaviour in the vein of memory.stat,
> cgroup.events, and other files. For example, this causes confusion when
> debugging reclaim events under low, as currently these always read "0"
> at non-leaf memcg nodes, which frequently causes people to misdiagnose
> breach behaviour. The same confusion applies to other counters in this
> file when debugging issues.
> 
> Aggregation is done at write time instead of at read-time since these
> counters aren't hot (unlike memory.stat which is per-page, so it does it
> at read time), and it makes sense to bundle this with the file
> notifications.
> 
> After this patch, events are propagated up the hierarchy:
> 
>     [root@ktst ~]# cat /sys/fs/cgroup/system.slice/memory.events
>     low 0
>     high 0
>     max 0
>     oom 0
>     oom_kill 0
>     [root@ktst ~]# systemd-run -p MemoryMax=1 true
>     Running as unit: run-r251162a189fb4562b9dabfdc9b0422f5.service
>     [root@ktst ~]# cat /sys/fs/cgroup/system.slice/memory.events
>     low 0
>     high 0
>     max 7
>     oom 1
>     oom_kill 1
> 
> As this is a change in behaviour, this can be reverted to the old
> behaviour by mounting with the `memory_localevents` flag set. However,
> we use the new behaviour by default as there's a lack of evidence that
> there are any current users of memory.events that would find this change
> undesirable.
> 
> Signed-off-by: Chris Down <chris@chrisdown.name>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: Dennis Zhou <dennis@kernel.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: cgroups@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: kernel-team@fb.com

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
