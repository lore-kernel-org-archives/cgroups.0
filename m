From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 3 May 2023 08:09:28 -0700
Message-ID: <CAJuCfpHxbYFxDENYFfnggh1D8ot4s493PQX0C7kD-JLvixC-Vg@mail.gmail.com>
References: <20230501165450.15352-1-surenb@google.com> <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-modules-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683126580; x=1685718580;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=njkpY9V26txLi7xPErO/sERUlWcV1pHNyq5uOqiF2eY=;
        b=VExKdzK5WEHsMwlEvyXIbTAR60TSGl0weEuYF33kbqADYhPEKMB5BFVn748WX7nHdJ
         1ZlyCGGXJGu0YiWNCyZl5XyfyFi2tpLKda0+fB339jPRw/X0v46Au/FFd5+OD8pJxpRY
         +KkUzelDcKShio3avgpuSPMVkLeLPhlOjJQMnrVxm4Zf0u/pZ6cnJgNCbvz6qY3fWGrt
         1Vm4vafoXe+OM0WR4hPTdkalQ5gy1bMCwNEAd6xNhQ1f8Ie8DIosbbc/QS5C38of78Fb
         mqBoNYXzOBoZSmrx1Vo6JKftamzpTKOZAz7AVyV44cWc+5yFoj7tdjzyxk27OuKklV1Q
         3kgg==
In-Reply-To: <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, keescook@chr

On Wed, May 3, 2023 at 12:25=E2=80=AFAM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrot=
e:
>
> On Mon 01-05-23 09:54:10, Suren Baghdasaryan wrote:
> > Memory allocation profiling infrastructure provides a low overhead
> > mechanism to make all kernel allocations in the system visible. It can =
be
> > used to monitor memory usage, track memory hotspots, detect memory leak=
s,
> > identify memory regressions.
> >
> > To keep the overhead to the minimum, we record only allocation sizes fo=
r
> > every allocation in the codebase. With that information, if users are
> > interested in more detailed context for a specific allocation, they can
> > enable in-depth context tracking, which includes capturing the pid, tgi=
d,
> > task name, allocation size, timestamp and call stack for every allocati=
on
> > at the specified code location.
> [...]
> > Implementation utilizes a more generic concept of code tagging, introdu=
ced
> > as part of this patchset. Code tag is a structure identifying a specifi=
c
> > location in the source code which is generated at compile time and can =
be
> > embedded in an application-specific structure. A number of applications
> > for code tagging have been presented in the original RFC [1].
> > Code tagging uses the old trick of "define a special elf section for
> > objects of a given type so that we can iterate over them at runtime" an=
d
> > creates a proper library for it.
> >
> > To profile memory allocations, we instrument page, slab and percpu
> > allocators to record total memory allocated in the associated code tag =
at
> > every allocation in the codebase. Every time an allocation is performed=
 by
> > an instrumented allocator, the code tag at that location increments its
> > counter by allocation size. Every time the memory is freed the counter =
is
> > decremented. To decrement the counter upon freeing, allocated object ne=
eds
> > a reference to its code tag. Page allocators use page_ext to record thi=
s
> > reference while slab allocators use memcg_data (renamed into more gener=
ic
> > slabobj_ext) of the slab page.
> [...]
> > [1] https://lore.kernel.org/all/20220830214919.53220-1-surenb-hpIqsD4AKldhl2p70BpVqQ@public.gmane.org=
m/
> [...]
> >  70 files changed, 2765 insertions(+), 554 deletions(-)
>
> Sorry for cutting the cover considerably but I believe I have quoted the
> most important/interesting parts here. The approach is not fundamentally
> different from the previous version [1] and there was a significant
> discussion around this approach. The cover letter doesn't summarize nor
> deal with concerns expressed previous AFAICS. So let me bring those up
> back.

Thanks for summarizing!

> At least those I find the most important:
> - This is a big change and it adds a significant maintenance burden
>   because each allocation entry point needs to be handled specifically.
>   The cost will grow with the intended coverage especially there when
>   allocation is hidden in a library code.

Do you mean with more allocations in the codebase more codetags will
be generated? Is that the concern? Or maybe as you commented in
another patch that context capturing feature does not limit how many
stacks will be captured?

> - It has been brought up that this is duplicating functionality already
>   available via existing tracing infrastructure. You should make it very
>   clear why that is not suitable for the job

I experimented with using tracing with _RET_IP_ to implement this
accounting. The major issue is the _RET_IP_ to codetag lookup runtime
overhead which is orders of magnitude higher than proposed code
tagging approach. With code tagging proposal, that link is resolved at
compile time. Since we want this mechanism deployed in production, we
want to keep the overhead to the absolute minimum.
You asked me before how much overhead would be tolerable and the
answer will always be "as small as possible". This is especially true
for slab allocators which are ridiculously fast and regressing them
would be very noticable (due to the frequent use).

There is another issue, which I think can be solved in a smart way but
will either affect performance or would require more memory. With the
tracing approach we don't know beforehand how many individual
allocation sites exist, so we have to allocate code tags (or similar
structures for counting) at runtime vs compile time. We can be smart
about it and allocate in batches or even preallocate more than we need
beforehand but, as I said, it will require some kind of compromise.

I understand that code tagging creates additional maintenance burdens
but I hope it also produces enough benefits that people will want
this. The cost is also hopefully amortized when additional
applications like the ones we presented in RFC [1] are built using the
same framework.

> - We already have page_owner infrastructure that provides allocation
>   tracking data. Why it cannot be used/extended?

1. The overhead.
2. Covers only page allocators.

I didn't think about extending the page_owner approach to slab
allocators but I suspect it would not be trivial. I don't see
attaching an owner to every slab object to be a scalable solution. The
overhead would again be of concern here.

I should point out that there was one important technical concern
about lack of a kill switch for this feature, which was an issue for
distributions that can't disable the CONFIG flag. In this series we
addressed that concern.

[1] https://lore.kernel.org/all/20220830214919.53220-1-surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/

Thanks,
Suren.

>
> Thanks!
> --
> Michal Hocko
> SUSE Labs
