From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: remove lock_page_memcg() from rmap
Date: Wed, 30 Nov 2022 09:36:15 -0800 (PST)
Message-ID: <e0918c92-90cd-e3ed-f4e6-92d02062c252@google.com>
References: <20221123181838.1373440-1-hannes@cmpxchg.org> <16dd09c-bb6c-6058-2b3-7559b5aefe9@google.com> <Y4TpCJ+5uCvWE6co@cmpxchg.org> <Y4ZYsrXLBFDIxuoO@cmpxchg.org> <3659bbe0-ccf2-7feb-5465-b287593aa421@google.com>
 <CALvZod7_FjO-CjzHUpQTsCTm4-68a1eKi_qY=4XdF+g7yMLd4Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZAKs3FMJBtAtSZmpMRqAhPhuYj2WYHmeTXUWNI3mQVg=;
        b=fJBBa1j79Fa7M86oY1GqNIx2ObJfcN5mkJX50cLznX2i/Mlzs/UYvl4OW57QqMmhG0
         ONTAX680s68WxcDKVX0S8CMyE+l1doSN7smFea8TsuQD/LRKFwk3L8vFBsC/Xjnnru/V
         S+yUFYkIHXbOz90AAwQZbe7iuYN+6WIMprTOi0la2d5y64Ju30bZzim+TrVfUCuBWmnP
         yLN1wwz0ydAvWiKE9WeVvXhQzh6YlFCnQfkvEyQSeX24fUjBSs/h9qkY3kWLB0j9Myj9
         cjkqAvWDw/EyCgvdIhk8fgwjkPQe1F8swmEwAaTOGPyeul5eGkiHnoNereC82GlOkSqE
         rbJw==
In-Reply-To: <CALvZod7_FjO-CjzHUpQTsCTm4-68a1eKi_qY=4XdF+g7yMLd4Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 30 Nov 2022, Shakeel Butt wrote:
> 
> 2. For 6.2 (or 6.3), remove the non-present pte migration with some
> additional text in the warning and do the rmap cleanup.

I just had an idea for softening the impact of that change: a moment's
more thought may prove it's a terrible idea, but right now I like it.

What if we keep the non-present pte migration throughout the deprecation
period, but with a change to the where the folio_trylock() is done, and
a refusal to move the charge on the page of a non-present pte, if that
page/folio is currently mapped anywhere else - the folio lock preventing
it from then becoming mapped while in mem_cgroup_move_account().

There's an argument that that's a better implementation anyway: that
we should not interfere with others' pages; but perhaps it would turn
out to be unimplementable, or would make for less predictable behaviour.

Hugh
