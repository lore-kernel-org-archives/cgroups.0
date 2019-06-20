From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] slub: Don't panic for memcg kmem cache creation failure
Date: Thu, 20 Jun 2019 07:44:27 -0700
Message-ID: <CALvZod4Fd5X91CzDLaVAvspQL-zoD7+9OGTiOro-hiMda=DqBA@mail.gmail.com>
References: <20190619232514.58994-1-shakeelb@google.com> <20190620055028.GA12083@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hkFAHTitPkfoSMrSNRMsrnAtfZq9o+iv5woQgM2GCxU=;
        b=thXTMTeTx0xXiZ9u/a78f4w6z2h57qLbhWVkhGpc5uU4+H4pPEGPk9N0YCZIJUb/U4
         TnuCUQ66JQqC0RvWoZCgR5L5jwqo76zVzKpMp8pXzP0t0CQ13sojAuWtJV7WnzKSCT2L
         TWtmySeyPfLwUziR7l0nrBHtk8fljJ+2ySjxfL+NG8AENzVWfMDj+iozng9mw4Awlsxa
         skqETBHwe+amhnj7vzDXN7JX46bW7xj9yy4+eq7BrRCQxowABoE0AiBdKbjHH05Jx41W
         5BmmPDMNbpX33eiLB6cDqnj9kFawoUkLCrF0p8UIYzkm0l8IfyFnL90oSO42R54TvW4k
         dHxA==
In-Reply-To: <20190620055028.GA12083@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>

On Wed, Jun 19, 2019 at 10:50 PM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Wed 19-06-19 16:25:14, Shakeel Butt wrote:
> > Currently for CONFIG_SLUB, if a memcg kmem cache creation is failed and
> > the corresponding root kmem cache has SLAB_PANIC flag, the kernel will
> > be crashed. This is unnecessary as the kernel can handle the creation
> > failures of memcg kmem caches.
>
> AFAICS it will handle those by simply not accounting those objects
> right?
>

The memcg kmem cache creation is async. The allocation has already
been decided not to be accounted on creation trigger. If memcg kmem
cache creation is failed, it will fail silently and the next
allocation will trigger the creation process again.

> > Additionally CONFIG_SLAB does not
> > implement this behavior. So, to keep the behavior consistent between
> > SLAB and SLUB, removing the panic for memcg kmem cache creation
> > failures. The root kmem cache creation failure for SLAB_PANIC correctly
> > panics for both SLAB and SLUB.
>
> I do agree that panicing is really dubious especially because it opens
> doors to shut the system down from a restricted environment. So the
> patch makes sesne to me.
>
> I am wondering whether SLAB_PANIC makes sense in general though. Why is
> it any different from any other essential early allocations? We tend to
> not care about allocation failures for those on bases that the system
> must be in a broken state to fail that early already. Do you think it is
> time to remove SLAB_PANIC altogether?
>

That would need some investigation into the history of SLAB_PANIC. I
will look into it.

> > Reported-by: Dave Hansen <dave.hansen@intel.com>
> > Signed-off-by: Shakeel Butt <shakeelb@google.com>
>
> Acked-by: Michal Hocko <mhocko@suse.com>

Thanks.
