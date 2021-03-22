From: Arjun Roy <arjunroy@google.com>
Subject: Re: [mm, net-next v2] mm: net: memcg accounting for TCP rx zerocopy
Date: Mon, 22 Mar 2021 14:19:08 -0700
Message-ID: <CAOFY-A232pad5Xm0Cxx3P4oGLrSa+7=5ys8WB+LOPduz7YYfVA@mail.gmail.com>
References: <20210316013003.25271-1-arjunroy.kdev@gmail.com> <20210317202123.7d2eaa0e54c36c20571a335c@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gyGz6jIAyesHb03GrLq2sQ8gNXK0GEF8U0hfkl4YQos=;
        b=WFU7Cd+KSjhmC3zYLefyH/pznYkILEn4gUYD7fgJdX15GrVZXGIjvctmLzMcUMehix
         DBe1X1g3cy/+Fh385KsKSImJA5ngvSqHLfHMA2T/6M2Vzm0ArF8tP3xMXk2oKzX9jfCl
         /eFW9cpATHI9XDuToVZyvmbnwaxiZJE2ZKS6JAw1kodd+wtBYwgc1/INQS7ISYzJ2lrA
         Dtyq6CFbKILtk389p0xzfizKYo9bBAoYISMoZZmM22cKcI3MpJgHYdEhXvpscEVor9kl
         cdao8Wx9Ba+End5w8sZotV3yefDZwsz6ZyKzGmtgPONmz3bCJRLPfX9axapxptljnzDF
         ogTQ==
In-Reply-To: <20210317202123.7d2eaa0e54c36c20571a335c@linux-foundation.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjun Roy <arjunroy.kdev@gmail.com>, David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Shakeel Butt <shakeelb@google.com>, Eric Dumazet <edumazet@google.com>, Soheil Hassas Yeganeh <soheil@google.com>, Jakub Kicinski <kuba@kernel.org>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Yang Shi <shy828301@gmail.com>, Roman Gushchin <guro@fb.com>

On Wed, Mar 17, 2021 at 8:21 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Mon, 15 Mar 2021 18:30:03 -0700 Arjun Roy <arjunroy.kdev@gmail.com> wrote:
>
> > From: Arjun Roy <arjunroy@google.com>
> >
> > TCP zerocopy receive is used by high performance network applications
> > to further scale. For RX zerocopy, the memory containing the network
> > data filled by the network driver is directly mapped into the address
> > space of high performance applications. To keep the TLB cost low,
> > these applications unmap the network memory in big batches. So, this
> > memory can remain mapped for long time. This can cause a memory
> > isolation issue as this memory becomes unaccounted after getting
> > mapped into the application address space. This patch adds the memcg
> > accounting for such memory.
> >
> > Accounting the network memory comes with its own unique challenges.
> > The high performance NIC drivers use page pooling to reuse the pages
> > to eliminate/reduce expensive setup steps like IOMMU. These drivers
> > keep an extra reference on the pages and thus we can not depend on the
> > page reference for the uncharging. The page in the pool may keep a
> > memcg pinned for arbitrary long time or may get used by other memcg.
> >
> > This patch decouples the uncharging of the page from the refcnt and
> > associates it with the map count i.e. the page gets uncharged when the
> > last address space unmaps it. Now the question is, what if the driver
> > drops its reference while the page is still mapped? That is fine as
> > the address space also holds a reference to the page i.e. the
> > reference count can not drop to zero before the map count.
>
> What tree were you hoping to get this merged through?  I'd suggest net
> - it's more likely to get tested over there.
>

That was one part I wasn't quite sure about - the v3 patchset makes
things less clear even, since while v1/v2 are mostly mm heavy v3 would
have some significant changes in both subsystems.

I'm open to whichever is the "right" way to go, but am not currently
certain which would be.

Thanks,
-Arjun

> >
> > ...
> >
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
>
> These changes could be inside #ifdef CONFIG_NET.  Although I expect
> MEMCG=y&&NET=n is pretty damn rare.
>
