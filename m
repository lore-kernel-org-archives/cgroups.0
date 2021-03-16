From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [mm, net-next v2] mm: net: memcg accounting for TCP rx zerocopy
Date: Mon, 15 Mar 2021 21:29:37 -0700
Message-ID: <CALvZod7hgtdrN_KXD_5JdB2vzJzTc8tVz_5YFN53-xZjpHLLRw@mail.gmail.com>
References: <20210316041645.144249-1-arjunroy.kdev@gmail.com> <CAOFY-A1L8c626HZYSWm6ZKFO9mqBdBszv6obX4-1_LmDBQ6Z4A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3zzhDPqLig+/Zw9qmQx4u8x639EaQw4NkATkHqrVPa8=;
        b=bqOgR2ygnLQuRVD06CKj/ojYEyQPqN2mj140AA8RMfI0Vgdf5feZXBlzco50UxnYGj
         oz1mRBKDJh6BIn7QDi3dOeOGXKxhOUjLq4SKwMp9V0URMK1qEOYem4FIqLZdCEMg1SDk
         PQgWTWfQV4jzFgG4cMKL7ZEZG+oAhhVNTQa0WavQ4F3TrE+0RyHHBT5muwCHpm48nrmA
         f6ICyig6uJWhZxGmiWjgvlu47UYKGrmaEhKj6U0po4wNfyw7HsjU41NBTO6pQarA//vj
         XHn4IU3dw2YBXpy8bBwpqbOWtB44DLNCQxpdSOtfW99iMMdFEAJUvYtZO75DwB9RwiTd
         8t8w==
In-Reply-To: <CAOFY-A1L8c626HZYSWm6ZKFO9mqBdBszv6obX4-1_LmDBQ6Z4A@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arjun Roy <arjunroy@google.com>
Cc: Arjun Roy <arjunroy.kdev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Eric Dumazet <edumazet@google.com>, Soheil Hassas Yeganeh <soheil@google.com>, Jakub Kicinski <kuba@kernel.org>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Yang Shi <shy828301@gmail.com>, Roman Gushchin <guro@fb.com>

On Mon, Mar 15, 2021 at 9:20 PM Arjun Roy <arjunroy@google.com> wrote:
>
[...]
> >
>
> Apologies for the spam - looks like I forgot to rebase the first time
> I sent this out.
>
> Actually, on a related note, it's not 100% clear to me whether this
> patch (which in its current form, applies to net-next) should instead
> be based on the mm branch - but the most recent (clean) checkout of mm
> fails to build for me so net-next for now.
>

It is due to "mm: page-writeback: simplify memcg handling in
test_clear_page_writeback()" patch in the mm tree. You would need to
reintroduce the lock_page_memcg() which returns the memcg and make
__unlock_page_memcg() non-static.
