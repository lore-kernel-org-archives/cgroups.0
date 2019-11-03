From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] sched/topology, cpuset: Account for housekeeping CPUs to
 avoid empty cpumasks
Date: Sun, 3 Nov 2019 20:09:57 +0100
Message-ID: <20191103190957.GA39453@gmail.com>
References: <20191102001406.10208-1-valentin.schneider@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=C0rob5sFAjpqukpmpefdlqNTPai5iEaFFr8gvrVBR3Q=;
        b=Q+lnISVamhjpceZ6AOa8Tnuy0SKyRtJ2O6C2wm/XOowXFQWDoIBbHBRk73XZ9ssiPi
         oPBfrx+iCmdCz701fbtqyDwyo1yin5fJZHp3U9dJeURTpRMJ7bRgWTU9KK2ENtO73/JB
         SWTzFX0qlq2oiXgF7thBippmF7L2fAR0MhXVGRsk29eILEnFw6/ohrouinQRPhBN/iX6
         /cuu7wSMFiXO/mVsd+obuhlksNN8rEuo6VeA1r+Ttmt6CiSI8/2Wf2LQSwwp6wK5qiL6
         cFmBIv5zSa9RwkdpmIHvJdlPVzvCCISt4CDmwPoGnJwP7pbD2+iCemMDcFlVK7ShhU1h
         geNA==
Content-Disposition: inline
In-Reply-To: <20191102001406.10208-1-valentin.schneider@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Valentin Schneider <valentin.schneider@arm.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, lizefan@huawei.com, tj@kernel.org, hannes@cmpxchg.org, peterz@infradead.org, vincent.guittot@linaro.org, Dietmar.Eggemann@arm.com, morten.rasmussen@arm.com, qperret@google.com, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>


* Valentin Schneider <valentin.schneider@arm.com> wrote:

> Michal noted that a cpuset's effective_cpus can be a non-empy mask, but
> because of the masking done with housekeeping_cpumask(HK_FLAG_DOMAIN)
> further down the line, we can still end up with an empty cpumask being
> passed down to partition_sched_domains_locked().
>=20
> Do the proper thing and don't just check the mask is non-empty - check
> that its intersection with housekeeping_cpumask(HK_FLAG_DOMAIN) is
> non-empty.
>=20
> Fixes: cd1cb3350561 ("sched/topology: Don't try to build empty sched doma=
ins")
> Reported-by: Michal Koutn=FD <mkoutny@suse.com>
> Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
> ---
>  kernel/cgroup/cpuset.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index c87ee6412b36..e4c10785dc7c 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -798,9 +798,14 @@ static int generate_sched_domains(cpumask_var_t **do=
mains,
>  		    cpumask_subset(cp->cpus_allowed, top_cpuset.effective_cpus))
>  			continue;
> =20
> +		/*
> +		 * Skip cpusets that would lead to an empty sched domain.
> +		 * That could be because effective_cpus is empty, or because
> +		 * it's only spanning CPUs outside the housekeeping mask.
> +		 */
>  		if (is_sched_load_balance(cp) &&
> -		    !cpumask_empty(cp->effective_cpus))
> +		    cpumask_intersects(cp->effective_cpus,
> +				       housekeeping_cpumask(HK_FLAG_DOMAIN)))
>  			csa[csn++] =3D cp;


This patch doesn't apply cleanly to Linus's latest tree - which tree is=20
this against?

Thanks,

	Ingo
