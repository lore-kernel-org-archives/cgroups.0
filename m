From: Luis Henriques <luis.henriques@canonical.com>
Subject: Re: [PATCH] cgroup: fix seq_show_option merge with legacy_name
Date: Fri, 25 Sep 2015 09:52:41 +0100
Message-ID: <20150925085241.GA2557@ares>
References: <20150908183043.GA23974@www.outflux.net>
 <20150924183328.GA2163@charon>
 <CAGXu5jLtaEdTmX2QzgfrB=J=tWaoc3Bt_uAstep8UyKdh8v-OQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jLtaEdTmX2QzgfrB=J=tWaoc3Bt_uAstep8UyKdh8v-OQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Cgroups <cgroups@vger.kernel.org>, "# 3.4.x" <stable@vger.kernel.org>

On Thu, Sep 24, 2015 at 11:35:00AM -0700, Kees Cook wrote:
> On Thu, Sep 24, 2015 at 11:33 AM, Luis Henriques
> <luis.henriques@canonical.com> wrote:
> > On Tue, Sep 08, 2015 at 11:30:43AM -0700, Kees Cook wrote:
> >> When seq_show_option (068acf2ee776) was merged, it did not correct=
ly
> >> collide with cgroup's addition of legacy_name (3e1d2eed39d8) chang=
es. This
> >> fixes the reported name.
> >>
> >
> > Since a068acf2ee77 ("fs: create and use seq_show_option for escapin=
g")
> > has been CC'ed to stable, shouldn't this be tagged to stable too?
> >
> > (This is upstream commit 61e57c0c3a37 "cgroup: fix seq_show_option
> > merge with legacy_name".)
>=20
> If the cgroup change when to stable also, then yes.
>

And this didn't happen, so no need to include this commit.  Sorry for t=
he
noise.

Cheers,
--
Lu=EDs


> -Kees
>=20
> >
> > Cheers,
> > --
> > Lu=EDs
> >
> >> Signed-off-by: Kees Cook <keescook@chromium.org>
> >> ---
> >>  kernel/cgroup.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> >> index a8538e443784..2cf0f79f1fc9 100644
> >> --- a/kernel/cgroup.c
> >> +++ b/kernel/cgroup.c
> >> @@ -1342,7 +1342,7 @@ static int cgroup_show_options(struct seq_fi=
le *seq,
> >>       if (root !=3D &cgrp_dfl_root)
> >>               for_each_subsys(ss, ssid)
> >>                       if (root->subsys_mask & (1 << ssid))
> >> -                             seq_show_option(seq, ss->name, NULL)=
;
> >> +                             seq_show_option(seq, ss->legacy_name=
, NULL);
> >>       if (root->flags & CGRP_ROOT_NOPREFIX)
> >>               seq_puts(seq, ",noprefix");
> >>       if (root->flags & CGRP_ROOT_XATTR)
> >> --
> >> 1.9.1
> >>
> >>
> >> --
> >> Kees Cook
> >> Chrome OS Security
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ke=
rnel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
>=20
>=20
>=20
> --=20
> Kees Cook
> Chrome OS Security
