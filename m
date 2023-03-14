From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/5] cgroup/cpuset: Include offline CPUs when tasks'
 cpumasks in top_cpuset are updated
Date: Tue, 14 Mar 2023 18:34:11 +0100
Message-ID: <20230314173411.fqaxoa2tfifnj6i3@blackpad>
References: <20230306200849.376804-1-longman@redhat.com>
 <20230306200849.376804-3-longman@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3qe72pixdf4dmzhs"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1678815253; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DupMteheALIYB1G+k5H2NhRA08uOKiRKtdEEzOCrJJQ=;
        b=k0qqRYbdVDScAcQj0BLGPYfF2MNBj4I4FWvzeXohYfytIiiAVBtL/2rsaGxdMQHe0A9/zf
        rjPH1AAdnOU8/n9XnRqmMXAJDTrNjxRPM1gSb6G5pxHmFuX38e4BZ3wDCrxeSxPb29mD1p
        1pr7kbztFidXw/9STbEoEPDpUM8CwAw=
Content-Disposition: inline
In-Reply-To: <20230306200849.376804-3-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>


--3qe72pixdf4dmzhs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Waiman.

On Mon, Mar 06, 2023 at 03:08:46PM -0500, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
> -		/*
> -		 * Percpu kthreads in top_cpuset are ignored
> -		 */
> -		if (top_cs && (task->flags & PF_KTHREAD) &&
> -		    kthread_is_per_cpu(task))
> -			continue;
> +		const struct cpumask *possible_mask =3D task_cpu_possible_mask(task);
> =20
> -		cpumask_and(new_cpus, cs->effective_cpus,
> -			    task_cpu_possible_mask(task));
> +		if (top_cs) {
> +			/*
> +			 * Percpu kthreads in top_cpuset are ignored
> +			 */
> +			if ((task->flags & PF_KTHREAD) && kthread_is_per_cpu(task))
> +				continue;
> +			cpumask_andnot(new_cpus, possible_mask, cs->subparts_cpus);
> +		} else {
> +			cpumask_and(new_cpus, cs->effective_cpus, possible_mask);
> +		}

I'm wrapping my head around this slightly.
1) I'd suggest swapping args in of cpumask_and() to have possible_mask
   consistently first.
2) Then I'm wondering whether two branches are truly different when
   effective_cpus :=3D cpus_allowed - subparts_cpus
   top_cpuset.cpus_allowed =3D=3D possible_mask        (1)

IOW, can you see a difference in what affinities are set to eligible
top_cpuset tasks before and after this patch upon CPU hotplug?
(Hm, (1) holds only in v2. So is this a fix for v1 only?)

Thanks,
Michal

--3qe72pixdf4dmzhs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZBCwEQAKCRAkDQmsBEOq
ucEEAP9OI9c5kJhqB0QtHzHKrGbCZbzmTOwe7E5LB65IzTMi/wD/VLC97u3WoAMa
Fjzw23hqzv+JPbXpH+rkk6P0gvPDFQw=
=tWCP
-----END PGP SIGNATURE-----

--3qe72pixdf4dmzhs--
