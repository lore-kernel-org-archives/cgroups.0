From: Qian Cai <cai-J5quhbR+WMc@public.gmane.org>
Subject: Re: [PATCH v2 4/4] mm/slub: Fix sysfs shrink circular locking dependency
Date: Sat, 16 May 2020 21:46:05 -0400
Message-ID: <62C1A69E-A14F-42EE-970F-ABAEA2782256@lca.pw>
References: <56327de0-fa44-d5f3-2409-69cf2b97a209@redhat.com>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=v8/1I95wcTj1mWlxsoep0Hvc73TKsH79uHMoZbzZUWA=;
        b=mTuyBRurXQZEK9utptTiC11aN2pRP5dmNcE3mS9JBiWGvq+XHi1IprBG0ma5RZ8d1B
         mq/y+wqaSGx+FRZ55wJjSWJknBkFCrIAqsYJSJG+IJNbVLUiZY0PjS65iNMYjH5poapJ
         ano66ITpWYc7rAQifzLH5VBHZaDrUFXLp87bcqJILV29+PDGdX7D8K7W9M26JKqOX6FC
         aQiPnMJf1SdeDID06QRXlqxWkRGX8BJvxwE8AUiQJvRghyyLv3dtN/xklxayHY2TAiOW
         QudmNWPFzxw7MllH6ftOp0wvqb3tMAV8Mda48M/0Wy7idJzc4TBrjXekP9QxEtS5uGvd
         wtyw==
In-Reply-To: <56327de0-fa44-d5f3-2409-69cf2b97a209-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>



> On Apr 28, 2020, at 10:07 AM, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>=20
> Trylock is handled differently from lockdep's perspective as trylock can f=
ailed. When trylock succeeds, the critical section is executed. As long as i=
t doesn't try to acquire another lock in the circular chain, the execution w=
ill finish at some point and release the lock. On the other hand, if another=
 task has already held all those locks, the trylock will fail and held locks=
 should be released. Again, no deadlock will happen.

Ok, I can see that in validate_chain() especially mentioned,

=E2=80=9CTrylock needs to maintain the stack of held locks, but it does not a=
dd new dependencies, because trylock can be done in any order.=E2=80=9D

So, I agree this trylock trick could really work. Especially, I don=E2=80=99=
t know any other better way to fix this.=
