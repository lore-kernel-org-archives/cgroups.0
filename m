From: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH bpf-next v1 3/5] bpf: Introduce cgroup iter
Date: Fri, 20 May 2022 10:30:30 -0700
Message-ID: <CA+khW7iN_=9yg6r9wSX5T3biWgUyAZ6quUUjsVp=hXBY9meJ9Q@mail.gmail.com>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-4-yosryahmed@google.com> <YodGI73xq8aIBrNM@slm.duckdns.org>
 <CAJD7tkbvMcMWESMcWi6TtdCKLr6keBNGgZTnqcHZvBrPa1qWPw@mail.gmail.com> <YodNLpxut+Zddnre@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CPavKVkR8bELd7v5gex0nX0RA6A8QGn+WltRM5Og+4g=;
        b=MSLFYCHCp/SZxn9cm5CoWu+3FpwqYMeTrBILRT4T9npnAg/BaxF/9YpOt/8BpfCeIi
         QNFKHiQ8wH5t6TjjD362O2oxnfrihMLlQiPFrrUH+NDukCfPWUuGOvL3+zuu3fi7AGdj
         qgdT4/2uMNS7DYiZi6YKk9IXmhduvHlRP/0woJyAJMNWtD0YS0jrjWL0wPpxdQM3uspA
         vJgbRI25KoLUFPhjSaZoBEnuSQDq+i0ze73pH1kri1TDLTflSDd6UyZwXBxmu5eVfBh6
         UxiMZ9l7YRjsNMFPzIyBLQzKMTq6kkJMswyxyU98m9mX63TaYJcYhQG5GnSYZ1S/bTgH
         STSA==
In-Reply-To: <YodNLpxut+Zddnre-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Networking <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bpf <bpf@v>

Hi Tejun,

On Fri, May 20, 2022 at 1:11 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello,
>
> On Fri, May 20, 2022 at 12:58:52AM -0700, Yosry Ahmed wrote:
> > On Fri, May 20, 2022 at 12:41 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > >
> > > On Fri, May 20, 2022 at 01:21:31AM +0000, Yosry Ahmed wrote:
> > > > From: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > >
> > > > Introduce a new type of iter prog: cgroup. Unlike other bpf_iter, this
> > > > iter doesn't iterate a set of kernel objects. Instead, it is supposed to
> > > > be parameterized by a cgroup id and prints only that cgroup. So one
> > > > needs to specify a target cgroup id when attaching this iter. The target
> > > > cgroup's state can be read out via a link of this iter.
> > > >
> > > > Signed-off-by: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > > Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > >
> > > This could be me not understanding why it's structured this way but it keeps
> > > bothering me that this is adding a cgroup iterator which doesn't iterate
> > > cgroups. If all that's needed is extracting information from a specific
> > > cgroup, why does this need to be an iterator? e.g. why can't I use
> > > BPF_PROG_TEST_RUN which looks up the cgroup with the provided ID, flushes
> > > rstat, retrieves whatever information necessary and returns that as the
> > > result?
> >
> > I will let Hao and Yonghong reply here as they have a lot more
> > context, and they had previous discussions about cgroup_iter. I just
> > want to say that exposing the stats in a file is extremely convenient
> > for userspace apps. It becomes very similar to reading stats from
> > cgroupfs. It also makes migrating cgroup stats that we have
> > implemented in the kernel to BPF a lot easier.
>
> So, if it were upto me, I'd rather direct energy towards making retrieving
> information through TEST_RUN_PROG easier rather than clinging to making
> kernel output text. I get that text interface is familiar but it kinda
> sucks in many ways.
>

Tejun, could you explain more about the downside of text interfaces
and why TEST_RUN_PROG would address the problems in text output? From
the discussion we had last time, I understand that your concern was
the unstable interface if we introduce bpf files in cgroupfs, so we
are moving toward replicating the directory structure in bpffs. But I
am not sure about the issue of text format output

> > AFAIK there are also discussions about using overlayfs to have links
> > to the bpffs files in cgroupfs, which makes it even better. So I would
> > really prefer keeping the approach we have here of reading stats
> > through a file from userspace. As for how we go about this (and why a
> > cgroup iterator doesn't iterate cgroups) I will leave this for Hao and
> > Yonghong to explain the rationale behind it. Ideally we can keep the
> > same functionality under a more descriptive name/type.
>
> My answer would be the same here. You guys seem dead set on making the
> kernel emulate cgroup1. I'm not gonna explicitly block that but would
> strongly suggest having a longer term view.
>

The reason why Yosry and I are still pushing toward this direction is
that our user space applications rely heavily on extracting
information from text output for cgroups. Please understand that
migrating them from the traditional model to a new model is a bigger
pain. But I agree that if we have a better, concrete solution (for
example, maybe TEST_RUN_PROG) to convince them and help them migrate,
I really would love to contribute and work on it.

> If you *must* do the iterator, can you at least make it a proper iterator
> which supports seeking? AFAICS there's nothing fundamentally preventing bpf
> iterators from supporting seeking. Or is it that you need something which is
> pinned to a cgroup so that you can emulate the directory structure?
>

Yonghong may comment on adding seek for bpf_iter. I would love to
contribute if we are in need of that. Right now, we don't have a use
case that needs seek for bpf_iter, I think. My thought: for cgroups,
we can seek using cgroup id. Maybe, not all kernel objects are
indexable, so seeking doesn't apply there?

Hao
