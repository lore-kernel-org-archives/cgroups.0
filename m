From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH bpf-next 0/8] bpf, cgroup: Add bpf support for cgroup
 controller
Date: Mon, 25 Sep 2023 08:43:52 -1000
Message-ID: <ZRHU6MfwqRxjBFUH@slm.duckdns.org>
References: <20230922112846.4265-1-laoar.shao@gmail.com>
 <ZQ3GQmYrYyKAg2uK@slm.duckdns.org>
 <CALOAHbA9-BT1daw-KXHtsrN=uRQyt-p6LU=BEpvF2Yk42A_Vxw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695667434; x=1696272234; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4rW0kJ8enQ9kzrxneD0npJWJJ1FtuYSvDFI9OIwG44c=;
        b=c5uvNahyMI19XMwjTFFCXW9FKvwQ1wDUZ/OisXPYKzwjelurwcIVILYwk0ZjgVu6M2
         7jlyGwsPx4cnIYqzn1rm4sz8OnutNMsF1NzREQMPhjqbe4wThhIrvVY9wAeK/RYootmT
         zJq2l19OXbIfpqgJG13eSjT016SxB2Y7BCXDjUpKhrFvpcgTMrnsg4ryw/2TIABzxIn7
         t85tPuBVa7TuQ/ZDPwdWgBdcgLdeugjZoWhRireh6T5pujJtwymkucZ0x/IUzPz4K29X
         inzQAOFlHzWMZaJzZ/NKUTbXY/jWSTX9ezE1vIbfKv1mPsGy4t6KNmDTC46zgRxRDzgg
         GjAg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALOAHbA9-BT1daw-KXHtsrN=uRQyt-p6LU=BEpvF2Yk42A_Vxw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yonghong.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Sun, Sep 24, 2023 at 02:32:14PM +0800, Yafang Shao wrote:
> On Sat, Sep 23, 2023 at 12:52=E2=80=AFAM Tejun Heo <tj-DgEjT+Ai2ygdnm+yRO=
fE0A@public.gmane.org> wrote:
> >
> > Hello,
> >
> > On Fri, Sep 22, 2023 at 11:28:38AM +0000, Yafang Shao wrote:
> > > - bpf_cgroup_id_from_task_within_controller
> > >   Retrieves the cgroup ID from a task within a specific cgroup contro=
ller.
> > > - bpf_cgroup_acquire_from_id_within_controller
> > >   Acquires the cgroup from a cgroup ID within a specific cgroup contr=
oller.
> > > - bpf_cgroup_ancestor_id_from_task_within_controller
> > >   Retrieves the ancestor cgroup ID from a task within a specific cgro=
up
> > >   controller.
> > >
> > > The advantage of these new BPF kfuncs is their ability to abstract aw=
ay the
> > > complexities of cgroup hierarchies, irrespective of whether they invo=
lve
> > > cgroup1 or cgroup2.
> >
> > I'm afraid this is more likely to bring the unnecessary complexities of
> > cgroup1 into cgroup2.
>=20
> I concur with the idea that we should avoid introducing the
> complexities of cgroup1 into cgroup2. Which specific change do you
> believe might introduce these complexities into cgroup2? Is it the
> modification within task_under_cgroup_hierarchy() or
> cgroup_get_from_id()?

The helpers you are adding only makes sense for cgroup1. e.g.
bpf_cgroup_ancestor_id_from_task_within_controller() makes no sense in
cgroup2. The ancestor ids don't change according to controllers. The only
thing you would ask in cgroup2 is the level at which a given controller is
enabled at along with the straight-forward "where am I in the hierarchy?"
questions. I really don't want to expose interfaces which assume that the
hierarchies change according to the controller in question.

Also, as pointed out before, this doesn't cover cgroup1 named hierarchies
which leaves out a good potion of cgroup1 use cases.

> In fact, we have the option to utilize
> bpf_cgroup_ancestor_id_from_task_within_controller() as a substitute
> for bpf_task_under_cgroup(), which allows us to sidestep the need for
> changes within task_under_cgroup_hierarchy() altogether.

I don't think this is the direction we should take. If you really want,
please tie the interface directly to the hierarchies. Don't hitch hierarchy
identificdation on the controllers. e.g. Introduce cgroup1 only interface
which takes both hierarchy ID and cgroup ID to operate on them.

Thanks.

--=20
tejun
