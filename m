From: Arjun Roy <arjunroy@google.com>
Subject: Re: [mm, net-next v2] mm: net: memcg accounting for TCP rx zerocopy
Date: Mon, 15 Mar 2021 23:22:27 -0700
Message-ID: <CAOFY-A0v2BEwRinhPXspjL_3dvyw2kDSyzQgUiJxc+P-3OLP8g@mail.gmail.com>
References: <20210316041645.144249-1-arjunroy.kdev@gmail.com>
 <CAOFY-A1L8c626HZYSWm6ZKFO9mqBdBszv6obX4-1_LmDBQ6Z4A@mail.gmail.com> <CALvZod7hgtdrN_KXD_5JdB2vzJzTc8tVz_5YFN53-xZjpHLLRw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xHVFZ6ek9UWH6gJaYSFsmDxhb9ekTRVKDZq6Jazc5rQ=;
        b=pnrONYLdoVlRUvqukdeM+bXd8Ij3mjhE5t0V3KUkfpk/yrSbJMiTCr/S7UD0odUa02
         dWaR7hogUC6ysiqCkMkPEk2Rm3IVlquKQdHRqaOjcwbaGU5bYrQgZbR/QG+VhgyITwf6
         e/ragJyDp+NpS773hJSNltE3XoRaFmfNc8Iq8U25yWlB4aNnetpoVFz4yl7ETuoMnP83
         2M+UYJc9wZw4k2VjBiPyaeFI/Y9/7t/nEJhE31nhE3tiAMGH/f/B+TGq6ZdxRnsfEJnc
         y46UwmnnQfOkJuGmkcKJv5m/gRbBj8RETOssa7aTxyXocQ25FcQhbN+O8uXfxhn888eb
         XcQQ==
In-Reply-To: <CALvZod7hgtdrN_KXD_5JdB2vzJzTc8tVz_5YFN53-xZjpHLLRw@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Arjun Roy <arjunroy.kdev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Eric Dumazet <edumazet@google.com>, Soheil Hassas Yeganeh <soheil@google.com>, Jakub Kicinski <kuba@kernel.org>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Yang Shi <shy828301@gmail.com>, Roman Gushchin <guro@fb.com>

On Mon, Mar 15, 2021 at 9:29 PM Shakeel Butt <shakeelb@google.com> wrote:
>
> On Mon, Mar 15, 2021 at 9:20 PM Arjun Roy <arjunroy@google.com> wrote:
> >
> [...]
> > >
> >
> > Apologies for the spam - looks like I forgot to rebase the first time
> > I sent this out.
> >
> > Actually, on a related note, it's not 100% clear to me whether this
> > patch (which in its current form, applies to net-next) should instead
> > be based on the mm branch - but the most recent (clean) checkout of mm
> > fails to build for me so net-next for now.
> >
>
> It is due to "mm: page-writeback: simplify memcg handling in
> test_clear_page_writeback()" patch in the mm tree. You would need to
> reintroduce the lock_page_memcg() which returns the memcg and make
> __unlock_page_memcg() non-static.

To clarify, Shakeel - the tag "tag: v5.12-rc2-mmots-2021-03-11-21-49"
fails to build on a clean checkout, without this patch, due to a
compilation failure in mm/shmem.c, for reference:
https://pastebin.com/raw/12eSGdGD
(and that's why I'm basing this patch off of net-next in this email).

-Arjun
