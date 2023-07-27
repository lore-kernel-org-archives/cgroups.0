From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [External] Re: [PATCH] cgroup/rstat: record the cumulative
 per-cpu time of cgroup and its descendants
Date: Thu, 27 Jul 2023 07:44:28 -1000
Message-ID: <ZMKs_GpHEW6Pfusj@slm.duckdns.org>
References: <20230717093612.40846-1-jiahao.os@bytedance.com>
 <ZLWb-LsBD041hMvr@slm.duckdns.org>
 <2655026d-6ae4-c14c-95b0-4177eefa434f@bytedance.com>
 <ZLcJ1nH8KzWzoQWj@slm.duckdns.org>
 <b4424767-dce7-08a9-3759-43cc9dfa4273@bytedance.com>
 <3d2b68bf-9f40-c779-dcfd-4cf9939edecc@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690479870; x=1691084670;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CMgWDc9HbFTZfCAa6CCrY6Sm3n2por+mG+JbQWL++uA=;
        b=RCcaFekWryy06wzg7UAG1HDH/IAEIm1lTcU2yxEyeXZqezvcy9ba1nwpBwUzwpGQgc
         lQ3sb9j9/E0Yaev3i/fzaujjnPQbX7LogkJXoL90KihlX1Zom10V1ZM0F3VdaIkxDOKf
         dFkC6yqPsAl14hIZglw5FB2XcyowxvSwcPHyuYwmG2oIZ7foSHXypHzsEIgE9jMl8FcR
         Sb8z/S59K2ojW/sYB4CYTjqALXlxjMX7Hcx7WUUnGJQ4izz77GRc1u4vcaT0OWD5+F00
         r8vwmL5MFpeJ3guxnS7gaG6omeZ+Tu8E5AIyp2mAWjKMqDs4vCtnF3nlfvVOPCwN9xG0
         LNbg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3d2b68bf-9f40-c779-dcfd-4cf9939edecc-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Hao Jia <jiahao.os-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jul 27, 2023 at 08:05:44PM +0800, Hao Jia wrote:
>=20
>=20
> On 2023/7/19 Hao Jia wrote:
> >=20
> >=20
> > On 2023/7/19 Tejun Heo wrote:
> > > On Tue, Jul 18, 2023 at 06:08:50PM +0800, Hao Jia wrote:
> > > > https://github.com/jiaozhouxiaojia/cgv2-stat-percpu_test/tree/main
> > >=20
> > > So, we run `stress -c 1` for 1 second in the asdf/test0 cgroup and
> > > asdf/cpu.stat correctly reports the cumulative usage. After removing
> > > asdf/test0 cgroup, asdf's usage_usec is still there. What's missing h=
ere?
> >=20
> > Sorry, some of my expressions may have misled you.
> >=20
> > Yes, cpu.stat will display the cumulative **global** cpu time of the
> > cgroup and its descendants (the corresponding kernel variable is
> > "cgrp->bstat"), and it will not be lost when the child cgroup is
> > removed.
> >=20
> > Similarly, we need a **per-cpu** variable to record the accumulated
> > per-cpu time of cgroup and its descendants.
> > The existing kernel variable "cgroup_rstat_cpu(cgrp, cpu)->bstat" is not
> > satisfied, it only records the per-cpu time of cgroup itself,
> > So I try to add "cgroup_rstat_cpu(cgrp, cpu)->cumul_bstat" to record
> > per-cpu time of cgroup and its descendants.
> >=20
> > In order to verify the correctness of my patch, I wrote a kernel module
> > to compare the results of calculating the per-cpu time of cgroup and its
> > descendants in two ways:
> >  =A0 Method 1. Traverse and add the per-cpu rstatc->bstat of cgroup and
> > each of its descendants.
> >  =A0 Method 2. Directly read "cgroup_rstat_cpu(cgrp, cpu)->cumul_bstat"=
 in
> > the kernel.
> >=20
> > When the child cgroup is not removed, the results calculated by the two
> > methods should be equal.
> >=20
> > > What are you adding?
> > I want to add a **per-cpu variable** to record the cumulative per-cpu
> > time of cgroup and its descendants, which is similar to the variable
> > "cgrp->bstat", but it is a per-cpu variable.
> > It is very useful and convenient for calculating the usage of cgroup on
> > each cpu, and its behavior is similar to the "cpuacct.usage*" interface
> > of cgroup v1.
> >=20
>=20
> Hello Tejun,
>=20
> I don't know if I explained it clearly, and do you understand what I mean?
>=20
> Would you mind adding a variable like this to facilitate per-cpu usage
> calculations and migration from cgroup v1 to cgroup v2?

Oh yeah, I do. I'm just thinking whether we also want to expose that in the
cgroupfs. We are currently not showing anything per-cpu and the output
formatting gets nasty with a huge number of CPUs, so maybe that's not going
to work out all that well. Anyways, I'll get back to you next week.

Thanks.

--=20
tejun
