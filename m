From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2] mm, memcg: introduce memory.events.local
Date: Fri, 17 May 2019 18:19:19 -0700
Message-ID: <CALvZod4cOWrzGzJncCzaPqBbnmavbkrbTZnwY6r1V5eFVwOJAQ@mail.gmail.com>
References: <20190518001818.193336-1-shakeelb@google.com> <20190518005927.GB3431@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7Ho8cHrK4qMqiN3LtaRzVtq4HS5hpwx3f8cFy/TZJ4Y=;
        b=Aa2aThr8oZpP0WVahD8NCNtshzOd5qsE6LqKaPa6VLI3iYk06oUL4BlBH5BA18zwU4
         Gq3Rt3R6ehByjfoq9VBjVL/B24UpZw5SethE0DegFvSksoigMBv9jPJcnkpsG7vVKnei
         7eB9NigP6sVXiyh6W3xmHGF2LtlTntNh8IWQG1gltDpbv/Vnqwt/dDkSv32UQ+Zyvmuj
         7W64PTuAiZN+TtH90+krk10ZQRyYxIinqRqWZJElqdKAXDdwkbAtXLjE7EHAVHb0pNoh
         RHgbOyZnzTbbTsUszgg8DRq5iAKYSjwFf09KEFH7+p2jQNeUpkR8kOulHqKzRSL9pd69
         RqIw==
In-Reply-To: <20190518005927.GB3431@tower.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Chris Down <chris@chrisdown.name>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Fri, May 17, 2019 at 5:59 PM Roman Gushchin <guro@fb.com> wrote:
>
> On Fri, May 17, 2019 at 05:18:18PM -0700, Shakeel Butt wrote:
> > The memory controller in cgroup v2 exposes memory.events file for each
> > memcg which shows the number of times events like low, high, max, oom
> > and oom_kill have happened for the whole tree rooted at that memcg.
> > Users can also poll or register notification to monitor the changes in
> > that file. Any event at any level of the tree rooted at memcg will
> > notify all the listeners along the path till root_mem_cgroup. There are
> > existing users which depend on this behavior.
> >
> > However there are users which are only interested in the events
> > happening at a specific level of the memcg tree and not in the events in
> > the underlying tree rooted at that memcg. One such use-case is a
> > centralized resource monitor which can dynamically adjust the limits of
> > the jobs running on a system. The jobs can create their sub-hierarchy
> > for their own sub-tasks. The centralized monitor is only interested in
> > the events at the top level memcgs of the jobs as it can then act and
> > adjust the limits of the jobs. Using the current memory.events for such
> > centralized monitor is very inconvenient. The monitor will keep
> > receiving events which it is not interested and to find if the received
> > event is interesting, it has to read memory.event files of the next
> > level and compare it with the top level one. So, let's introduce
> > memory.events.local to the memcg which shows and notify for the events
> > at the memcg level.
> >
> > Now, does memory.stat and memory.pressure need their local versions.
> > IMHO no due to the no internal process contraint of the cgroup v2. The
> > memory.stat file of the top level memcg of a job shows the stats and
> > vmevents of the whole tree. The local stats or vmevents of the top level
> > memcg will only change if there is a process running in that memcg but
> > v2 does not allow that. Similarly for memory.pressure there will not be
> > any process in the internal nodes and thus no chance of local pressure.
> >
> > Signed-off-by: Shakeel Butt <shakeelb@google.com>
> > ---
> > Changelog since v1:
> > - refactor memory_events_show to share between events and events.local
>
> Reviewed-by: Roman Gushchin <guro@fb.com>
>
> You also need to add some stuff into cgroup v2 documentation.
>

Thanks, will update the doc in the next version.

Shakeel
