From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 03/18] mm: memcontrol: drop @compound parameter from memcg
 charging API
Date: Wed, 22 Apr 2020 10:30:59 -0700
Message-ID: <CALvZod6433GCgVwV7=h5zoByKj7ANoox9FyB6m1_k63KJJnyMQ@mail.gmail.com>
References: <20200420221126.341272-1-hannes@cmpxchg.org> <20200420221126.341272-4-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CH/4JiFaVWzo5ZXlfDSZ+F9xWKfQK8/az3nRBT+3Ob0=;
        b=sy64pUBYeS1VuzngKnQzfqPdwoQ9xR/N3Sz+eeFgQarNRaojQFOFsGacyr3y3vkVyI
         scgMTxXkb4gRjeInhr4AoiaQ9IKFiOOktM5Ygev+YIjwJ9Mg0bxO456FvwhLwmBVMLRK
         YWJNZpAgZ0rSUjnJ5dyQB86w/4zGV4Qo5s9Jl3M0eN499tDFwZJ2boUBSkDqVLkFNwfs
         TY/yBVN42t19Bl6nsw+Q1t+McQDsP/TYTmM2DyppBmJOmkuLDEp+B3KDY1HrMTtQKpjA
         ugfESwMkPOqWW3PK4mKx4D8Z3PvoRRIq1M0yGb1+RvD/WPnPy27gy+n4+Cahdj5uU09N
         PY/Q==
In-Reply-To: <20200420221126.341272-4-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

On Mon, Apr 20, 2020 at 3:11 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> The memcg charging API carries a boolean @compound parameter that
> tells whether the page we're dealing with is a hugepage.
> mem_cgroup_commit_charge() has another boolean @lrucare that indicates
> whether the page needs LRU locking or not while charging. The majority
> of callsites know those parameters at compile time, which results in a
> lot of naked "false, false" argument lists. This makes for cryptic
> code and is a breeding ground for subtle mistakes.
>
> Thankfully, the huge page state can be inferred from the page itself
> and doesn't need to be passed along. This is safe because charging
> completes before the page is published and somebody may split it.
>
> Simplify the callsites by removing @compound, and let memcg infer the
> state by using hpage_nr_pages() unconditionally. That function does
> PageTransHuge() to identify huge pages, which also helpfully asserts
> that nobody passes in tail pages by accident.
>
> The following patches will introduce a new charging API, best not to
> carry over unnecessary weight.
>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
