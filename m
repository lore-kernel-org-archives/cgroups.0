From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH bpf-next 0/8] bpf, cgroup: Add bpf support for cgroup controller
Date: Tue, 26 Sep 2023 11:01:08 +0800
Message-ID: <CALOAHbB3WPwz0iZNSFbQU9HyGBC9Kymhq2zV83PbEYhzmmvz4g@mail.gmail.com>
References: <20230922112846.4265-1-laoar.shao@gmail.com> <ZQ3GQmYrYyKAg2uK@slm.duckdns.org>
 <CALOAHbA9-BT1daw-KXHtsrN=uRQyt-p6LU=BEpvF2Yk42A_Vxw@mail.gmail.com> <ZRHU6MfwqRxjBFUH@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695697306; x=1696302106; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Irbbz1pd7BMY5vzJH82iICB1EXsa28Rc+uh6SDLIjf8=;
        b=ZtkXntJzn92p5jhwFrmgARLwGgMokjCfAT8lmJPI30LDfdkTb1T9jZ8aVTdKmaOm/x
         3TVCucH61zDYCVeomgh3KzTfgCU+pVw/zv8c1RTPp5jdMYilwR6o3uclGqNgopi9bRn0
         awpywotDc0RiJkddApNHLlwx0adHFpYgz09G8e6wfPAK/4VJ3j+oH6oTCYlyo13Lmjm3
         aSliAqq6eQ50/X3Qw5kCrOlIi+ZAOFDZzdPvTr/YRHRpuMAbO3jgiNJxNmVCActA7BeR
         g5kmW6T2Wr0SzLJBaFRGFcv5prW3dTTMkaSXu6o+HQ3aRY+SGCep71IL/Tfm0RLnI3Z3
         Yw2Q==
In-Reply-To: <ZRHU6MfwqRxjBFUH-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yonghong.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Sep 26, 2023 at 2:43=E2=80=AFAM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello,
>
> On Sun, Sep 24, 2023 at 02:32:14PM +0800, Yafang Shao wrote:
> > On Sat, Sep 23, 2023 at 12:52=E2=80=AFAM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrot=
e:
> > >
> > > Hello,
> > >
> > > On Fri, Sep 22, 2023 at 11:28:38AM +0000, Yafang Shao wrote:
> > > > - bpf_cgroup_id_from_task_within_controller
> > > >   Retrieves the cgroup ID from a task within a specific cgroup cont=
roller.
> > > > - bpf_cgroup_acquire_from_id_within_controller
> > > >   Acquires the cgroup from a cgroup ID within a specific cgroup con=
troller.
> > > > - bpf_cgroup_ancestor_id_from_task_within_controller
> > > >   Retrieves the ancestor cgroup ID from a task within a specific cg=
roup
> > > >   controller.
> > > >
> > > > The advantage of these new BPF kfuncs is their ability to abstract =
away the
> > > > complexities of cgroup hierarchies, irrespective of whether they in=
volve
> > > > cgroup1 or cgroup2.
> > >
> > > I'm afraid this is more likely to bring the unnecessary complexities =
of
> > > cgroup1 into cgroup2.
> >
> > I concur with the idea that we should avoid introducing the
> > complexities of cgroup1 into cgroup2. Which specific change do you
> > believe might introduce these complexities into cgroup2? Is it the
> > modification within task_under_cgroup_hierarchy() or
> > cgroup_get_from_id()?
>
> The helpers you are adding only makes sense for cgroup1. e.g.
> bpf_cgroup_ancestor_id_from_task_within_controller() makes no sense in
> cgroup2. The ancestor ids don't change according to controllers. The only
> thing you would ask in cgroup2 is the level at which a given controller i=
s
> enabled at along with the straight-forward "where am I in the hierarchy?"
> questions. I really don't want to expose interfaces which assume that the
> hierarchies change according to the controller in question.

Makes sense.

>
> Also, as pointed out before, this doesn't cover cgroup1 named hierarchies
> which leaves out a good potion of cgroup1 use cases.
>
> > In fact, we have the option to utilize
> > bpf_cgroup_ancestor_id_from_task_within_controller() as a substitute
> > for bpf_task_under_cgroup(), which allows us to sidestep the need for
> > changes within task_under_cgroup_hierarchy() altogether.
>
> I don't think this is the direction we should take. If you really want,
> please tie the interface directly to the hierarchies. Don't hitch hierarc=
hy
> identificdation on the controllers. e.g. Introduce cgroup1 only interface
> which takes both hierarchy ID and cgroup ID to operate on them.

Thanks for your suggestion. I will think about it.
BTW, I can't find the hierarchy ID of systemd (/sys/fs/cgroup/systemd)
in /proc/cgroups. Is this intentional as part of the design, or might
it be possible that we overlooked it?
In the userspace, where can we find the hierarchy ID of a named hierarchy?

--=20
Regards
Yafang
