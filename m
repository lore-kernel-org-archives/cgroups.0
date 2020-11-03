From: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] Add BPF_PROG_TYPE_CGROUP_IOCTL
Date: Tue, 3 Nov 2020 00:39:28 -0500
Message-ID: <CAOWid-eQSPru0nm8+Xo3r6C0pJGq+5r8mzM8BL2dgNn2c9mt2Q@mail.gmail.com>
References: <20201007152355.2446741-1-Kenny.Ho@amd.com>
 <CAOWid-d=a1Q3R92s7GrzxWhXx7_dc8NQvQg7i7RYTVv3+jHxkQ@mail.gmail.com>
 <20201103053244.khibmr66p7lhv7ge@ast-mbp.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=6C1TddxGZ0d1C85NySMzJA5NrgJ86kaMDvlk9LRzkyE=;
 b=n2AklAvwP4/fcdo+i/2fc9mZ6k8H5UKcX7DnjoynfxwW2cGSAiXmmmv6QRVRqMm3GT
 Qs4H+7sA+/utS7+pg3ScIu8hjO7RJdSpK6pOHrk32QdTt13Iy00a82UWD2iSmlvdVF5d
 mVP7mPciRHJmHaWX8zErMZexWJF6aAcK/5vvmjGCj2kE1TzLTDOozUos0fJHuvurT7i1
 /HA+XLm91nJ5I7CADFUOaiGcQJ7wSSb2upTmZQKcs4bU3wfvA8NdSS0GBO/GbMxGWptQ
 tN10B55HLmapm2QvRBMaDxWAa2uHDRV4kXgPTXk6lPTAM958Je4nwgSuUsNJ85rtjTUC
 t3sg==
In-Reply-To: <20201103053244.khibmr66p7lhv7ge-+o4/htvd0TCa6kscz5V53/3mLCh9rsb+VpNB7YpNyf8@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, amd-gfx list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KP Singh <kpsingh-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrii Nakryiko <andriin-b10kYP2dOMg@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>

Thanks for the reply.  Cgroup awareness is desired because the intent
is to use this for resource management as well (potentially along with
other cgroup controlled resources.)  I will dig into bpf_lsm and learn
more about it.

Regards,
Kenny


On Tue, Nov 3, 2020 at 12:32 AM Alexei Starovoitov
<alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> On Mon, Nov 02, 2020 at 02:23:02PM -0500, Kenny Ho wrote:
> > Adding a few more emails from get_maintainer.pl and bumping this
> > thread since there hasn't been any comments so far.  Is this too
> > crazy?  Am I missing something fundamental?
>
> sorry for delay. Missed it earlier. Feel free to ping the mailing list
> sooner next time.
>
> > On Wed, Oct 7, 2020 at 11:24 AM Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org> wrote:
> > >
> > > This is a skeleton implementation to invite comments and generate
> > > discussion around the idea of introducing a bpf-cgroup program type to
> > > control ioctl access.  This is modelled after
> > > BPF_PROG_TYPE_CGROUP_DEVICE.  The premise is to allow system admins to
> > > write bpf programs to block some ioctl access, potentially in conjunction
> > > with data collected by other bpf programs stored in some bpf maps and
> > > with bpf_spin_lock.
> > >
> > > For example, a bpf program has been accumulating resource usaging
> > > statistic and a second bpf program of BPF_PROG_TYPE_CGROUP_IOCTL would
> > > block access to previously mentioned resource via ioctl when the stats
> > > stored in a bpf map reaches certain threshold.
> > >
> > > Like BPF_PROG_TYPE_CGROUP_DEVICE, the default is permissive (i.e.,
> > > ioctls are not blocked if no bpf program is present for the cgroup.) to
> > > maintain current interface behaviour when this functionality is unused.
> > >
> > > Performance impact to ioctl calls is minimal as bpf's in-kernel verifier
> > > ensure attached bpf programs cannot crash and always terminate quickly.
> > >
> > > TODOs:
> > > - correct usage of the verifier
> > > - toolings
> > > - samples
> > > - device driver may provide helper functions that take
> > > bpf_cgroup_ioctl_ctx and return something more useful for specific
> > > device
> > >
> > > Signed-off-by: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
> ...
> > > @@ -45,6 +46,10 @@ long vfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> > >         if (!filp->f_op->unlocked_ioctl)
> > >                 goto out;
> > >
> > > +       error = BPF_CGROUP_RUN_PROG_IOCTL(filp, cmd, arg);
> > > +       if (error)
> > > +               goto out;
> > > +
>
> That's a bit problematic, since we have bpf_lsm now.
> Could you use security_file_ioctl hook and do the same filtering there?
> It's not cgroup based though. Is it a concern?
> If cgroup scoping is really necessary then it's probably better
> to add it to bpf_lsm. Then all hooks will become cgroup aware.
