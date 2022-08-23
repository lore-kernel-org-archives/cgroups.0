From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 09/10] sched/psi: per-cgroup PSI stats
 disable/re-enable interface
Date: Tue, 23 Aug 2022 11:35:59 -0400
Message-ID: <YwTz32VWuZeLHOHe@cmpxchg.org>
References: <20220808110341.15799-1-zhouchengming@bytedance.com>
 <20220808110341.15799-10-zhouchengming@bytedance.com>
 <YvKd6dezPM6UxfD/@slm.duckdns.org>
 <fcd0bd39-3049-a279-23e6-a6c02b4680a7@bytedance.com>
 <b89155d3-9315-fefc-408b-4cf538360a1c@bytedance.com>
 <YvPN07UlaPFAdlet@cmpxchg.org>
 <20220815132343.GA22640@blackbody.suse.cz>
 <9d1997a4-9278-07bd-7f57-952306b28b14@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=SYAHudUPI5QrzKudcquORH0On1C/OknqZBdmjmshgeU=;
        b=TqFj1ebLWjLYSVrPYFRfxKAk4n77SoNLZgCsLhn0knY5tExJE/V2jF9McNhX7QbXRM
         tsHXX5ZujFybQNyugpk/MKa89GXitAbOP3FmFpuxt4Slt9wrk1vRPJAlXS3AHz5OC0wP
         IY6ua704/P81xOXq4ZBiv2LeoGWa9Rv64tY5FkZomGZCjciVHs+0Qa8KeK5GXx6EUzHZ
         YYndDjyQghXOPttvHBtgaocZN97llsr5NB0k063X9ya9zlTx0VC70GZfgEOHisEVatHP
         zSEGKrtkandeoNYaCxVmhGi0XPphUdZglVUGQcP6MJCSqbn53eBBWj80kxWNGMMP5s/W
         R++Q==
Content-Disposition: inline
In-Reply-To: <9d1997a4-9278-07bd-7f57-952306b28b14@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Tejun Heo <tj@kernel.org>, corbet@lwn.net, surenb@google.com, mingo@redhat.com, peterz@infradead.org, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com

On Tue, Aug 23, 2022 at 02:18:21PM +0800, Chengming Zhou wrote:
> On 2022/8/15 21:23, Michal Koutn=FD wrote:
> > On Wed, Aug 10, 2022 at 11:25:07AM -0400, Johannes Weiner <hannes@cmpxc=
hg.org> wrote:
> >> cgroup.pressure.enable sounds good to me too. Or, because it's
> >> default-enabled and that likely won't change, cgroup.pressure.disable.
> >=20
> > Will it not change?
> >=20
> > I'd say that user would be interested in particular level or even just
> > level in subtree for PSI, so the opt-out may result in lots of explicit
> > disablements (or even watch for cgroups created and disable PSI there)
> > to get some performance back.
> >=20
> > I have two suggestions based on the above:
> > 1) Make the default globally configurable (mount option?)
> > 2) Allow implicit enablement upon trigger creation
> >=20
>=20
> I think suggestion 1) make sense in some use case, like make per-cgroup
> PSI disabled by default using a mount option, then enable using the
> "cgroup.pressure" interface.
>=20
> But suggestion 2) auto enable upon trigger creation, if we hide the
> {cpu,memory,io}.pressure files when disabled, how can we create trigger?
>=20
> Want to see what do Johannes and Tejun think about these suggestions?

Re 1: I agree. If desired in the future we can make the default
configurable. Kconfig, mount option, what have you. cgroup.pressure
will work fine as a name regardless of what the default is.

Re 2: Not all consumers of the pressure metrics create trigger. I
would argue that few do. So it isn't the best signal to decide on
whether aggregation should occur. And yes, it's further complicated by
the triggers being written to the very pressure files. If we don't
hide them, we have to come up with another way to mark them as stale,
lest they confuse the heck out of users. Without breaking format...

So IMO, default-enable, "cgroup.pressure" as a name, and hiding the
pressure files should be good for now while allowing to make the
default configurable down the line.
