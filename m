From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/2] sched/psi: iterate through cgroups directly
Date: Wed, 8 Feb 2023 14:20:12 -0500
Message-ID: <Y+P17OVZZWVpYIb0@cmpxchg.org>
References: <20230208161654.99556-1-ryncsn@gmail.com>
 <20230208161654.99556-3-ryncsn@gmail.com>
 <20230208172956.GF24523@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tVsdwV9x8pCvaFEYs78XN22msEhvwisTMcb5e9dXsII=;
        b=O6kVaBh7GObE5POHa29gOoPjHf+yuXp5oQfpBtiUifMGcHJWuXDxiiTxbvtaCgcrH+
         JXah2sFTsfCPU48pxZ5bMHLg1HMXFgMfqHMpM/cWWqCsKhLgqTUGkOp4cb6aLR8jGhNu
         ejbQJvhMQVJtuHlCo/RkjRqmjK9nUqyHtkdyQ+GT0BECHGXdE9GnfvG04xJT/5sHEPSY
         aNUDDcNjFBPUWOsM025Xuh2orriC0VYUsNcI2pp58m6lCEfDCRvhjRumUPlFr6G7HpjM
         xr1y7eZHQ/cyiD6xk5TPzxQmypGL31511zZg1leyx2uj5f8C3IloDdW2aznZiueZKmIl
         5vqA==
Content-Disposition: inline
In-Reply-To: <20230208172956.GF24523@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Kairui Song <kasong@tencent.com>, Suren Baghdasaryan <surenb@google.com>, Chengming Zhou <zhouchengming@bytedance.com>, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>

On Wed, Feb 08, 2023 at 06:29:56PM +0100, Michal Koutn=FD wrote:
> On Thu, Feb 09, 2023 at 12:16:54AM +0800, Kairui Song <ryncsn@gmail.com> =
wrote:
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > Signed-off-by: Kairui Song <ryncsn@gmail.com>
>=20
> Typo?
>=20
> > -static inline struct psi_group *task_psi_group(struct task_struct *tas=
k)
> > +static inline struct psi_group *psi_iter_first(struct task_struct *tas=
k, void **iter)
> >  {
> >  #ifdef CONFIG_CGROUPS
> > -	if (static_branch_likely(&psi_cgroups_enabled))
> > -		return cgroup_psi(task_dfl_cgroup(task));
> > +	if (static_branch_likely(&psi_cgroups_enabled)) {
> > +		struct cgroup *cgroup =3D task_dfl_cgroup(task);
> > +
> > +		*iter =3D cgroup_parent(cgroup);
>=20
> This seems to skip a cgroup level -- maybe that's the observed
> performance gain?

Hm, I don't think it does. It sets up *iter to point to the parent for
the _next() call, but it returns task_dfl_cgroup()->psi. The next call
does the same: cgroup =3D *iter, *iter =3D parent, return cgroup->psi.

It could be a bit more readable to have *iter always point to the
current cgroup - but no strong preference either way from me:

psi_groups_first(task, iter)
{
#ifdef CONFIG_CGROUPS
	if (static_branch_likely(&psi_cgroups_enabled)) {
		struct cgroup *cgroup =3D task_dfl_cgroup(task);

		*iter =3D cgroup;
		return cgroup_psi(cgroup);
	}
#endif
	return &psi_system;
}

psi_groups_next(iter)
{
#ifdef CONFIG_CGROUPS
	if (static_branch_likely(&psi_cgroups_enabled)) {
		struct cgroup *cgroup =3D *iter;

		if (cgroup) {
			*iter =3D cgroup_parent(cgroup);
			return cgroup_psi(cgroup);
		}
	}
	return NULL;
#endif
}
