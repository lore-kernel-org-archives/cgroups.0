From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] mm: fix unsafe page -> lruvec lookups with cgroup charge migration
Date: Thu, 21 Nov 2019 13:30:52 -0800
Message-ID: <CALvZod7FG+fTFE89j8E6-1RBG6st1Y9sSju-ModT9Rj6SzrVLw@mail.gmail.com>
References: <20191120165847.423540-1-hannes@cmpxchg.org> <alpine.LSU.2.11.1911201836220.1090@eggly.anvils>
 <20191121205631.GA487872@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4Ih+wdf+T8QIhxXa0Z/BjR6OEVlveBg+npb+LGLRLAs=;
        b=KQXl3u2SVxyMz8rlN77m7iXC4ogPKT54d6c96jwtR1V+9QP6TEJSfb7qFvrb+c8sYn
         K1HETXSPjLCE+ngl2e3oauOhqVrEPFPM/ZhnnrzVqESA+rClKn4LlMg7AyKV4Td5W2Ef
         xZ/qSXNCfrpe4jEh11iqbzoHAebuFk6JndluiFnmlqwAn8qHcNvAmBcFo4YjRec62s+I
         GRFgKzmVkO22wLfhbM8JasOVjj3eAkjRhG06EPVSfLHi7Oxy1zwpIe9LLOjMTDraMIfi
         5/lkMveIVEwgKvw90PoSaktKGc7LanP0P3AO+m//ciW9Hi25i5albVbdjQTMnkwoR8HF
         Truw==
In-Reply-To: <20191121205631.GA487872@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Alex Shi <alex.shi@linux.alibaba.com>, Roman Gushchin <guro@fb.com>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <kernel-team@fb.com>

On Thu, Nov 21, 2019 at 12:56 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Wed, Nov 20, 2019 at 07:15:27PM -0800, Hugh Dickins wrote:
> > It like the way you've rearranged isolate_lru_page() there, but I
> > don't think it amounts to more than a cleanup.  Very good thinking
> > about the odd "lruvec->pgdat = pgdat" case tucked away inside
> > mem_cgroup_page_lruvec(), but actually, what harm does it do, if
> > mem_cgroup_move_account() changes page->mem_cgroup concurrently?
> >
> > You say use-after-free, but we have spin_lock_irq here, and the
> > struct mem_cgroup (and its lruvecs) cannot be freed until an RCU
> > grace period expires, which we rely upon in many places, and which
> > cannot happen until after the spin_unlock_irq.
>
> You are correct, I missed the rcu locking implied by the
> spinlock. With this, the justification for this patch is wrong.
>
> But all of this is way too fragile and error-prone for my taste. We're
> looking up a page's lruvec in a scope that does not promise at all
> that the lruvec will be the page's. Luckily we currently don't touch
> the lruvec outside of the PageLRU branch, but this subtlety is
> entirely non-obvious from the code.
>
> I will put more thought into this. Let's scrap this patch for now.

What about the comment on mem_cgroup_page_lruvec()? I feel that
comment is a good documentation independent of the original patch.
