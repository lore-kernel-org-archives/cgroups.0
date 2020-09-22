From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [External] Re: [PATCH] mm/memcontrol: Add the drop_cache
 interface for cgroup v2
Date: Tue, 22 Sep 2020 12:57:19 -0700
Message-ID: <CALvZod64Qwzjv3N2PO-EUtMkA4bs_PM=Tq4=cmuM0VO9P3BAjw@mail.gmail.com>
References: <20200921080255.15505-1-zangchunxin@bytedance.com>
 <20200921081200.GE12990@dhcp22.suse.cz> <CALOAHbDKvT58UFjxy770VDxO0VWABRYb7GVwgw+NiJp62mB06w@mail.gmail.com>
 <20200921110505.GH12990@dhcp22.suse.cz> <CAKRVAeN5U6S78jF1n8nCs5ioAdqvVn5f6GGTAnA93g_J0daOLw@mail.gmail.com>
 <20200922095136.GA9682@chrisdown.name> <CAKRVAePisoOg8QBz11gPqzEoUdwPiJ-9Z9MyFE2LHzR-r+PseQ@mail.gmail.com>
 <20200922104252.GB9682@chrisdown.name> <CAKRVAeOjST1vJsSXMgj91=tMf1MQTeNp_dz34z=DwL7Weh0bmg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Z6CQ4PR7LXXUvvSI+PnJV2oiFyZAUecU41+cGfwOujU=;
        b=c9Y5X31ITFROkCz58BWDmVOTUSXQxwKVO0+YO5gM7Dueho0fqdMOddqGunqR3K1DSz
         koftFlaQy5AWDynEFTUKrj/IhzVPvGkhTp5Nxa+Zlib8R9NmI9XnuBG9iHCHh7KcMQ/B
         R2VvMWJxVq3CuEFElE+lE4DkpmSBO4nOKPEAgpV6PF+cdQ0sJlc2ScNbTbgx8wIlp+Dj
         kZAs1jbuzLo5f/4MpCexanAo64EI9+2+h41TrGEHG8twyTTttEPJrctB/YnAZ2+HkB5k
         uWovA5v2eCiXYkMwI/ZVzbxoqj8LOi8G4gzoBn6tiRDAJ7YqjH0xAUIYJg7tM5JKyukd
         +iUg==
In-Reply-To: <CAKRVAeOjST1vJsSXMgj91=tMf1MQTeNp_dz34z=DwL7Weh0bmg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Chunxin Zang <zangchunxin@bytedance.com>
Cc: Chris Down <chris@chrisdown.name>, Michal Hocko <mhocko@suse.com>, Yafang Shao <laoar.shao@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Jonathan Corbet <corbet@lwn.net>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, kafai@fb.com, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, andriin@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org

On Tue, Sep 22, 2020 at 5:37 AM Chunxin Zang <zangchunxin@bytedance.com> wr=
ote:
>
> On Tue, Sep 22, 2020 at 6:42 PM Chris Down <chris@chrisdown.name> wrote:
> >
> > Chunxin Zang writes:
> > >On Tue, Sep 22, 2020 at 5:51 PM Chris Down <chris@chrisdown.name> wrot=
e:
> > >>
> > >> Chunxin Zang writes:
> > >> >My usecase is that there are two types of services in one server. T=
hey
> > >> >have difference
> > >> >priorities. Type_A has the highest priority, we need to ensure it's
> > >> >schedule latency=E3=80=81I/O
> > >> >latency=E3=80=81memory enough. Type_B has the lowest priority, we e=
xpect it
> > >> >will not affect
> > >> >Type_A when executed.
> > >> >So Type_A could use memory without any limit. Type_B could use memo=
ry
> > >> >only when the
> > >> >memory is absolutely sufficient. But we cannot estimate how much
> > >> >memory Type_B should
> > >> >use. Because everything is dynamic. So we can't set Type_B's memory=
.high.
> > >> >
> > >> >So we want to release the memory of Type_B when global memory is
> > >> >insufficient in order
> > >> >to ensure the quality of service of Type_A . In the past, we used t=
he
> > >> >'force_empty' interface
> > >> >of cgroup v1.
> > >>
> > >> This sounds like a perfect use case for memory.low on Type_A, and it=
's pretty
> > >> much exactly what we invented it for. What's the problem with that?
> > >
> > >But we cannot estimate how much memory Type_A uses at least.
> >
> > memory.low allows ballparking, you don't have to know exactly how much =
it uses.
> > Any amount of protection biases reclaim away from that cgroup.
> >
> > >For example:
> > >total memory: 100G
> > >At the beginning, Type_A was in an idle state, and it only used 10G of=
 memory.
> > >The load is very low. We want to run Type_B to avoid wasting machine r=
esources.
> > >When Type_B runs for a while, it used 80G of memory.
> > >At this time Type_A is busy, it needs more memory.
> >
> > Ok, so set memory.low for Type_A close to your maximum expected value.
>
> Please forgive me for not being able to understand why setting
> memory.low for Type_A can solve the problem.
> In my scene, Type_A is the most important, so I will set 100G to memory.l=
ow.
> But 'memory.low' only takes effect passively when the kernel is
> reclaiming memory. It means that reclaim Type_B's memory only when
> Type_A  in alloc memory slow path. This will affect Type_A's
> performance.
> We want to reclaim Type_B's memory in advance when A is expected to be bu=
sy.
>

How will you know when to reclaim from B? Are you polling /proc/meminfo?

From what I understand, you want to proactively reclaim from B, so
that A does not go into global reclaim and in the worst case kill B,
right?

BTW you can use memory.high to reclaim from B by setting it lower than
memory.current of B and reset it to 'max' once the reclaim is done.
Since 'B' is not high priority (I am assuming not a latency sensitive
workload), B hitting temporary memory.high should not be an issue.
Also I am assuming you don't much care about the amount of memory to
be reclaimed from B, so I think memory.high can fulfil your use-case.
However if in future you decide to proactively reclaim from all the
jobs based on their priority i.e. more aggressive reclaim from B and a
little bit reclaim from A then memory.high is not a good interface.

Shakeel
