From: Hao Sun <sunhao.th-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: KCSAN: data-race in cgroup_rstat_flush_locked / cgroup_rstat_updated
Date: Sat, 18 Sep 2021 09:27:08 +0800
Message-ID: <CACkBjsZnp8Kf26tR3anbcLQNiMJ9=bqYMJ66tKBvXO6tkV3qyw@mail.gmail.com>
References: <CACkBjsbPVdkub=e-E-p1WBOLxS515ith-53SFdmFHWV_QMo40w@mail.gmail.com>
 <20210917164123.GA13346@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dq5NAUNnuQNz4xykRs3WCZJi29irBQGvaHlCZa+2iL0=;
        b=ZMx3BcEsTREXr2zFDd4dWEB/1hW4z4yKEKIJHajsDhjJTlx7vYAT06Tcrbck05mSpx
         4TnoszT1uZUsSTJHsmR/7NlPGUf06c3sUSmZOfEc0W6lnVYjyn17l+KmAHVNhfYNzAUP
         vMaOZUPbUMAGhhUlbqpj8WODuQNaMIF83can/QlZVYveu/eqopuo8o7cAZBfZW8BzUaR
         W4fiiDo2BcKDfAJ4FunyGfeM4cXJIabjtg6iuJF8VxaG7uo1nX6e3SMxXKJq9ZWmkebc
         qKAaQZme5Pih44UhxvjlgeaRDp6fEbJeES6vT67pwKpx/yEI2eiXEnQCtsJVfC7GVop4
         89VA==
In-Reply-To: <20210917164123.GA13346-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

Hi Michal,

Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> =E4=BA=8E2021=E5=B9=B49=E6=9C=8818=E6=
=97=A5=E5=91=A8=E5=85=AD =E4=B8=8A=E5=8D=8812:41=E5=86=99=E9=81=93=EF=BC=9A
>
> Hello Hao.
>
> On Thu, Sep 16, 2021 at 09:53:55PM +0800, Hao Sun <sunhao.th-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
> > KCSAN reported the following data race during the kernel booting when
> > using Healer to fuzz the latest Linux kernel.
> > [...]
> >  cgroup_rstat_cpu_pop_updated kernel/cgroup/rstat.c:139 [inline]
> >  [...]
> >  cgroup_rstat_updated+0x53/0x1b0 kernel/cgroup/rstat.c:38
>
> FWIW, it's a "safe" race between updaters and flushers (possibly
> missing the latest update(s)). This is expected as explained in
> cgroup_rstat_updated() comment.
>

Would it be better to add a `data_race` macro to the corresponding
location so that the false report can be disabled?
See https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/tools/memory-model/Documentation/access-marking.txt#n58
for more details.
Currently, fuzzer can not test the kernel with KCSAN enabled for a
long time, because cgroups setup is the basic step before executing
any test case.

Regards
Hao
