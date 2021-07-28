From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: cleanup racy sum avoidance code
Date: Wed, 28 Jul 2021 13:37:28 -0700
Message-ID: <CALvZod71oM0=B_u6-fSMFBqwP2tEOgxKxygHkcshmNF-BMCwzg@mail.gmail.com>
References: <20210728012243.3369123-1-shakeelb@google.com> <20210728124326.a3e6cc29f670062185fb57d7@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wx12YfrHsQsDKjajWfKvfKfUSFEaj6kJhNDgZWYmtmg=;
        b=QfaWHqJDwQHVJXicJ8h1hGeUi7F2r6xmPRzW3TM7SqTNre4aIPa6Oid+LKkUmQuoYa
         hTKe1i6Kl4llnheG7hQwB5FKG8Z7iuRdOHJSP1lv0JuVE48SfIWX3TrQ7CZB+qcY9euO
         0Am/d96xgQ5QGG5MqmHO0Ggigrsc8Jo4v1cbMYjQukQBEKrfoUFuOlqIKBcsZyy0jtHu
         V7C1SQlrm9QF0LsyHsUfSmw33Y0SFtDdetgdYK3NirXjWa4fugAUfJd1Ook09gFLezlr
         gEu8tGenY41P0LTNDUqaLyGdDpTmNV7ztpPkIPovOboJAotIRxcoKsf7Bc9CVfXL6RA1
         5LCA==
In-Reply-To: <20210728124326.a3e6cc29f670062185fb57d7-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Jul 28, 2021 at 12:43 PM Andrew Morton
<akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>
> On Tue, 27 Jul 2021 18:22:43 -0700 Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> > We used to have per-cpu memcg and lruvec stats and the readers have to
> > traverse and sum the stats from each cpu. This summing was racy and may
> > expose transient negative values. So, an explicit check was added to
> > avoid such scenarios. Now these stats are moved to rstat infrastructure
> > and are no more per-cpu, so we can remove the fixup for transient
> > negative values.
>
> We can't do anything about the same code in lruvec_page_state_local()?

lruvec_page_state_local() is used by cgroup v1's memory.numa_stat for
cgroup local stats (not hierarchical) and are still per-cpu. To make
it non-per-cpu, we have to add 'long
state_local[NR_VM_NODE_STAT_ITEMS]' in 'struct lruvec_stats' and do
aggregation in rstat flushing. So, paying the cpu traversal cost with
more memory usage. I am not sure if it is worth it.
