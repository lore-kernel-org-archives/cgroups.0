From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] mm: memcontrol: switch to rstat fix
Date: Mon, 15 Mar 2021 16:58:49 -0700
Message-ID: <CALvZod7VzxYc4Kz0WPHWt74YMopi9XrCu4CKtEGTRKxXPSP=8w@mail.gmail.com>
References: <20210315234100.64307-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GiWLaJ6JfRY7D2fjAEheSS/CI6En0Tfjr7NfpaLRaUg=;
        b=el1U4yM7KpXL5g8A1suug3kzC4jqMxihYzAe6idzQvWFnWS91NbuSI/u+c6mo6cRnV
         SPei+MME4J69H5g9v4345POnj6DndSypgXQdfUHFQYb7eJNzCDNSvw/2JxkV/MfzWtOC
         kf4IBHDbVcqItf9trvNPu1tywIQIXWuoKwXmyEvHMidR1r5dkG0r+DYt+noifqymr/al
         NOpBuSOhXUfkxXzujUrmtj6SfPf704YxzLSaRzU5iJInw3d/wh8k5iOLjeOO/M+5KmEi
         LJh2OEaMvZRv9JdvA6or3g3XBQ1bnr8Uu6YnH5VpChJ/5QuJgx7O/g/j1G2ONUuw4djx
         N5OQ==
In-Reply-To: <20210315234100.64307-1-hannes@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Roman Gushchin <guro@fb.com>, Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <kernel-team@fb.com>

On Mon, Mar 15, 2021 at 4:41 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> Fix a sleep in atomic section problem: wb_writeback() takes a spinlock
> and calls wb_over_bg_thresh() -> mem_cgroup_wb_stats, but the regular
> rstat flushing function called from in there does lockbreaking and may
> sleep. Switch to the atomic variant, cgroup_rstat_irqsafe().
>
> To be consistent with other memcg flush calls, but without adding
> another memcg wrapper, inline and drop memcg_flush_vmstats() instead.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
