From: Yafang Shao <laoar.shao@gmail.com>
Subject: Re: [RFC PATCH bpf-next 0/5] bpf, cgroup: Enable cgroup_array map on cgroup1
Date: Sun, 17 Sep 2023 15:19:06 +0800
Message-ID: <CALOAHbCG6W+dxpcO-f=U5=9WD-sEqRoLuhFrYAps-p944=sVgw@mail.gmail.com>
References: <20230903142800.3870-1-laoar.shao@gmail.com> <qv2xdcsvb4brjsc7qx6ncxrudwusogdo4itzv4bx2perfjymwl@in7zaeymjiie>
 <CALOAHbB-PF1LjSAxoCdePN6Va4D+ufkeDmq8s3b0AGtfX5E-cQ@mail.gmail.com>
 <CAADnVQL+6PsRbNMo=8kJpgw1OTbdLG9epsup0q7La5Ffqj6g6A@mail.gmail.com>
 <CALOAHbBhOL9w+rnh_xkgZZBhxMpbrmLZWhm1X+ZeDLfxxt8Nrw@mail.gmail.com>
 <ZP93gUwf_nLzDvM5@mtj.duckdns.org> <CALOAHbC=yxSoBR=vok2295ejDOEYQK2C8LRjDLGRruhq-rDjOQ@mail.gmail.com>
 <jikppfidbxyqpsswzamsqwcj4gy4ppysvcskrw4pa2ndajtul7@pns7byug3yez>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf+bounces-10217-glkb-bpf=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1694935184; x=1695539984; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CRzdICGYkpsfyS2a+MV5klEIYz7EG73NrctrxBdiSuU=;
        b=AWi7djdkjI7wgvSowXYB1Ndy2/XQB+dV7lE3TDa3fBoRm+KkWEo560WpA4ZqO1tWXw
         APsqw9cmQdcfEjZjmLHhqsOlw7FuuGAIhGkEZyfLiRB5UaKnFdTSbcH+yi1p4d+HZ7eJ
         NwmF0eJnSh+hdn9ax4UgLwyWWU3oFaIVFT9rlTYX5loW0F/iVQUUh6jZ3vT8DIeK/28B
         z5FUFk3EwTlWRuJOCBIiJ+hzDMKGTpKrqIF9I5rX5vWvxZQ+hzptRCnyaOnLwkCvePmx
         wzbzSu0h0adIKWP1pHzYCtFNebrT9MeB5vC7EzM6laxageM0hvmAucOdPgLSGGQykfkC
         bq1A==
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:bpf+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:bpf+unsubscribe@vger.kernel.org>
In-Reply-To: <jikppfidbxyqpsswzamsqwcj4gy4ppysvcskrw4pa2ndajtul7@pns7byug3yez>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, John Fastabend <john.fastabend@gmail.com>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, bpf <bpf@vger.kernel.org>

On Sat, Sep 16, 2023 at 1:01=E2=80=AFAM Michal Koutn=C3=BD <mkoutny@suse.co=
m> wrote:
>
> Hello.
>
> On Tue, Sep 12, 2023 at 11:30:32AM +0800, Yafang Shao <laoar.shao@gmail.c=
om> wrote:
> > With the above changes, I think it can meet most use cases with BPF on =
cgroup1.
> > What do you think ?
>
> I think the presented use case of LSM hooks is better served by the
> default hierarchy (see also [1]).

Hi Michal,

The crucial issue at hand is not whether the LSM hooks are better
suited for the cgroup default hierarchy. What truly matters is the
effort and time required to migrate all cgroup1-based applications to
cgroup2-based ones. While transitioning a single component from
cgroup1-based to cgroup2-based is a straightforward task, the
complexity arises when multiple interdependent components in a
production environment necessitate this transition. In such cases, the
work becomes significantly challenging.

> Relying on a chosen subsys v1 hierarchy is not systematic. And extending
> ancestry checking on named v1 hierarchies seems backwards given
> the existence of the default hierarchy.

The cgroup becomes active only when it has one or more of its
controllers enabled. In a production environment, a task is invariably
governed by at least one cgroup controller. Even in hybrid cgroup
mode, a task is subject to either a cgroup1 controller or a cgroup2
controller. Our objective is to enhance BPF support for
controller-based scenarios, eliminating the need to concern ourselves
with hierarchies, whether they involve cgroup1 or cgroup2. This change
seems quite reasonable, in my opinion.

>
>
> Michal
>
> [1] https://docs.kernel.org/admin-guide/cgroup-v2.html#delegation-contain=
ment

--
Regards
Yafang

