From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC 1/2] cgroup: sev: Add misc cgroup controller
Date: Fri, 26 Feb 2021 15:23:42 +0100
Message-ID: <YDkEbv9u3OBNpk6f@blackbook>
References: <20210218195549.1696769-1-vipinsh@google.com>
 <20210218195549.1696769-2-vipinsh@google.com>
 <YDVIdycgk8XL0Zgx@blackbook>
 <YDcuQFMbe5MaatBe@google.com>
 <YDdzcfLxsCeYxLNG@blackbook>
 <YDf6bpSxX6I5xdqZ@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0cdvV5m4yIkS6Bx1"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1614349429; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EZ8keW/MmYo/ENSptctxMrJ/qqagf2xtsHbib8YaQAw=;
        b=LSycJx2ivWEdJJgeje1f3n3MzxIWq9i+1H14zarEBVnqfjsRyrE1qdgTZ8NRjn2eZHcbOM
        XyLdocTAt8/EyLAHtETrPeE/SklJq3eKUO2b+f5R8AKF6x5kuJ09iEfrJeDvX7XVPiq1ra
        t+e3m83qhS/4gCKyc9EfHgyaAdxWen4=
Content-Disposition: inline
In-Reply-To: <YDf6bpSxX6I5xdqZ-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: thomas.lendacky-5C7GfCeVMHo@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, brijesh.singh-5C7GfCeVMHo@public.gmane.org, jon.grimm-5C7GfCeVMHo@public.gmane.org, eric.vantassell-5C7GfCeVMHo@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, frankja-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, gingell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dionnaglaze-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--0cdvV5m4yIkS6Bx1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 25, 2021 at 11:28:46AM -0800, Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> My approach here is that it is the responsibility of the caller to:
> 1. Check the return value and proceed accordingly.
> 2. Ideally, let all of the usage be 0 before deactivating this resource
>    by setting capacity to 0
If the calling side can ensure itself that no new units of the resource
are used from that moment on, then it can work this way -- but describe
that in misc_cg_set_capacity() comment.

> Is the above change good?
I think both alternatives would work. But the latter (as I see it now)
would mandate dependency on CONFIG_CGROUP or it'd have to double the
similar logic itself. So maybe keeping the caller responsible explicitly
is simpler from this POV.

> Will there be any objection to extra information?
IMO it's unnecessary (stating this just for consistency reasons), no
strong opinion.

Michal

--0cdvV5m4yIkS6Bx1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmA5BGsACgkQia1+riC5
qSgTGRAAoZ8UZQoAOpamNp2/t/ZoGBQlc2u+5XDs9tPI1LzW7tJ3hNNitPkhB+aC
oh7SiaI8f6LkAqKPRjKsZwPi1oXJUHjaf9T7Vf8HF+CfmahqQBDI+iR3tHO2GDw8
Fn8GabyVuBtFQn8XDHmINeiYkXhTn4IGBO0VO1vrYkZrUSOoE4uIfIRz+8thfpeh
vigJRDm+DTSyNX1klJlfe3li8UHgK282Hf/C2EqXmpMULCdTcrxmsayzh9UgONjX
6ElaMeFSjYIPyYZUFlkwGYmXZ6Kfk0Z+HTm6D+/1nIIuvFImr5u7lY6ssxIb5BhG
VDuJDoIGZp+H7MvB1yRhPnygltT1JkRbi1EDpX5q8HDtFn05h/opFWU5A1leAh6U
mVwn1i6VZ7DEtyqEaCI8iyRLqCK86+fr4W0q9i5QzG5YzddlHqv9QZkF8mPJL5aj
ng008bFSfGliYdIoqmTeHYho+K6hgSVT6W+Sf5bUb0P2w8vWKPwJiFiYlBtitdv/
gReKLtnFUAzHV+w2J7loq0ZbrPAQhdqzHrJo1zpQsByTed0q/Nby8MM3OKk3vmFo
RjxxF7cLao8PIsud76c8LnwkLe3tqLjaXeUYeIKlLdrTjOJeSBjfUEx0nhywg88R
CDTzmts8VVbqWyhBmyuxSmgxYLWdcyX/XZlVexBZotGpGDk6ZWI=
=uKkz
-----END PGP SIGNATURE-----

--0cdvV5m4yIkS6Bx1--
