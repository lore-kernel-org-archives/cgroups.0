From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm, slab: Extend slab/shrink to shrink all the memcg
 caches
Date: Tue, 2 Jul 2019 14:33:40 -0700
Message-ID: <20190702143340.715f771192721f60de1699d7@linux-foundation.org>
References: <20190702183730.14461-1-longman@redhat.com>
        <20190702130318.39d187dc27dbdd9267788165@linux-foundation.org>
        <78879b79-1b8f-cdfd-d4fa-610afe5e5d48@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562103221;
        bh=7BKwrn5ZR0EvyKBoBdw71Sjqy+1SUbMyW6AzU7/ufH4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RBa6CBZoD/h1b3spSkXt/s5mk4/LF71sNM0q6jPS2dnne68logM7RJmnQeYqnoPlk
         We4S37hoCXN1vJ/SylpXLdidWn8wQovBsN3zWD/thJwRlA5V0kPWzkSRUxdgTRtCMR
         lCSW1e94ZmkPHXhQYrDUGU4rHNsLYjp0UCC4jn8o=
In-Reply-To: <78879b79-1b8f-cdfd-d4fa-610afe5e5d48@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Waiman Long <longman@redhat.com>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Andrea Arcangeli <aarcange@redhat.com>

On Tue, 2 Jul 2019 16:44:24 -0400 Waiman Long <longman@redhat.com> wrote:

> On 7/2/19 4:03 PM, Andrew Morton wrote:
> > On Tue,  2 Jul 2019 14:37:30 -0400 Waiman Long <longman@redhat.com> wro=
te:
> >
> >> Currently, a value of '1" is written to /sys/kernel/slab/<slab>/shrink
> >> file to shrink the slab by flushing all the per-cpu slabs and free
> >> slabs in partial lists. This applies only to the root caches, though.
> >>
> >> Extends this capability by shrinking all the child memcg caches and
> >> the root cache when a value of '2' is written to the shrink sysfs file.
> > Why?
> >
> > Please fully describe the value of the proposed feature to or users.=20
> > Always.
>=20
> Sure. Essentially, the sysfs shrink interface is not complete. It allows
> the root cache to be shrunk, but not any of the memcg caches.=A0

But that doesn't describe anything of value.  Who wants to use this,
and why?  How will it be used?  What are the use-cases?

