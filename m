From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [RFC PATCH bpf-next 1/9] bpf: introduce CGROUP_SUBSYS_RSTAT
 program type
Date: Tue, 10 May 2022 12:34:42 -0700
Message-ID: <CAJD7tkZVXJY3s2k8M4pcq+eJVD+aX=iMDiDKtdE=j0_q+UWQzA@mail.gmail.com>
References: <20220510001807.4132027-1-yosryahmed@google.com>
 <20220510001807.4132027-2-yosryahmed@google.com> <Ynqyh+K1tMyNCTUW@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LKRFb9sxsi8oVNRQ43Dsv1RUcYQL89fBmT5eMJ6Q6vc=;
        b=EfY1U3ySncids9bZ/XiDLa2VH9i6sbY/PMjLNCbvBO1E67+B//9XD39LPI+k4M4SXb
         0mo6agcKMHL4JcqBGuur1rZZOR0bYlBs9lVOXwn6IxVJevsm9h4qZ5fCDG0CsQl86FHc
         dZm45vhhVRzeMywWFM3c/rIK3xZj9OfCrjmXk+ay6MaeYyuLU2MaWZK4v3cKSshiy3Hh
         8dxDMZWPxm8hyWF/FqJUetv/QUwyev5dO10y3i0kox5kliJcYyKHTQbwrNCeq2ieBpQn
         0QHn/Xra2ZglGj1nSXfcsFwuCOVxiit8IExysiIj+GKovfTp/eBVC8LodvK2lIvQQLOF
         NK9g==
In-Reply-To: <Ynqyh+K1tMyNCTUW@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>

On Tue, May 10, 2022 at 11:44 AM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Tue, May 10, 2022 at 12:17:59AM +0000, Yosry Ahmed wrote:
> > @@ -706,6 +707,9 @@ struct cgroup_subsys {
> >        * specifies the mask of subsystems that this one depends on.
> >        */
> >       unsigned int depends_on;
> > +
> > +     /* used to store bpf programs.*/
> > +     struct cgroup_subsys_bpf bpf;
> >  };
>
> Care to elaborate on rationales around associating this with a specific
> cgroup_subsys rather than letting it walk cgroups and access whatever csses
> as needed? I don't think it's a wrong approach or anything but I can think
> of plenty of things that would be interesting without being associated with
> a specific subsystem - even all the cpu usage statistics are built to in the
> cgroup core and given how e.g. systemd uses cgroup to organize the
> applications in the system whether resource control is active or not, there
> are a lot of info one can gather about those without being associated with a
> specific subsystem.

Hi Tejun,

Thanks so much for taking the time to look into this!

The rationale behind associating this work with cgroup_subsys is that
usually the stats are associated with a resource (e.g. memory, cpu,
etc). For example, if the memory controller is only enabled for a
subtree in a big hierarchy, it would be more efficient to only run BPF
rstat programs for those cgroups, not the entire hierarchy. It
provides a way to control what part of the hierarchy you want to
collect stats for. This is also semantically similar to the
css_rstat_flush() callback.

However, I do see your point about the benefits of collecting stats
that are not associated with any controller. I think there are
multiple options here, and I would love to hear what you prefer:
1. In addition to subsystems, support an "all" or "cgroup" attach
point that loads BPF rstat flush programs that will run for all
cgroups.
2. Simplify the interface so that all BPF rstat flush programs run for
all cgroups, and add the subsystem association later if a need arises.
3. Instead of attaching BPF programs to a subsystem, attach them to a
cgroup. This gives more flexibility, but also makes lifetime handling
of programs more complicated and error-prone. I can also see most use
cases (including ours) attaching programs to the root cgroup anyway.
In this case, we waste space by storing pointers to the same program
in every cgroup, and have unnecessary complexity in the code.

Let me know what you think!

>
> Thanks.
>
> --
> tejun
