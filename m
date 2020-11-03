From: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] Add BPF_PROG_TYPE_CGROUP_IOCTL
Date: Mon, 2 Nov 2020 21:32:44 -0800
Message-ID: <20201103053244.khibmr66p7lhv7ge@ast-mbp.dhcp.thefacebook.com>
References: <20201007152355.2446741-1-Kenny.Ho@amd.com>
 <CAOWid-d=a1Q3R92s7GrzxWhXx7_dc8NQvQg7i7RYTVv3+jHxkQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UZv2P1PlpxDMiV1uaU5trzoljWOaeGRNHFFhjSzWpT0=;
        b=R3TNMnNAlQI5nJk2Z1ytvhVYBiVwW4jJCzEMwcWSeKfdU8/TYHNzwU4h334zUfqlAe
         mHCFPEyqYmaSVAwtm4y51iDoEh8042L5KYyHyUhFTSAlyy+hMU/xrAQKyzJwYX4VnzY/
         iE8tNHVgpwLT/jMYHQsx5ybz5lHoksD6NSsy0MSePcuduroaMKYFbVvgW1xZKieDS9lu
         +H7Z8F3R0qGNzKYTn0otbJ2e/0geFcV4wmzmJDU9UjVnY4rPzBlWMIQ73tesAEtd8lfn
         PjHuJcRwkXtJZwlMFWzh3EB/mBDdmII/6RDf51vpqb8IRd+IX+sb+rewRDnT7Plim/nj
         YIYg==
Content-Disposition: inline
In-Reply-To: <CAOWid-d=a1Q3R92s7GrzxWhXx7_dc8NQvQg7i7RYTVv3+jHxkQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Andrii Nakryiko <andriin-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, amd-gfx list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>

On Mon, Nov 02, 2020 at 02:23:02PM -0500, Kenny Ho wrote:
> Adding a few more emails from get_maintainer.pl and bumping this
> thread since there hasn't been any comments so far.  Is this too
> crazy?  Am I missing something fundamental?

sorry for delay. Missed it earlier. Feel free to ping the mailing list
sooner next time.

> On Wed, Oct 7, 2020 at 11:24 AM Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org> wrote:
> >
> > This is a skeleton implementation to invite comments and generate
> > discussion around the idea of introducing a bpf-cgroup program type to
> > control ioctl access.  This is modelled after
> > BPF_PROG_TYPE_CGROUP_DEVICE.  The premise is to allow system admins to
> > write bpf programs to block some ioctl access, potentially in conjunction
> > with data collected by other bpf programs stored in some bpf maps and
> > with bpf_spin_lock.
> >
> > For example, a bpf program has been accumulating resource usaging
> > statistic and a second bpf program of BPF_PROG_TYPE_CGROUP_IOCTL would
> > block access to previously mentioned resource via ioctl when the stats
> > stored in a bpf map reaches certain threshold.
> >
> > Like BPF_PROG_TYPE_CGROUP_DEVICE, the default is permissive (i.e.,
> > ioctls are not blocked if no bpf program is present for the cgroup.) to
> > maintain current interface behaviour when this functionality is unused.
> >
> > Performance impact to ioctl calls is minimal as bpf's in-kernel verifier
> > ensure attached bpf programs cannot crash and always terminate quickly.
> >
> > TODOs:
> > - correct usage of the verifier
> > - toolings
> > - samples
> > - device driver may provide helper functions that take
> > bpf_cgroup_ioctl_ctx and return something more useful for specific
> > device
> >
> > Signed-off-by: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
...
> > @@ -45,6 +46,10 @@ long vfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> >         if (!filp->f_op->unlocked_ioctl)
> >                 goto out;
> >
> > +       error = BPF_CGROUP_RUN_PROG_IOCTL(filp, cmd, arg);
> > +       if (error)
> > +               goto out;
> > +

That's a bit problematic, since we have bpf_lsm now.
Could you use security_file_ioctl hook and do the same filtering there?
It's not cgroup based though. Is it a concern?
If cgroup scoping is really necessary then it's probably better
to add it to bpf_lsm. Then all hooks will become cgroup aware.
