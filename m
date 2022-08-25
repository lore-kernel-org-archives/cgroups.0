From: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RESEND PATCH bpf-next v9 0/5] bpf: rstat: cgroup hierarchical
Date: Wed, 24 Aug 2022 17:47:10 -0700
Message-ID: <CAADnVQKJDoE3Krn4TEwubJ0Us-QA5cE4oyZ3G2g2MiRMDn3=Cw@mail.gmail.com>
References: <20220824233117.1312810-1-haoluo@google.com> <CAADnVQLT3JE8LtOYrs30mL88PNs+NaSeXgQqAPEAup5LUC+BPQ@mail.gmail.com>
 <CA+khW7gQi+BK7Qy4Khk=Ro72nfNQaR2kNkwZemB9ELnDo4Nk3Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=cOzunZ0TQ8nKnXZ1VZcYRtC7f0Acf5DwXZKWgmygcKM=;
        b=IwLVmH1ZEwY1PbAdAuS3ODlFbYRP8xZWp2vaQKRxUpfDSL8s3HhcPl9GrSNfiu+umj
         Xporqe5bZLMqOyzMN8sG4RQKa2K+VNub8dkgldHWZnsyJLSp5qRROlQPhFF6r/S+a0FE
         2exsty+Z2+pgV8qxK7qRfLa/Hq82lEHRRW0KFZXLVYg47HwxkHKVQyo2Ngi8FSdAxlh3
         kYgstVx9fFllOlGX3lEwhATGt1tX5ZlTknlKXPMJvqhsP53kUYJV4gYNZ3kH1NUQJ2cs
         vJo8YzcuPbH05jD7fdCrXMn+Jzk9zabSwpvhqdAnR5zbIkVMY4sS1wQo4r7s7/EWB33E
         jtQQ==
In-Reply-To: <CA+khW7gQi+BK7Qy4Khk=Ro72nfNQaR2kNkwZemB9ELnDo4Nk3Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Network Development <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Martin KaFai Lau <martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Koutny <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf@google.>

On Wed, Aug 24, 2022 at 5:42 PM Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Wed, Aug 24, 2022 at 5:29 PM Alexei Starovoitov
> <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> > On Wed, Aug 24, 2022 at 4:31 PM Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > >
> > > This patch series allows for using bpf to collect hierarchical cgroup
> > > stats efficiently by integrating with the rstat framework. The rstat
> > > framework provides an efficient way to collect cgroup stats percpu and
> > > propagate them through the cgroup hierarchy.
> > >
> > > The stats are exposed to userspace in textual form by reading files in
> > > bpffs, similar to cgroupfs stats by using a cgroup_iter program.
> > > cgroup_iter is a type of bpf_iter. It walks over cgroups in four modes:
> > > - walking a cgroup's descendants in pre-order.
> > > - walking a cgroup's descendants in post-order.
> > > - walking a cgroup's ancestors.
> > > - process only a single object.
> > >
> > > When attaching cgroup_iter, one needs to set a cgroup to the iter_link
> > > created from attaching. This cgroup can be passed either as a file
> > > descriptor or a cgroup id. That cgroup serves as the starting point of
> > > the walk.
> > >
> > > One can also terminate the walk early by returning 1 from the iter
> > > program.
> > >
> > > Note that because walking cgroup hierarchy holds cgroup_mutex, the iter
> > > program is called with cgroup_mutex held.
> > >
> > > ** Background on rstat for stats collection **
> > > (I am using a subscriber analogy that is not commonly used)
> > >
> > > The rstat framework maintains a tree of cgroups that have updates and
> > > which cpus have updates. A subscriber to the rstat framework maintains
> > > their own stats. The framework is used to tell the subscriber when
> > > and what to flush, for the most efficient stats propagation. The
> > > workflow is as follows:
> > >
> > > - When a subscriber updates a cgroup on a cpu, it informs the rstat
> > >   framework by calling cgroup_rstat_updated(cgrp, cpu).
> > >
> > > - When a subscriber wants to read some stats for a cgroup, it asks
> > >   the rstat framework to initiate a stats flush (propagation) by calling
> > >   cgroup_rstat_flush(cgrp).
> > >
> > > - When the rstat framework initiates a flush, it makes callbacks to
> > >   subscribers to aggregate stats on cpus that have updates, and
> > >   propagate updates to their parent.
> > >
> > > Currently, the main subscribers to the rstat framework are cgroup
> > > subsystems (e.g. memory, block). This patch series allow bpf programs to
> > > become subscribers as well.
> > >
> > > Patches in this series are organized as follows:
> > > * Patches 1-2 introduce cgroup_iter prog, and a selftest.
> > > * Patches 3-5 allow bpf programs to integrate with rstat by adding the
> > >   necessary hook points and kfunc. A comprehensive selftest that
> > >   demonstrates the entire workflow for using bpf and rstat to
> > >   efficiently collect and output cgroup stats is added.
> > >
> > > ---
> > > Changelog:
> > > v8 -> v9:
> > > - Make UNSPEC (an invalid option) as the default order for cgroup_iter.
> > > - Use enum for specifying cgroup_iter order, instead of u32.
> > > - Add BPF_ITER_RESHCED to cgroup_iter.
> > > - Add cgroup_hierarchical_stats to s390x denylist.
> >
> > What 'RESEND' is for?
> > It seems to confuse patchwork and BPF CI.
> >
> > The v9 series made it to patchwork...
> >
> > Please just bump the version to v10 next time.
> > Don't add things to subject, since automation cannot recognize
> > that yet.
>
> Sorry about that. I thought it was RESEND because no content has
> changed. It was just adding an entry in s390 denylist.
>
> Are we good now? Or I need to send a v10?

No need. Assuming that 'RESEND' version will be green in CI.
