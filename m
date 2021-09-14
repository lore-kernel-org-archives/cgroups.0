From: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/3] misc_cgroup: introduce misc.events and misc_events.local
Date: Tue, 14 Sep 2021 13:10:28 -0700
Message-ID: <CAHVum0dd5dw1rkcf0U7OjW2GX4VTZi4RCcbTph99qDftd=2taA@mail.gmail.com>
References: <50b83893065acaef2a9bc3f91c03812dc872f316.1631504710.git.brookxu@tencent.com>
 <CAHVum0dmTULvzD6dhr4Jzow-M1ATi-ubDkO5wQR=RQmWtt_78w@mail.gmail.com> <b62597e9-72c4-563e-fdc7-3315569502f0@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WNWKwD/mZ8dmcHnPyLauepOSjhSOQ4h/50JmWkiv3s0=;
        b=EcGBNwXJXCtEjbiAqZ5SCobVNFat6cwVYl7UZrpcqRZjt6YQEX6uXqQn+h8Hur7RBP
         6Lf5fTjpJCmj8IvaaOplqMgXBBuH+tHM8BEY2eJbEt2CZkmxcK439Q5LYO665Vl+hepx
         U9uY2EfFCOyAcN720RTBPvT3JSy7zWXr5WL7kA4HRZZKTZaGILl/Fuo6ZgtZz8wkakTE
         bKU8KjiEsTo2dhRmKNviX8IQnNZk8d6Rla/TZwPNDuABbhWsQCKglo8WsadZhoars8AK
         wy5nMe2NRGbjEAOl5/WMffpVQdI12t6deZP3nc/5+R5qrjM6c9cJZ73AeuPhuI6PD293
         OWAw==
In-Reply-To: <b62597e9-72c4-563e-fdc7-3315569502f0-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Sep 13, 2021 at 7:24 PM brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> Thanks for your time.
>
> Vipin Sharma wrote on 2021/9/14 12:51 =E4=B8=8A=E5=8D=88:
> > On Sun, Sep 12, 2021 at 10:01 PM brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >>
> >> From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
> >>
> >> Introduce misc.events and misc.events.local to make it easier for
> >
> > I thought Tejun only gave go ahead for misc.events and not for
> > misc.events.local.
> >
>
> Maybe I missed something. I think events.local is somewhat useful. For
> example, the events of node A is large. If we need to determine whether
> it is caused by the max of node A, if there is no events.local, then we
> need to traverse the events of the child nodes and compare them with
> node A. This is a bit complicated. If there is events.local, we can do
> it very easily. Should we keep the events.local interface=EF=BC=9F

Tejun mentioned in his previous email that he prefers the hierarchical
one. https://lore.kernel.org/lkml/YTuX6Cpv1kg+DHmJ-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org/

I agree with you that it's easier to identify the constraint cgroup
with the local file. However, there is one downside also, which is if
a cgroup gets deleted then that local information is lost, we will
need a hierarchical reporting to observe the resource constraint. I
will be fine with both files but if I have to choose one I am now more
inclined towards hierarchical (events).

Thanks
Vipin
