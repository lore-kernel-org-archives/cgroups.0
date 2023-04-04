From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v3 6/8] workingset: memcg: sleep when flushing stats in workingset_refault()
Date: Tue, 4 Apr 2023 11:09:02 -0700
Message-ID: <CAJD7tkb-0rXL9V2TX-Ax-3OkwJPYx_GaOT4D=VCA60riit+dOw@mail.gmail.com>
References: <20230330191801.1967435-1-yosryahmed@google.com>
 <20230330191801.1967435-7-yosryahmed@google.com> <20230404165305.ffs7uscqpndnfytn@blackpad>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680631779;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B52t2fmF0ydFLoktH3nuFhcnoqrXavrVtQZskikW6K4=;
        b=ZUkn+vMmRDV0gsBTGXHogd0b1TEWeQRRSmXdQcA8YCbW4EuVBBVzWtXP1bseb8UKG4
         HJDAAsbeXjYwlGTq1GOQHa4KVIiS7AVj1arrMSDEu8cZLrnSvtzL29WGP876gNKX0FLM
         R8P9SFqsaEyYhbbck6gl7U+wfPr72XBPHHa+ziXeunDyh9RAQFmIOPxn/sLtUCoxKW8a
         J1BdHwp4szCI6HacbQjAk3Y454DHt3ONjUeVbcPTrpQt9VyfkRUyBrcc8jVO1AZ2tR4e
         1vv98LykBrkR7LWxMPMMrceWD1fqi3G5sA/UdA1GtjX6t0I617WwA0FZIzFiWLDPe/6/
         +B7g==
In-Reply-To: <20230404165305.ffs7uscqpndnfytn@blackpad>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, Michal Hocko <mhocko@suse.com>

On Tue, Apr 4, 2023 at 9:53=E2=80=AFAM Michal Koutn=C3=BD <mkoutny@suse.com=
> wrote:
>
> On Thu, Mar 30, 2023 at 07:17:59PM +0000, Yosry Ahmed <yosryahmed@google.=
com> wrote:
> > In workingset_refault(), we call
> > mem_cgroup_flush_stats_atomic_ratelimited() to read accurate stats
> > within an RCU read section and with sleeping disallowed. Move the
> > call above the RCU read section to make it non-atomic.
> >
> > Flushing is an expensive operation that scales with the number of cpus
> > and the number of cgroups in the system, so avoid doing it atomically
> > where possible.
>
> I understand why one does not process the whole flushing load in one go
> in general.
> However, I remember there were reports of workingset_refault() being
> sensitive to latencies (hence the ratelimited call was created).
>
> Is there any consideration on impact of this here?
> (Or are there other cond_resched() precendents on this path? Should it
> be mentioned like in the vmscan (7/8) commit?)

IIUC there are multiple places where we can sleep in this path, we can
sleep waiting for a page to be read from disk, we can sleep during
allocating the page to read into, and IIUC the allocations on the
fault path can even run into reclaim, going into the vmscan code. So
there are precedents, but I am not sure if that's enough argument.

I did some light performance testing and I did not notice any
regressions (i.e concurrent processes faulting memory with a lot of
cgroups/cpus), but this change is done intentionally in a separate
patch so that it's easy to revert if regressions are reported.

>
> Thanks,
> Michal
