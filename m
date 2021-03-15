From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [Patch v3 0/2] cgroup: New misc cgroup controller
Date: Mon, 15 Mar 2021 20:10:09 +0100
Message-ID: <YE+xEbwUoRj+snTY@blackbook>
References: <20210304231946.2766648-1-vipinsh@google.com>
 <YETLqGIw1GekWdYK@slm.duckdns.org>
 <YEpoS90X19Z2QOro@blackbook>
 <YEupplaAWU1i0G6B@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WauBitk+7AKZVUrp"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1615835412; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gBh9rZ1pe0Dw23aY7I0BceM5dAfPMfFrVDEvEe02JBQ=;
        b=LtTDSfiEFPCuY2dr1iPNxVN3WP7R4nJ6QBfYlBO9dIEx3AZD7DORPVEpyqSZwxaNBD67ho
        thqQwRLsCImAVaMVNPEnBPxDviIafWx0by0BLCZeyNCaYS1XjGqT0/nwMs8kOH0kUWCam7
        aDMSyE7WKRGcejD1r5ZNrf11mumaWEc=
Content-Disposition: inline
In-Reply-To: <YEupplaAWU1i0G6B-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, thomas.lendacky-5C7GfCeVMHo@public.gmane.org, brijesh.singh-5C7GfCeVMHo@public.gmane.org, jon.grimm-5C7GfCeVMHo@public.gmane.org, eric.vantassell-5C7GfCeVMHo@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, frankja-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, gingell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dionnaglaze-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--WauBitk+7AKZVUrp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 12, 2021 at 09:49:26AM -0800, Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> I will add some more information in the cover letter of the next version.
Thanks.

> Each one coming up with their own interaction is a duplicate effort
> when they all need similar thing.
Could this be expressed as a new BPF hook (when allocating/freeing such
a resource unit)?

The decision could be made based on the configured limit or even some
other predicate.

(I saw this proposed already but I haven't seen some more reasoning
whether it's worse/better. IMO, BPF hooks are "cheaper" than full-blown
controllers, though it's still new user API.)


> As per my understanding this is the only for way for loadable modules
> (kvm-amd in this case) to access Kernel APIs. Let me know if there is a
> better way to do it.
I understood the symbols are exported for such modularized builds.
However, making them non-GPL exposes them to any out-of-tree modules,
although, the resource types are supposed to stay hardcoded in the misc
controller. So my point was to make them EXPORT_SYMBOL_GPL to mark
they're just a means of implementing the modularized builds and not an
API. (But they'd remain API for out-of-tree GPL modules anyway, so take
this reasoning of mine with a grain of salt.)

Michal

--WauBitk+7AKZVUrp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmBPsQ0ACgkQia1+riC5
qSh1cQ/9GddlgkcRcRP9oxFJbsVUxhnntwF8wqSof5oSUCBDSWP5Hz7M3P05aFrI
5VTcopKswg9sI+xO2rMiZb2guzOsy4soqTHRj6emRwbs09Pmtb9uEPrg3nbTZsAR
jUHnNRkhPB7LVMhyVRH4wmZRcD1mq0HiJLkzQNaPVG8D3XG0ge6xVr6+doCc2Ev6
UTrbbtcdBXmZX8hnLutMYu+QWNWQJyWJjii1nJKwby1v6heb10/fN40Ai1DQiOrR
l21qKqxrzUjzpJUOv7Rek/FHvKf1u6HcIEI8H1wx/tMdbptH7IMH6fAtRSDpzbnl
rPzovNq6h6r49VwFPKAaY0kx8u0Yv+IUME2GrjpmuxO+O3dvDJiaQeltisxlfWLn
/Cn236Hzs3aGAHHqqLDJXoxarCmdbFbLL5KjLfK8onoUuNkKf9jmZ2puG04Lgin6
iuvW2VEwUeKDXGxly0+JmzbRatQlvjfltDf7QlHx5zZxbGXYXVDFaz0AKx2hS6h+
XeoV5ko/poc6htsxJWdygD+DXl8y0c9JJlQsLHhBr5JPszYaw3BegCedwvZdF4ph
5QczC/tm0JiKqlb9tNIJ/kv2qIC97DbLt0Q0wv3idoAAZ9iTCwOSwRIdA79txnm4
brb1x019FyJQXQbSL9pP2saG0dbJ7PYgNHp//N/zFMahETXHkq4=
=lJqH
-----END PGP SIGNATURE-----

--WauBitk+7AKZVUrp--
