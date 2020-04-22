From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 02/18] mm: memcontrol: fix theoretical race in charge moving
Date: Wed, 22 Apr 2020 11:02:22 -0700
Message-ID: <CALvZod5XC+v_ThY=QyiXu9uWgkuc6x63jwUjW9mdWueoPh3LBw@mail.gmail.com>
References: <20200420221126.341272-1-hannes@cmpxchg.org> <20200420221126.341272-3-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OxPQfRGdb/9tZKOeYvx9nsO533AAnUsM72YkEAHTBCI=;
        b=MtBnqEYdd89iXzsWZUzdrGnwyjo111BKIiu7L3ZHWXsQEJMUCoEyKDRbJIyIbEZ0UL
         DV3+yaBUmM6gMxXui+ZOIe6OyD7VtRJ23975UXk+/Wj0COST+PbV9MJTROveWW0bw2T7
         GtXFKn4EezlfKVlwrZaFUmoy/J+Vyg0tVlz69s+eov79IvvYBC6QTV2+OAVc8P/TxcAB
         A8+D4KWyIqFJwYB36BbmoTeDFQv2oa4PzTVNJUV6suxSZPhHbZMiB3N4XCK8SMiAZedT
         H6oGGCppXSeyYI9Pa+3Rc/6Drhivl0uuWfd0hsHATauPrPn70QbuvXx3LUDAOw5klFM8
         xeuw==
In-Reply-To: <20200420221126.341272-3-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <js1304@gmail.com>, Alex Shi <alex.shi@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Roman Gushchin <guro@fb.com>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <kernel-team@fb.com>

On Mon, Apr 20, 2020 at 3:11 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> The move_lock is a per-memcg lock, but the VM accounting code that
> needs to acquire it comes from the page and follows page->mem_cgroup
> under RCU protection. That means that the page becomes unlocked not
> when we drop the move_lock, but when we update page->mem_cgroup. And
> that assignment doesn't imply any memory ordering. If that pointer
> write gets reordered against the reads of the page state -
> page_mapped, PageDirty etc. the state may change while we rely on it
> being stable and we can end up corrupting the counters.
>
> Place an SMP memory barrier to make sure we're done with all page
> state by the time the new page->mem_cgroup becomes visible.
>
> Also replace the open-coded move_lock with a lock_page_memcg() to make
> it more obvious what we're serializing against.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
