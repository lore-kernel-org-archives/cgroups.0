From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC 1/2] cgroup: sev: Add misc cgroup controller
Date: Thu, 25 Feb 2021 10:52:49 +0100
Message-ID: <YDdzcfLxsCeYxLNG@blackbook>
References: <20210218195549.1696769-1-vipinsh@google.com>
 <20210218195549.1696769-2-vipinsh@google.com>
 <YDVIdycgk8XL0Zgx@blackbook>
 <YDcuQFMbe5MaatBe@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kWQSwDEX83EtuxH+"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1614246779; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pa5Bv87vsQTpNehYktuqD4xYQKRjzqObciTH5tWVW3c=;
        b=u1ctV2DOvv5M/TvL8/NGNEplVlPYpTSVWIJY6Fgko4qtzjF/gHw0OWAMLiSHDQ2b2mkXzZ
        OJMe1QSJXKkXn6QoauxzkkNhwaGXQ3gVkDh7eGFtuQUB386tBsy+u3z/9gwTwUoQmKXP4R
        NSylMMyzM4WXnI5wUI+gcDsJ9XQ5aVI=
Content-Disposition: inline
In-Reply-To: <YDcuQFMbe5MaatBe-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: thomas.lendacky-5C7GfCeVMHo@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, brijesh.singh-5C7GfCeVMHo@public.gmane.org, jon.grimm-5C7GfCeVMHo@public.gmane.org, eric.vantassell-5C7GfCeVMHo@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, frankja-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, gingell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dionnaglaze-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--kWQSwDEX83EtuxH+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 24, 2021 at 08:57:36PM -0800, Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> This function is meant for hot unplug functionality too.
Then I'm wondering if the current form is sufficient, i.e. the generic
controller can hardly implement preemption but possibly it should
prevent any additional charges of the resource. (Or this can be
implemented the other subsystem and explained in the
misc_cg_set_capacity() docs.)

> Just to be on the same page are you talking about adding an events file
> like in pids?
Actually, I meant just the kernel log message. As it's the simpler part
and even pid events have some inconsistencies wrt hierarchical
reporting.

> However, if I take reference at the first charge and remove reference at
> last uncharge then I can keep the ref count in correct sync.
I see now how it works. I still find it a bit complex. What about making
misc_cg an input parameter and making it the callers responsibility to
keep a reference? (Perhaps with helpers for the most common case.)


Thanks,
Michal

--kWQSwDEX83EtuxH+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmA3c20ACgkQia1+riC5
qSi9BhAAlE9yZPtCtt/Vj6a3n7ho7173BwjAGMkNrRYQK8qoh8ebExxRtCAKL0E1
lyWI0cSq4Wul9uHduKwRLljqNpBziZYHrrpaQsT7uQw4A7yn62zAU2xbqDFm558D
9TSQxO59pXdYzyemTPLmkOmkPwjHE5YUfodskMG35tbgFzIxc5SN3izteu3rl/8b
A9Z2Q4Lo/iXi9qKNTpBtQzsNnhxO7ZL+ElkdhEINYX8G2H8tQ0DNVz+vXDXroMPp
N3L3CA00iWrr52jtOoec3TrMsVgnlU5l3jIJASbgt4s68ukWEbgpzdHGEj8U/BfW
dLoxQPNN8sWRChl4nehFtRq06z7hduHdOtqdgYq6y4UDKWJvBObjRFcPYIHuxN6W
MMZOKRvm4ocUENTLK5jbv4I87E7D3457NIYUnmp0+F24tB/D5kRAkT2tNIq7nfWO
e9GmQEeN30UyIudcI9NK7lHdJFEyXYasSR3nDKazdcDSBtxfQ0n65dmEVMtyMkRg
e9Hot1A97AmYYSzJNoUFKKem5f75wvS+/U6dOA3gM43U/69lxNL1mQLeHVkodjTK
Bz9YZgvDvx5sOsTfvmVNe2iFz5y35we5zh3hqLJWOEFSsPJ2lI2aTeVhku7x9w8N
/U90fUVnkjCV7X1gKYOav/vJprMAHOv3CtkfBVp1zXdvzZO2YsE=
=rCA2
-----END PGP SIGNATURE-----

--kWQSwDEX83EtuxH+--
