From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [RFC PATCH] mm: memcontrol: memory+swap accounting for cgroup-v2
Date: Wed, 20 Dec 2017 17:15:41 -0800
Message-ID: <CALvZod7eQWrD6LgbUrOvuhf5A1KKxBaK5t-U61gdFqvMeWXuzQ@mail.gmail.com>
References: <20171219124908.GS2787@dhcp22.suse.cz> <CALvZod5jU9vPoJaf44TVT0_HQpEESiELJU5MD_DDRbcOkPNQbg@mail.gmail.com>
 <20171219152444.GP3919388@devbig577.frc2.facebook.com> <CALvZod5sWWBX69QovOeLBSx9vij7=5cmoSocdTUvh2Uq8=noyQ@mail.gmail.com>
 <20171219173354.GQ3919388@devbig577.frc2.facebook.com> <CALvZod7pbp0fFUPRnC68qdzkCEUg2YTavq6C6OLxqooCU5VeyQ@mail.gmail.com>
 <20171219214107.GR3919388@devbig577.frc2.facebook.com> <CALvZod5XRhXc3XrQw50Jw_OpRQB2iCCbgG-NMDCa8xRmGNdLrw@mail.gmail.com>
 <20171220193741.GD3413940@devbig577.frc2.facebook.com> <CALvZod7Z1Yh+ZhU8qxzSiN0Pph2R7O4Mki5E23FbJFAzhyCH8g@mail.gmail.com>
 <20171220233658.GB1084507@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=qnnMsUKpojyJ7Y7gqFQUw3+htLWuG3rf6dp9ESemtLU=;
        b=b4viq7UuvvemnxoLtb5Fg+yzNAB+5oxFkkKBFDIgTe9yFkT1nd/BB/UI931RqcOzm8
         T4BLNfFS5Dzhhl7zuwR0aNjLpz2l1Y6phI2zg0akJzvmXrfF9C624ssFguPj8liF9ypl
         HRNZCwCg7s//sn5u/bAOzrkKb3YwdtV7A0PtUxqWCsfikLx/Y2llnRQTA1MhGZJgU83R
         +ns9/6pgrGc6Kyvfm/rlklxIjWjymB2beCZ+yGSeucxepgPp7R5OD0+Pf8Yi1eyDCcbC
         x6N7eDtznGxXGgk6jHKTXlKB4lxgPjQhaBRs/53BxCoKN/z2OpIf+3NmvAJKW1g3VcQT
         TlSw==
In-Reply-To: <20171220233658.GB1084507@devbig577.frc2.facebook.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>, Li Zefan <lizefan@huawei.com>, Roman Gushchin <guro@fb.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org

On Wed, Dec 20, 2017 at 3:36 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Shakeel.
>
> On Wed, Dec 20, 2017 at 12:15:46PM -0800, Shakeel Butt wrote:
>> > I don't understand how this invariant is useful across different
>> > backing swap devices and availability.  e.g. Our OOM decisions are
>> > currently not great in that the kernel can easily thrash for a very
>> > long time without making actual progresses.  If you combine that with
>> > widely varying types and availability of swaps,
>>
>> The kernel never swaps out on hitting memsw limit. So, the varying
>> types and availability of swaps becomes invariant to the memcg OOM
>> behavior of the job.
>
> The kernel doesn't swap because of memsw because that wouldn't change
> the memsw number; however, that has nothing to do with whether the
> underlying swap device affects OOM behavior or not.  That invariant
> can't prevent memcg decisions from being affected by the performance
> of the underlying swap device.  How could it possibly achieve that?
>

I feel like you are confusing between global OOM and memcg OOM. Under
memsw, the memcg OOM behavior will not be affected by the underlying
swap device. See my example below.

> The only reason memsw was designed the way it was designed was to
> avoid lower swap limit meaning more memory consumption.  It is true
> that swap and memory consumptions are interlinked; however, so are
> memory and io, and we can't solve these issues by interlinking
> separate resources in a single resource knob and that's why they're
> separate in cgroup2.
>
>> > Sure, but what does memswap achieve?
>>
>> 1. memswap provides consistent memcg OOM killer and memcg memory
>> reclaim behavior independent to swap.
>> 2. With memswap, the job owners do not have to think or worry about swaps.
>
> To me, you sound massively confused on what memsw can do.  It could be
> that I'm just not understanding what you're saying.  So, let's try
> this one more time.  Can you please give one concrete example of memsw
> achieving critical capabilities that aren't possible without it?
>

Let's say we have a job that allocates 100 MiB memory and suppose 80
MiB is anon and 20 MiB is non-anon (file & kmem).

[With memsw] Scheduler sets the memsw limit of the job to 100 MiB and
memory to max. Now suppose the job tries to allocates memory more than
100 MiB, it will hit the memsw limit and will try to reclaim non-anon
memory. The memcg OOM behavior will only depend on the reclaim of
non-anon memory and will be independent of the underlying swap device.

[Without memsw] Scheduler sets the memory limit to 100 MiB and swap to
50 MiB (based on availability). Now when the job tries to allocate
memory more than 100 MiB, it will hit memory limit and try to reclaim
anon and non-anon memory. The kernel will try to swapout anon memory,
write out dirty file pages, free clean file pages and shrink
reclaimable kernel memory. Here the memcg OOM behavior will depend on
the underlying swap device.

Without memsw, the underlying swap device will always affect the memcg
OOM and memcg reclaim behavior. We need memcg OOM and memcg memory
reclaim behavior independent to the availability and varieties of
swaps. This will allow to decouple the job owners decisions on their
job's memory budget from datacenter owners decisions on swap and
memory overcommit. The job owners should not have to worry or think
about swaps and be forced to have different configurations based on
types and availability of swaps in different datacenters.

Tejun, I think I have very clearly explained that without memsw,
consistent memcg OOM and reclaim behavior is not possible and why
consistent behavior is crucial. If you think otherwise, please
pinpoint where you disagree.

I really appreciate your time and patience.

thanks,
Shakeel
