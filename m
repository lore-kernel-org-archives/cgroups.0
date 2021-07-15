From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: charge semaphores and sem_undo objects
Date: Thu, 15 Jul 2021 11:22:05 -0700
Message-ID: <CALvZod7sGcOASaFi6st40DSsXh1a0mv7HQ7Vc1pXxnsDgmDPkg@mail.gmail.com>
References: <1626333284-1404-1-git-send-email-nglaive@gmail.com> <YPB1EPaunr5587h5@casper.infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F1H/bWMbBZ+Edpc8fYBwimkAh3hVifPS5VIkP0ejhXM=;
        b=kKak+JOk+MJfDv2F7RXrt3mwVvzMfe5u5QF+FTa8kVNr/0kDzmQ8K59PTs+ihYjGud
         GDgPuLMACsaJ8lKeAOD9jHahyL0gpPaGg8FZFtKsZCcvrTJDM7y9IYAeXg8uXz4RqzAg
         fWVCp0S3F6cF6U9aiOg8XjrZfCj2Kgp66z97hyfV2lVckGC/v/lWSMbeAcjOvlKwJWJj
         g0SkA7O5ZXZKpK/+SO8D5K+O3xaY76PDvKDvz4fbbvs/KEJm7d8/e8ynAKsn8hnxhEap
         aClCZ7jLFilMZI3GCplmR/1UTxs7hptszBd3Y293WXpajuNS89Wt1AYCm6JLt/scl3HX
         8IOA==
In-Reply-To: <YPB1EPaunr5587h5-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Yutian Yang <nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, shenwenbo-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org

On Thu, Jul 15, 2021 at 10:50 AM Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>
> On Thu, Jul 15, 2021 at 03:14:44AM -0400, Yutian Yang wrote:
> > This patch adds accounting flags to semaphores and sem_undo allocation
> > sites so that kernel could correctly charge these objects.
> >
> > A malicious user could take up more than 63GB unaccounted memory under
> > default sysctl settings by exploiting the unaccounted objects. She could
> > allocate up to 32,000 unaccounted semaphore sets with up to 32,000
> > unaccounted semaphore objects in each set. She could further allocate one
> > sem_undo unaccounted object for each semaphore set.
>
> Do we really have to account every object that's allocated on behalf of
> userspace?  ie how seriously do we take this kind of thing?  Are memcgs
> supposed to be a hard limit, or are they just a rough accounting thing?

The memcgs are used for providing isolation between different
workloads running on the system and not just rough accounting
estimation. So, if there is an unbound allocation which can be
triggered by userspace than it should be accounted.

>
> There could be a very large stream of patches turning GFP_KERNEL into
> GFP_KERNEL_ACCOUNT.  For example, file locks (fs/locks.c) are only
> allocated with GFP_KERNEL and you can allocate one lock per byte of a
> file.  I'm sure there are hundreds more places where we do similar things.

We used to do opt-out kmem memcg accounting but switched to opt-in
with a9bb7e620efdf ("memcg: only account kmem allocations marked as
__GFP_ACCOUNT") with the reason that number of allocations which
should not be charged are larger than the allocations which should be
charged.

Personally I would prefer we go back to the opt-out accounting
specially after we have switched to reparenting the kmem charges and
shared kmem caches.
