From: Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v2] cgroup: memcg: net: do not associate sock with
 unrelated cgroup
Date: Fri, 14 Feb 2020 15:12:28 -0800
Message-ID: <CANn89i+-GJgD4-YnF9yKhDvG48OK8XtM7oB9gw6njeb_ZbdpDw@mail.gmail.com>
References: <20200214222415.181467-1-shakeelb@google.com> <CANn89iLe7KVjaechEhtV4=QRy4s8qBQDiX9e8LX_xq8tunrQNA@mail.gmail.com>
 <CALvZod5RoE3V7HteKqqDEfCgY8pDok6PWHrpu8trB1vyuK2UHA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uatDFsIT20Tr7lDZflfez2EhiRhyLK/asm5Si1dIGu0=;
        b=bcDSHQvvV96yGTTBRaB8x59yqMJOXsrLkX+6lOtHFWjjtjj7KqevWTBgWaz/71B+nt
         gtS9q14yDtUdDOH39hmoZZW763p287iNzMsFru3GOmmYq2LdEXOM0aqi4ENgnMQ84ygt
         xwdNGRAZShNjNgD7GoS6tiTM96AanEO1yfwvXXAH4zVUES/ITWy18m+kROoI/RoWkb0w
         uNxeQC845/tLmKRHSNwkR196QibBSJSyrX+6ZtKqUzvsHAg7nR2Z7Z0oPrSjCqhsQWAq
         xIRpoWrtAfrDtxulQYPXvT8z5ND6nMHvA66yZe02wBC2VyD2zrBerpKVt7XOolE8e0Fl
         ccKw==
In-Reply-To: <CALvZod5RoE3V7HteKqqDEfCgY8pDok6PWHrpu8trB1vyuK2UHA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Greg Thelen <gthelen@google.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Cgroups <cgroups@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Roman Gushchin <guro@fb.com>, LKML <linux-kernel@vger.kernel.org>

On Fri, Feb 14, 2020 at 2:48 PM Shakeel Butt <shakeelb@google.com> wrote:

>
> I think in the current code if the association is skipped at
> allocation time then the sock will remain unassociated for its
> lifetime.
>
> Maybe we can add the association in the later stages but it seems like
> it is not a simple task i.e. edbe69ef2c90f ("Revert "defer call to
> mem_cgroup_sk_alloc()"").

Half TCP sockets are passive, so this means that 50% of TCP sockets
won't be charged.
(the socket cloning always happens from BH context)

I think this deserves a comment in the changelog or documentation,
otherwise some people might think
using memcg will make them safe.
