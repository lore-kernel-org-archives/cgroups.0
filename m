From: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] perf stat: Support old kernels for bperf cgroup counting
Date: Fri, 30 Sep 2022 15:11:02 -0700
Message-ID: <CAM9d7ci4mvc1rsMyRbwH-i2=8XVsEAvkk5JXLMHmbV4nkbBYhQ@mail.gmail.com>
References: <CAM9d7cjQ20a01YoZi=o-_7HT6TzR0TZgtpscKNvRrMq2yqV1Og@mail.gmail.com>
 <20220922041435.709119-1-namhyung@kernel.org> <YzdjHenrJpooKMjv@krava>
 <CAM9d7cjKaZvWQUwGwoTLNzAgHS7ndL_V_5+O+WqMUvuHJ7cWNg@mail.gmail.com> <88915C51-33CD-49A4-A9E0-F5F5ECDEA0C7@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <88915C51-33CD-49A4-A9E0-F5F5ECDEA0C7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arnaldo Carvalho de Melo <arnaldo.melo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jiri Olsa <olsajiri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-perf-users <linux-perf-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Sep 30, 2022 at 3:00 PM Arnaldo Carvalho de Melo
<arnaldo.melo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>
>
> On September 30, 2022 6:56:40 PM GMT-03:00, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >Hi Jiri,
> >
> >On Fri, Sep 30, 2022 at 2:44 PM Jiri Olsa <olsajiri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >>
> >> On Wed, Sep 21, 2022 at 09:14:35PM -0700, Namhyung Kim wrote:
> >> > The recent change in the cgroup will break the backward compatiblity in
> >> > the BPF program.  It should support both old and new kernels using BPF
> >> > CO-RE technique.
> >> >
> >> > Like the task_struct->__state handling in the offcpu analysis, we can
> >> > check the field name in the cgroup struct.
> >> >
> >> > Signed-off-by: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> >> > ---
> >> > Arnaldo, I think this should go through the cgroup tree since it depends
> >> > on the earlier change there.  I don't think it'd conflict with other
> >> > perf changes but please let me know if you see any trouble, thanks!
> >>
> >> could you please paste the cgroup tree link?
> >
> >Do you mean this?
> >
> >  https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
> >
>
>
> Which branch and cset in that tree does you perf skel depends on?

I believe it's for-6.1 and the cset is in

  https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git/commit/?h=for-6.1&id=7f203bc89eb66d6afde7eae91347fc0352090cc3

Thanks,
Namhyung
