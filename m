From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [RFC PROPOSAL] memcg: per-memcg user space reclaim interface
Date: Fri, 3 Jul 2020 07:23:14 -0700
Message-ID: <CALvZod5gthVX5m6o50OiYsXa=0_NpXK-tVvjTF42Oj4udr4Nuw@mail.gmail.com>
References: <20200702152222.2630760-1-shakeelb@google.com> <20200703063548.GM18446@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xAsbhYpysmstHPq0Op9MjqJaZ7YDRLDrp7Rg8i0eT+Q=;
        b=KacU4DChX8owr3WxGngcQJG0ITHWxa2x5YJZMRcO1Oq8g8suqMxqCIKz2KIVn+GX0G
         NlL4sAx7SWLe7wOoKqalqC8WPtCsOVDiIJl2ugaBNTqIy8m+xXXNOoboIPQNY0hU4eh5
         Cv+CRClsFvZBzHLaY4R8w4zl6/ZmyudVjt3Ym/CNTRtKSCKgM5mCowbGng/unHeM1X6G
         rX9V5/vB5ZifMJFjN2LTDNr4RYI0VvFlBsKbHhDWHWGHEv13TdNi3C8BfxPrrTetX9vs
         vMD4jQOdARdwlqk8ECDSA4gMLt9sQnF8RfswofOxXeklF/ny6lafGO5LMCzz1KNSzmw1
         ZJUg==
In-Reply-To: <20200703063548.GM18446@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Yang Shi <yang.shi@linux.alibaba.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On Thu, Jul 2, 2020 at 11:35 PM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Thu 02-07-20 08:22:22, Shakeel Butt wrote:
> [...]
> > Interface options:
> > ------------------
> >
> > 1) memcg interface e.g. 'echo 10M > memory.reclaim'
> >
> > + simple
> > + can be extended to target specific type of memory (anon, file, kmem).
> > - most probably restricted to cgroup v2.
> >
> > 2) fadvise(PAGEOUT) on cgroup_dir_fd
> >
> > + more general and applicable to other FSes (actually we are using
> > something similar for tmpfs).
> > + can be extended in future to just age the LRUs instead of reclaim or
> > some new use cases.
>
> Could you explain why memory.high as an interface to trigger pro-active
> memory reclaim is not sufficient. Also memory.low limit to protect
> latency sensitve workloads?

Yes, we can use memory.high to trigger [proactive] reclaim in a memcg
but note that it can also introduce stalls in the application running
in that memcg. Let's suppose the memory.current of a memcg is 100MiB
and we want to reclaim 20MiB from it, we can set the memory.high to
80MiB but any allocation attempt from the application running in that
memcg can get stalled/throttled. I want the functionality of the
reclaim without potential stalls.

The memory.min is for protection against the global reclaim and is
unrelated to this discussion.
