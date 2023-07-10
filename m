From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: update parent subparts cpumask while
 holding css refcnt
Date: Mon, 10 Jul 2023 17:11:00 +0200
Message-ID: <fbabnjfly5w6fxrhe3eu6ebspngz2hd3tqs6rrbropcdvylnhs@ayjdpq73kwui>
References: <20230701065049.1758266-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="d6khoq6gsqetlysp"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1689001861; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rkUXmWpxeLcY3C4VqE8e9jGWUdpB7/rw2YJ/efYsPnI=;
        b=A2Od0yPESfj/f18OkDF90aWDUxuPe6t9a/F/84rsRj/MFEm6f1GhmCeXtQs3fhBMEj0riI
        RdbqK1JMnI0lTsgJbSOPkoMHMaYF/cMoiWjsdv4qHTLhsQg2Bk/yJygE+4V9YAQFonpfPk
        f5yW5KuJGyn8x4F8h65PbiaeOsf/ZzM=
Content-Disposition: inline
In-Reply-To: <20230701065049.1758266-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--d6khoq6gsqetlysp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello.

On Sat, Jul 01, 2023 at 02:50:49PM +0800, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1806,9 +1806,12 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
>  		cpuset_for_each_child(cp, css, parent)
>  			if (is_partition_valid(cp) &&
>  			    cpumask_intersects(trialcs->cpus_allowed, cp->cpus_allowed)) {
> +				if (!css_tryget_online(&cp->css))
> +					continue;
>  				rcu_read_unlock();
>  				update_parent_subparts_cpumask(cp, partcmd_invalidate, NULL, &tmp);
>  				rcu_read_lock();
> +				css_put(&cp->css);

Apologies for a possibly noob question -- why is RCU read lock
temporarily dropped within the loop?
(Is it only because of callback_lock or cgroup_file_kn_lock (via
notify_partition_change()) on PREEMPT_RT?)



[
OT question:
	cpuset_for_each_child(cp, css, parent)				(1)
		if (is_partition_valid(cp) &&
		    cpumask_intersects(trialcs->cpus_allowed, cp->cpus_allowed)) {
			if (!css_tryget_online(&cp->css))
				continue;
			rcu_read_unlock();
			update_parent_subparts_cpumask(cp, partcmd_invalidate, NULL, &tmp);
			  ...
			  update_tasks_cpumask(cp->parent)
			    ...
			    css_task_iter_start(&cp->parent->css, 0, &it);	(2)
			      ...
			rcu_read_lock();
			css_put(&cp->css);
		}

May this touch each task same number of times as its depth within
herarchy?
]

Thanks,
Michal

--d6khoq6gsqetlysp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZKwfggAKCRAGvrMr/1gc
jkMlAP9dEydUm7AhSZFcAIT4PTIji4ci5SpJhYNxQ3uGcnS5kAEAxCGW5mr/WjYb
84481ELcrOzaow28yYL3f1t6KUsnxQU=
=7XOZ
-----END PGP SIGNATURE-----

--d6khoq6gsqetlysp--
