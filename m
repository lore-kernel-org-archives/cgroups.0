From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/2] sched/psi: iterate through cgroups directly
Date: Wed, 8 Feb 2023 18:29:56 +0100
Message-ID: <20230208172956.GF24523@blackbody.suse.cz>
References: <20230208161654.99556-1-ryncsn@gmail.com>
 <20230208161654.99556-3-ryncsn@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FoLtEtfbNGMjfgrs"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1675877397; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fNT7NX0+hT2aQtpy7b1M6dknJlluQx/yb2v06LJSz4M=;
        b=sQ8cUC9PcQvWDu0lRxPN9duoXTBMmUEOh6UcpBdECsy0vXbOypH3BJoor9HNZmolDykWdc
        TMP7tWJSYqYNS076G5wDJvHdCGx8YwFfi5J8FOVd7mm/GafpEkYcKAs/yGrkAIHWJCoKyF
        OwspVtVsMA3fItc7ZI47R3eOL+bU9kg=
Content-Disposition: inline
In-Reply-To: <20230208161654.99556-3-ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kairui Song <ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


--FoLtEtfbNGMjfgrs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 09, 2023 at 12:16:54AM +0800, Kairui Song <ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Signed-off-by: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Kairui Song <ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Typo?

> -static inline struct psi_group *task_psi_group(struct task_struct *task)
> +static inline struct psi_group *psi_iter_first(struct task_struct *task, void **iter)
>  {
>  #ifdef CONFIG_CGROUPS
> -	if (static_branch_likely(&psi_cgroups_enabled))
> -		return cgroup_psi(task_dfl_cgroup(task));
> +	if (static_branch_likely(&psi_cgroups_enabled)) {
> +		struct cgroup *cgroup = task_dfl_cgroup(task);
> +
> +		*iter = cgroup_parent(cgroup);

This seems to skip a cgroup level -- maybe that's the observed
performance gain?

> +		return cgroup_psi(cgroup);
> +	}
>  #endif
>  	return &psi_system;
>  }

Michal

--FoLtEtfbNGMjfgrs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY+PcEQAKCRAkDQmsBEOq
ucIeAQDi16jPR5cqfDFK6ypdLlSSoGcqc6FSu2lcsoDjuvDlnwD/ZU7UkoG2cu4M
KNiNToxChBDynyJlkRovlFTYnxMSMwg=
=Cy+H
-----END PGP SIGNATURE-----

--FoLtEtfbNGMjfgrs--
