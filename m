From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] mm/memcontrol.c: fix another unused function warning
Date: Tue, 1 Oct 2019 09:36:24 -0700
Message-ID: <CAKwvOdn7J6bvF=58UkeXA8LVAMt-g76EDFT+j5EWc0LdsyX_CQ@mail.gmail.com>
References: <20191001142227.1227176-1-arnd@arndb.de>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AHMFw+xpbq6Flta24J2hzTDxt/C/G/wkt9n5+ff6Syg=;
        b=R3PPoTfkYjm55Usvkap+EtoXUf5HVNBlhI8mau+Mc5cS3RRZ3i3i4xcKmMlhslCnRk
         wKr/l+Q5TujIFf7DvN0yU8XV25ZAntQ5u07Ioac5iArFq2covqObD/FHRplQDhtCKzaz
         I369JfzpF9rzCwNJokHteHQFva3hWd+aSj941pR+DBaK676oi3sZCTTOrOFW2HDm2D3T
         iWIg1YBr/Ero51hEPo9rNXn1VhlMIfpVB5WVaHWXD0eAAwTkseCUOaoGpjnEckwIQIwE
         XE9q4CoZnGeeF8k5aEwyfwP6nS9x5VSJTFl6U+9Vagz+qqtlvojsx2qKaa0jZCiD35pG
         o77A==
In-Reply-To: <20191001142227.1227176-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arnd Bergmann <arnd@arndb.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Qian Cai <cai@lca.pw>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, clang-built-linux <clang-built-linux@googlegroups.com>

On Tue, Oct 1, 2019 at 7:22 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
> Removing the mem_cgroup_id_get() stub function introduced a new warning
> of the same kind when CONFIG_MMU is disabled:
>
> mm/memcontrol.c:4929:13: error: unused function 'mem_cgroup_id_get_many' [-Werror,-Wunused-function]
>
> Address this using a __maybe_unused annotation.
>
> Note: alternatively, this could be moved into an #ifdef block.  Marking it

Hi Arnd,
Thank you for the patch!  I would prefer to move the definition to the
correct set of #ifdef guards rather than __maybe_unused.  Maybe move
the definition of mem_cgroup_id_get_many() to just before
__mem_cgroup_clear_mc()?  I find __maybe_unused to be a code smell.

> 'static inline' would not work here as that would still produce the
> warning on clang, which only ignores unused inline functions declared
> in header files instead of .c files.
>
> Fixes: 4d0e3230a56a ("mm/memcontrol.c: fix a -Wunused-function warning")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  mm/memcontrol.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c313c49074ca..5f9f90e3cef8 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4921,7 +4921,8 @@ static void mem_cgroup_id_remove(struct mem_cgroup *memcg)
>         }
>  }
>
> -static void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n)
> +static void __maybe_unused
> +mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n)
>  {
>         refcount_add(n, &memcg->id.ref);
>  }
> --

-- 
Thanks,
~Nick Desaulniers
