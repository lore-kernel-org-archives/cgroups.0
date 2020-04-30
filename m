From: Yafang Shao <laoar.shao@gmail.com>
Subject: Re: [PATCH 1/2] mm, memcg: Avoid stale protection values when cgroup
 is above protection
Date: Thu, 30 Apr 2020 09:31:23 +0800
Message-ID: <CALOAHbCL_JJgcy9r99Kn81-o_t-fs_nQ+n7aKMHO-02QMCufEw@mail.gmail.com>
References: <cover.1588092152.git.chris@chrisdown.name> <d454fca5d6b38b74d8dc35141e8519b02089a698.1588092152.git.chris@chrisdown.name>
 <CALOAHbCotD1-+o_XZPU_4_i8Nn98r5F_5NpGVd=z6UG=rUcCmA@mail.gmail.com> <20200430011626.GA2754277@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0w8kJY9j/FEki6CAhMOKe13kIgQ0o8hCyo6pGzmOYdc=;
        b=MPwVE+Bkz9CcDJalk+jgqmR3yxPIKUJC9RYNqy7zduk8OZljggsMW54Iu0DIGQxaKG
         fdbwsrCCpogT+InOFKVy82EoAxMwVggL1RJOkUH2Q02y1wlfKbCrlNbt5CcaVv20Z+FL
         vtJXW1aC5Aw5Wz4IGBUkzIkcsn6XtJeWsA8S0Z8MAX9Zv5uI6T42mM0xogcGR76LyuCH
         2geNetHgdjA7o06cI3ZjVvsDPq/TlwcYzBJL9HfhiTot/9NI/D+pT2RhoTnJblRugKJo
         kqomD+/oVM6lCXM4NUSGp/oVrh5MHBenNP42ujYcZQF7JDZ/4qmFgrnvvnD4lCrrwxyd
         J1kQ==
In-Reply-To: <20200430011626.GA2754277@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <guro@fb.com>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Thu, Apr 30, 2020 at 9:16 AM Chris Down <chris@chrisdown.name> wrote:
>
> Hi Yafang,
>
> Yafang Shao writes:
> >Would you pls. add some comments above these newly added WRITE_ONCE() ?
> >E.g.
> >What does them mean to fix ?
> >Why do we must add WRITE_ONCE() and READ_ONCE here and there all over
> >the memcg protection ?
> >Otherwise, it may be harder to understand by the others.
>
> There is already discussion in the changelogs for previous store tear
> improvements. For example, b3a7822e5e75 ("mm, memcg: prevent
> mem_cgroup_protected store tearing").
>

I'm sorry that I missed the changelog in the other one.
So you'd better add these commit log or comment to this one again.

> WRITE_ONCE and READ_ONCE are standard compiler barriers, in this case, to avoid
> store tears from writes in another thread (effective protection caching is
> designed by its very nature to permit racing, but tearing is non-ideal).
>
> You can find out more about them in the "COMPILER BARRIER" section in
> Documentation/memory-barriers.txt. I'm not really seeing the value of adding an
> extra comment about this specific use of them, unless you have some more
> explicit concern.

My concern is why we add these barriers to memcg protection
specifically but don't add these barriers to the other memebers like
memcg->oom_group which has the same issue ?
What is the difference between these members and that members ?


-- 
Thanks
Yafang
