From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [LSF/MM/BPF TOPIC] Reducing zombie memcgs
Date: Thu, 4 May 2023 10:02:38 -0700
Message-ID: <CALvZod4=+ANT6UR5h7Cp+0hKkVx6tPAaRa5iqBF=L2VBdMKERQ@mail.gmail.com>
References: <CABdmKX2M6koq4Q0Cmp_-=wbP0Qa190HdEGGaHfxNS05gAkUtPA@mail.gmail.com>
 <ZFLdDyHoIdJSXJt+@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683219770; x=1685811770;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Aw5r5ALm4oFjWiHQAjuyJ/C3zh1wvAYI8hLaKDUg1ew=;
        b=WqN3KPJdT+xRIDnVbuxJdVPto4J2z/z1p+k2dZpdbhh36anIVnYFISHW8IAMDPjQ2c
         MXcYtl89Z5wRzZnAJJSXv0rlYW+KuwXbaTMjRQS7ytQtz707A7VfECWanLieTvzaYWFp
         62QhEtDhbQMJ2sWXZoZxg7OphoiOQy1LKpVF97k9zELX0BLlx49fbI67O3b71dP/Ph2h
         8qKkf/DqwPBg2ubww9OL/lDj+Dtagm0Lk+owMktXbBoYlXvjFbNSjRdmsKtcBchPbZ+V
         sUHEfoyzTrnuQ5nBN3UWqWtYwy/Y73U4apHcLi/q8mIWbeDQSeUZyZ3g1IfwMGomkuTh
         ldtQ==
In-Reply-To: <ZFLdDyHoIdJSXJt+-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Chris Li <chrisl-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Kalesh Singh <kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed, May 3, 2023 at 3:15=E2=80=AFPM Chris Li <chrisl-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
[...]
> I am also interested in this topic. T.J. and I have some offline
> discussion about this. We have some proposals to solve this
> problem.
>
> I will share the write up here for the up coming LSF/MM discussion.
>
>
> Shared Memory Cgroup Controllers
>
> =3D Introduction
>
> The current memory cgroup controller does not support shared memory objec=
ts. For the memory that is shared between different processes, it is not ob=
vious which process should get charged. Google has some internal tmpfs =E2=
=80=9Cmemcg=3D=E2=80=9D mount option to charge tmpfs data to  a specific me=
mcg that=E2=80=99s often different from where charging processes run. Howev=
er it faces some difficulties when the charged memcg exits and the charged =
memcg becomes a zombie memcg.

What is the exact problem this proposal is solving? Is it the zombie
memcgs? To me that is just a side effect of memory shared between
different memcgs.

> Other approaches include =E2=80=9Cre-parenting=E2=80=9D the memcg charge =
to the parent memcg. Which has its own problem. If the charge is huge, iter=
ation of the reparenting can be costly.

What is the iteration of the reparenting? Are you referring to
reparenting the LRUs or something else?

>
> =3D Proposed Solution
>
> The proposed solution is to add a new type of memory controller for share=
d memory usage. E.g. tmpfs, hugetlb, file system mmap and dma_buf. This sha=
red memory cgroup controller object will have the same life cycle of the un=
derlying  shared memory.

I am confused by the relationship between shared memory controller and
the underlying shared memory. What does the same life cycle mean? Are
the users expected to register the shared memory objects with the
smemcg? What about unnamed shared memory objects like MAP_SHARED or
memfds?

How does the charging work for smemcg? Is this new controller hierarchical?

>
> Processes can not be added to the shared memory cgroup. Instead the share=
d memory cgroup can be added to the memcg using a =E2=80=9Csmemcg=E2=80=9D =
API file, similar to adding a process into the =E2=80=9Ctasks=E2=80=9D API =
file.

Is the charge of the underlying shared memory live with smemcg or the
memcg where smemcg is attached? Can a smemcg detach and reattach to a
different memcg?

> When a smemcg is added to the memcg, the amount of memory that has been s=
hared in the memcg process will be accounted for as the part of the memcg =
=E2=80=9Cmemory.current=E2=80=9D.The memory.current of the memcg is make up=
 of two parts, 1) the processes anonymous memory and 2) the memory shared f=
rom smemcg.

The above is somewhat giving the impression that the charge of shared
memory lives with smemcg. This can mess up or complicate the
hierarchical property of the original memcg.

>
> When the memcg =E2=80=9Cmemory.current=E2=80=9D is raised to the limit. T=
he kernel will active try to reclaim for the memcg to make =E2=80=9Csmemcg =
memory + process anonymous memory=E2=80=9D within the limit. Further memory=
 allocation within those memcg processes will fail if the limit can not be =
followed. If many reclaim attempts fail to bring the memcg =E2=80=9Cmemory.=
current=E2=80=9D within the limit, the process in this memcg will get OOM k=
illed.

The OOM killing for remote charging needs much more thought. Please
see https://lwn.net/Articles/787626/ for previous discussion on
related topic.
