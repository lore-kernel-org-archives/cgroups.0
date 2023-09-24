From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH bpf-next 0/8] bpf, cgroup: Add bpf support for cgroup controller
Date: Sun, 24 Sep 2023 14:32:14 +0800
Message-ID: <CALOAHbA9-BT1daw-KXHtsrN=uRQyt-p6LU=BEpvF2Yk42A_Vxw@mail.gmail.com>
References: <20230922112846.4265-1-laoar.shao@gmail.com> <ZQ3GQmYrYyKAg2uK@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695537172; x=1696141972; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bpxJPlID+SCs56C8IjY5nt1fLBEKnY3cZH9wb2ckaP8=;
        b=jL6NdW+nLX1RMVyTaV0poc9JFbgOZHEGMj8karfGXWD8NucfiM7Sd91vXaW5QyTYu2
         Zy/oNYTkIdETP2EsmWq7aQTeoLh+AqYFkx5awPhM6iTMOMcY+BAbDWSI8ZytqFPlwX6t
         gq5Sp6jjl77PlYmSzNseL+RAoVSwLEn85Iy1SPM+zUNHSOkSEBsBlPalFBlPCgDfkmsQ
         lY2lQrF17VE2GLdB0gbFbESl4MEI9boMa4TZLo7eSUwguaLVZtdkub87qb+sP7s9NnQC
         o/RufIPEXa25GPksYsFZAdOC2qoYxEiJ7YbC7ZyngHxF2maembS4KSs+C7nDsfQQaaxb
         eN5A==
In-Reply-To: <ZQ3GQmYrYyKAg2uK-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1254"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yonghong.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Sep 23, 2023 at 12:52=E2=80=AFAM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello,
>
> On Fri, Sep 22, 2023 at 11:28:38AM +0000, Yafang Shao wrote:
> > - bpf_cgroup_id_from_task_within_controller
> >   Retrieves the cgroup ID from a task within a specific cgroup controll=
er.
> > - bpf_cgroup_acquire_from_id_within_controller
> >   Acquires the cgroup from a cgroup ID within a specific cgroup control=
ler.
> > - bpf_cgroup_ancestor_id_from_task_within_controller
> >   Retrieves the ancestor cgroup ID from a task within a specific cgroup
> >   controller.
> >
> > The advantage of these new BPF kfuncs is their ability to abstract away=
 the
> > complexities of cgroup hierarchies, irrespective of whether they involv=
e
> > cgroup1 or cgroup2.
>
> I'm afraid this is more likely to bring the unnecessary complexities of
> cgroup1 into cgroup2.

I concur with the idea that we should avoid introducing the
complexities of cgroup1 into cgroup2. Which specific change do you
believe might introduce these complexities into cgroup2? Is it the
modification within task_under_cgroup_hierarchy() or
cgroup_get_from_id()?

In fact, we have the option to utilize
bpf_cgroup_ancestor_id_from_task_within_controller() as a substitute
for bpf_task_under_cgroup(), which allows us to sidestep the need for
changes within task_under_cgroup_hierarchy() altogether.

>
> > In the future, we may expand controller-based support to other BPF
> > functionalities, such as bpf_cgrp_storage, the attachment and detachmen=
t
> > of cgroups, skb_under_cgroup, and more.
>
> I'm okay with minor / trivial quality of life improvements to cgroup1 but
> this goes much beyond that and is starting to complications to cgroup2
> users, which I think is a pretty bad idea long term. I'm afraid I'm gonna
> have to nack this approach.
>
> Thanks.
>
> --
> tejun



--=20
Regards
Yafang
