From: Mina Almasry <almasrymina@google.com>
Subject: Re: [RFD RESEND] cgroup: Persistent memory usage tracking
Date: Wed, 24 Aug 2022 12:02:04 -0700
Message-ID: <CAHS8izMFMtM5ry12iEo72nwkynDpgycETn6QoXLGj=O6b8z1jg@mail.gmail.com>
References: <20220818143118.17733-1-laoar.shao@gmail.com> <Yv67MRQLPreR9GU5@slm.duckdns.org>
 <Yv6+HlEzpNy8y5kT@slm.duckdns.org> <CALOAHbDcrj1ifFsNMHBEih5-SXY2rWViig4rQHi9N07JY6CjXA@mail.gmail.com>
 <Yv/DK+AGlMeBGkF1@slm.duckdns.org> <CALOAHbCvUxQn5Zkp2FJ+eL1VgjeRSq1xQhzdiY87C1Cbib-nig@mail.gmail.com>
 <YwNold0GMOappUxc@slm.duckdns.org> <CAHS8izNvEpX3Lv7eFn-vu=4ZT96Djk2dU-VU+zOueZaZZbnWNw@mail.gmail.com>
 <YwPy9hervVxfuuYE@cmpxchg.org> <YwRDFe+K837tKGED@P9FQF9L96D> <YwRF+df9P2TPu7Zw@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=vBlDS68ELiZr1QTGxJOPvYivh7LG+VsuyP+e5BkDizs=;
        b=KFgXrxcerQ3S3zXFOe9MmxseJphuExDFjgTrOTgMM5c828OwMG24lYumRxP31doY51
         K3cCe4S/6ni0oRgdRPgOkwDxqUe2EkEF41lt78W5XERFXOPcHB1Vmy1+NVexHW7RsEtj
         5wmzydLf5j6aH97yWc7b5GXH1MRAmKZyQeJ4rkkIdnI2o9NkcuTf4MH8xLurDgiB1Ld9
         KaA5GWUyP1EakYttIWAzdT0zbylCN4iGgdmjhx2I79snHw8drJY9PzikTZV8arxTMbsZ
         dAouvU+bhh2FPmxFp0+8M6bTInr4nLWqSqrIqdudgOI4HErlyyW4Fm8K+iyW2UfrIA80
         M1Mg==
In-Reply-To: <YwRF+df9P2TPu7Zw@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Yafang Shao <laoar.shao@gmail.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, john fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, jolsa@kernel.org, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, Zefan Li <lizefan.x@bytedance.com>, Cgroups <cgroups@vger.kernel.org>, netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>

On Mon, Aug 22, 2022 at 8:14 PM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Mon, Aug 22, 2022 at 08:01:41PM -0700, Roman Gushchin wrote:
> > > > >    One solution that I can think of is leveraging the resource domain
> > > > >    concept which is currently only used for threaded cgroups. All memory
> > > > >    usages of threaded cgroups are charged to their resource domain cgroup
> > > > >    which hosts the processes for those threads. The persistent usages have a
> > > > >    similar pattern, so maybe the service level cgroup can declare that it's
> > > > >    the encompassing resource domain and the instance cgroup can say whether
> > > > >    it's gonna charge e.g. the tmpfs instance to its own or the encompassing
> > > > >    resource domain.
> > > > >
> > > >
> > > > I think this sounds excellent and addresses our use cases. Basically
> > > > the tmpfs/bpf memory would get charged to the encompassing resource
> > > > domain cgroup rather than the instance cgroup, making the memory usage
> > > > of the first and second+ instances consistent and predictable.
> > > >
> > > > Would love to hear from other memcg folks what they would think of
> > > > such an approach. I would also love to hear what kind of interface you
> > > > have in mind. Perhaps a cgroup tunable that says whether it's going to
> > > > charge the tmpfs/bpf instance to itself or to the encompassing
> > > > resource domain?
> > >
> > > I like this too. It makes shared charging predictable, with a coherent
> > > resource hierarchy (congruent OOM, CPU, IO domains), and without the
> > > need for cgroup paths in tmpfs mounts or similar.
> > >
> > > As far as who is declaring what goes, though: if the instance groups
> > > can declare arbitrary files/objects persistent or shared, they'd be
> > > able to abuse this and sneak private memory past local limits and
> > > burden the wider persistent/shared domain with it.
>
> My thought was that the persistent cgroup and instance cgroups should belong
> to the same trust domain and system level control should be applied at the
> resource domain level. The application may decide to shift between
> persistent and per-instance however it wants to and may even configure
> resource control at that level but all that's for its own accounting
> accuracy and benefit.
>
> > > I'm thinking it might make more sense for the service level to declare
> > > which objects are persistent and shared across instances.
> >
> > I like this idea.
> >
> > > If that's the case, we may not need a two-component interface. Just
> > > the ability for an intermediate cgroup to say: "This object's future
> > > memory is to be charged to me, not the instantiating cgroup."
> > >
> > > Can we require a process in the intermediate cgroup to set up the file
> > > or object, and use madvise/fadvise to say "charge me", before any
> > > instances are launched?
> >
> > We need to think how to make this interface convenient to use.
> > First, these persistent resources are likely created by some agent software,
> > not the main workload. So the requirement to call madvise() from the
> > actual cgroup might be not easily achievable.
>
> So one worry that I have for this is that it requires the application itself
> to be aware of cgroup topolgies and restructure itself so that allocation of
> those resources are factored out into something else. Maybe that's not a
> huge problem but it may limit its applicability quite a bit.
>

I agree with this point 100%. The interfaces being discussed here
require existing applications restructuring themselves which I don't
imagine will be very useful for us at least.

> If we can express all the resource contraints and structures in the cgroup
> side and configured by the management agent, the application can simply e.g.
> madvise whatever memory region or flag bpf maps as "these are persistent"
> and the rest can be handled by the system. If the agent set up the
> environment for that, it gets accounted accordingly; otherwise, it'd behave
> as if those tagging didn't exist. Asking the application to set up all its
> resources in separate steps, that might require significant restructuring
> and knowledge of how the hierarchy is setup in many cases.
>

I don't know if this level of granularity is needed with a madvise()
or such. The kernel knows whether resources are persistent due to the
nature of the resource. For example a shared tmpfs file is a resource
that is persistent and not cleaned up after the process using it dies,
but private memory is. madvise(PERSISTENT) on private memory would not
make sense, and I don't think madvise(NOT_PERSISTENT) on tmpfs-backed
memory region would make sense. Also, this requires adding madvise()
hints in userspace code to leverage this.

> > So _maybe_ something like writing a fd into cgroup.memory.resources.
> >

Sorry, I don't see this being useful - to us at least - if it is an
fd-based interface. It needs to support marking entire tmpfs mounts as
persistent. The reasoning is as Tejun alludes to: our container
management agent generally sets up the container hierarchy for a job
and also sets up the filesystem mounts the job requests. This is
generally because the job doesn't run as root and doesn't bother with
mount namespaces. Thus, our jobs are well-trained in receiving mounts
set up for them from our container management agent. Jobs are _not_
well-trained in receiving an fd from the container management agent,
and restructuring our jobs/services for such an interface will not be
feasible I think.

This applies to us but I imagine it is common practice for the
container management agent to set up mounts for the jobs to use,
rather than provide the job with an fd or collection of fds.

> > Second, it would be really useful to export the current configuration
> > to userspace. E.g. a user should be able to query to which cgroup the given
> > bpf map "belongs" and which bpf maps belong to the given cgroups. Otherwise
> > it will create a problem for userspace programs which manage cgroups
> > (e.g. systemd): they should be able to restore the current configuration
> > from the kernel state, without "remembering" what has been configured
> > before.
>
> This too can be achieved by separating out cgroup setup and tagging specific
> resources. Agent and cgroup know what each cgroup is supposed to do as they
> already do now and each resource is tagged whether they're persistent or
> not, so everything is always known without the agent and the application
> having to explicitly share the information.
>
> Thanks.
>
> --
> tejun
