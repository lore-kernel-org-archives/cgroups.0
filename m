From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [RFC PATCH 6/7] workingset: memcg: sleep when flushing stats in workingset_refault()
Date: Thu, 23 Mar 2023 09:02:09 -0700
Message-ID: <CAJD7tkZ7d_ZFdcfOdZGSeL9i46cyEV+p2rPm0gotvRT8u8atpw@mail.gmail.com>
References: <20230323040037.2389095-1-yosryahmed@google.com>
 <20230323040037.2389095-7-yosryahmed@google.com> <20230323155040.GB739026@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679587366;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jdxCtHk5BHFsSI7nCxtLNI5LUnK63CNxiy4dYgR/sK4=;
        b=QlTme/lFyoVDGKhtIAPxITQZffC97/l2oat44BkhKOQXnc7z5W55mV5A44zPZ8OGX6
         ieCQS9QJJe04JPyGxmvKoxYcb/6gQvd8J2I8xk4kzIExvTBSFeUJ3fpgJT80yPCg0j3n
         KVOa+0j43EavuVRfPpI2YeoOpHD2sYJ8JORlybIjrlpmdZq0xNZpet1HPVPAsNx1EyNw
         imyiMcCNDyrct+tw5WnnPBMwbfXgBSsHluGWQ9dzfC5g79d1pB3qvkF5UzSptGRUNLx2
         RqDfaKK3gyCo40qWY0d2X7soZJSq46RP/P8uVQRQH4A39erkept9iI80vCztx4p5iEEi
         K1yg==
In-Reply-To: <20230323155040.GB739026@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Thu, Mar 23, 2023 at 8:50=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Thu, Mar 23, 2023 at 04:00:36AM +0000, Yosry Ahmed wrote:
> > In workingset_refault(), we call mem_cgroup_flush_stats_delayed() to
> > flush stats within an RCU read section and with sleeping disallowed.
> > Move the call to mem_cgroup_flush_stats_delayed() above the RCU read
> > section and allow sleeping to avoid unnecessarily performing a lot of
> > work without sleeping.
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > ---
> >
> > A lot of code paths call into workingset_refault(), so I am not
> > generally sure at all whether it's okay to sleep in all contexts or not=
.
> > Feedback here would be very helpful.
>
> Yes, it's safe.

Thanks! That's very helpful!
