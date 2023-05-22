From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 3/3] cgroup: Do not take css_set_lock in
 cgroup_show_path
Date: Mon, 22 May 2023 10:55:12 -1000
Message-ID: <ZGvWsOOw2C68SYUx@slm.duckdns.org>
References: <20230502133847.14570-1-mkoutny@suse.com>
 <20230502133847.14570-4-mkoutny@suse.com>
 <ZFUktg4Yxa30jRBX@slm.duckdns.org>
 <ta7bilcvc7lzt5tvs44y5wxqt6i3gdmvzwcr5h2vxhjhshmivk@3mecui76fxvy>
 <ZFVIJlAMyzTh3QTP@slm.duckdns.org>
 <6rjdfjltz5kkwzobpeefbqxzj4wbd4jzstdryb6rb67td3x45q@5ujarspzjk3x>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684788915; x=1687380915;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jcZ4xLHlFOBJMSeqJOPUC+cCxzFb/2bpMue0o2+LyWg=;
        b=NhDfKwKmQqTx0k0rb4etztvU4oZUGCrD6GnpDCUv5gYrdAInkuG+Pbfj2sWkRK75GE
         eEv4hZBxOKHblTbEOwTE8x6zJjRsFkyPrKtDO5aSvmAzTGc9h2JeKkeliGLT4oxzAM+z
         cqrGjTVlai+tBgdsWwPy2OB5kzJWfbCe2HwZib6Rd12NaySc4rZGX3wwAwljRyPxCuM7
         mkkG66UWcfS8BoUgs04jDarriwnupHX7oygNuJwUINElggfMahoJvfCuSFteFLt58k2i
         bWUIDDlJPDXAH7NrXm4602kvJUflIHBfpMI2XRO2fB4UVTvnvlAt2dcpTbtjAqgsi1HT
         0LXw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <6rjdfjltz5kkwzobpeefbqxzj4wbd4jzstdryb6rb67td3x45q@5ujarspzjk3x>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Dave Chinner <dchinner@redhat.com>, Rik van Riel <riel@surriel.com>, Jiri Wiesner <jwiesner@suse.de>

Hello, Michal.

Sorry about the delay.

On Tue, May 09, 2023 at 12:34:53PM +0200, Michal Koutn=FD wrote:
> On Fri, May 05, 2023 at 08:17:10AM -1000, Tejun Heo <tj@kernel.org> wrote:
> > On Fri, May 05, 2023 at 07:32:40PM +0200, Michal Koutn=FD wrote:
> > > On Fri, May 05, 2023 at 05:45:58AM -1000, Tejun Heo <tj@kernel.org> w=
rote:
> > > > > There are three relevant nodes for each cgroupfs entry:
> > > > >=20
> > > > >         R ... cgroup hierarchy root
> > > > >         M ... mount root
> > > > >         C ... reader's cgroup NS root
> > > > >=20
> > > > > mountinfo is supposed to show path from C to M.
> > > >=20
> > > > At least for cgroup2, the path from C to M isn't gonna change once =
NS is
> > > > established, right?
> > >=20
> > > Right. Although, the argument about M (when C above M or when C and M=
 in
> > > different subtrees) implicitly relies on the namespace_sem.
> >=20
> > I don't follow. Can you please elaborate a bit more?
>=20
> I wanted to say that even with restriction to cgroup2, the css_set_lock
> removal would also rely on namespace_sem.
>=20
> For a given mountinfo entry the path C--M won't change (no renames).
> The question is whether cgroup M will stay around (with the relaxed
> locking):
>=20
>   - C >=3D M (C is below M)=20
>     -> C (transitively) pins M

Yeah, this was what I was thinking.

>   - C < M (C is above M) or C and M are in two disjoint subtrees (path
>     goes through a common ancestor)
>     -> M could be released without relation to C (even on cgroup2, with
>        the css_set_lock removed) but such a destructive operation on M
>        is excluded as long as namespace_sem is held during entry
>        rendering.
>=20
> Does that clarify the trade-off of removing css_set_lock at this spot?

Right, you can have cgroup outside NS root still mounted and that mount root
can be viewed from multiple cgroup NS's, so the the path isn't fixed either.

Having enough lockdep annotations should do but if reasonable the preference
is being a bit more self-contained.

Thanks for the explanation.

--=20
tejun
