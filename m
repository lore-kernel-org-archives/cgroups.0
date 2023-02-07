From: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] sched/isolation: Merge individual nohz_full features
 into a common housekeeping flag
Date: Tue, 7 Feb 2023 12:49:41 +0100
Message-ID: <Y+I61dp5qPkWK4s2@lothringen>
References: <20230203232409.163847-1-frederic@kernel.org>
 <20230203232409.163847-2-frederic@kernel.org>
 <20230206155107.GA31453@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675770584;
        bh=RgVgJCrLkTAvmwUYHcxZco9kHb4tcMhvYtkGp0jn4Uw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tLvug3F3Minye5YXeEpg6rj46hLxC8/p8PnepfTsimLxWG/Th4ZPg+Gppcs2IcXjj
         YO/kg3jMl1KIODxpVAbL/icPosTwmqgKrebGucclQCTk0BUKZb+qDeIWX9uX0G6kiE
         vFO/v77bmwVwwMnmFrf7guquDrQDLKHmI6fbPJ17akGjL82op+LxtSRmVVl/h54+8Y
         Olta0cI33IiMJCCYZrEPuR/VE5rXtKwbD+zVYYSY0iioEp8sjr6VZbyBI7TrVoYUQi
         4TnJseDLpVDQuCvoCoUTCJyvrgYtEDJUd3jEQorADL8yVmZ4eVu2JtzvcTCvgImn24
         XbTwOQWCQqhTA==
Content-Disposition: inline
In-Reply-To: <20230206155107.GA31453-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leonardo <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon, Feb 06, 2023 at 04:51:09PM +0100, Michal Koutn=FD wrote:
> Hello Frederic.
>=20
> On Sat, Feb 04, 2023 at 12:24:08AM +0100, Frederic Weisbecker <frederic-D=
gEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > The individual isolation features turned on by nohz_full were initially
> > split in order for each of them to be tunable through cpusets. However
> > plans have changed in favour of an interface (be it cpusets or sysctl)
> > grouping all these features to be turned on/off altogether.
> > Then should the need ever arise, the interface can still be expanded
> > to handle the individual isolation features.
> >=20
> > Therefore the current isolation split between tick/timer/workqueue/rcu/
> > kthreads/misc doesn't make sense anymore.
>=20
> Why it doesn't make sense? I think it's a useful annotation of
> respective operations wrt CPU isolation.

But what do we need these annotations for? The only outcome I've ever
seen with these is that it confuses everyone.

>=20
> The grouping you did into HK_TYPE_KERNEL_NOISE (or even coarser) should
> IMO be done at the place where it'll be exposed into the favored
> interface (like it's with nohz_full=3D).

That being said I should reserve the grouping to HK_TYPE_KERNEL_NOISE when
I'll introduce the cpuset interface. This way I can add the support for
each part smoothly. For example first patch moves HK_TYPE_TIMER to
HK_TYPE_KERNEL_NOISE and unbound timers are supported by cpuset.kernel_nois=
e,
second patch moves HK_TYPE_WQ to HK_TYPE_KERNEL_NOISE and unbound workqueues
are supported by cpuset.kernel_noise, etc until all of them turned by nohz_=
full=3D
are supported... This is what I'm doing in fact but I'm so slow to write th=
is patchset...

Thanks.
