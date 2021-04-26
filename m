From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: add cgroup.signal
Date: Mon, 26 Apr 2021 16:42:07 +0200
Message-ID: <YIbRP5/w1ZD804DL@blackbook>
References: <20210423171351.3614430-1-brauner@kernel.org>
 <YIMZkjzNFypjZao9@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="t5H9JHlfBVdAGKzg"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619448129; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gehS6VLlgOM1n0sqUfbTqUuIIQgjLgEpVqlnX5VEuzE=;
        b=uD0Cy+/FdJ6UxuddtzxiQ5vdeMeTsIRVaTTPrA6MrwHIYNhne51Xo7IKF3qgFRdsyGyP6+
        WHm5NBe0MCQZyhfOfHmnMDMnMcjzFg8W7BfLKYtMFsBeKWCT7VbbabQ1yBzBomrah97Aol
        dY6/7ujlNJILvSx2OOyFAifPhM9igcQ=
Content-Disposition: inline
In-Reply-To: <YIMZkjzNFypjZao9-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>


--t5H9JHlfBVdAGKzg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello.

On Fri, Apr 23, 2021 at 12:01:38PM -0700, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
> Overall it sounds very reasonable and makes total sense to me.
I agree this sounds like very desired convenience...

> Many userspace applications can use the new interface instead of
> reading cgroup.procs in a cycle and killing all processes or using the
> freezer and kill a frozen list of tasks.
...however, exactly because of this, I'm not convinced it's justifying
yet another way how to do it and implement that in kernel. (AFAIU, both
those ways should be reliable too (assuming reading cgroup.procs of the
_default_ hierarchy), please correct me if I'm wrong.)

> It will simplify the code and make it more reliable.
It's not cost free though, part of the complexity is moved to the
kernel.
As Roman already pointed earlier, there are is unclear situation wrt
forking tasks. The similar had to be solved for the freezer hence why
not let uspace rely on that already? Having similar codepaths for
signalling the cgroups seems like a way to have two similar codepaths
side by side where one of them serves just to simplify uspace tools.

Michal

--t5H9JHlfBVdAGKzg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmCG0TsACgkQia1+riC5
qSj/Uw/+IQoj2Jh7QG+npIuKITbWSsNTQRw4Y+MjFEa4jP3oGPr1LWiism82uzTh
HCVXW7BsxOwZF+zKeXCOehMs2W9J/W3AJv6tcBymu8O0irtUIZVuOwrwe0QJChwP
k0bIXrwQR9yzA0CuC+sqLa8+z6WYfJEcmOWmJBa0T8vfjFBsmNUYl8/AehoNTCGU
lEO57EOowPqrukvdYzXsLFtC+c9tYCh9UyhuA/eKVeiJKSL4aPKs9gyShtEIOgHe
PoGGSVcUk23mSDKy0xF0lfvcWuxqlppcxl5SBm9GefW7308J1sOeZzbn4N8av8Hj
bjmHnjPI3dwGr4nVkNzbgjko7fNWEgnNvzltMjkv3+PNtCpTX3jMcG3WOG0eTUSc
LL0UzWp3dvnzySdCo0u1NsDzunpoyPhsXDRra/OBvcxCy0hHP2LRL/eveOvQtLZv
/1r9lVI93Oz2Ac+X+3nG7aWf2/lAKXbVvbltlC7amh+cPsqnf4315gHxJkg5VUl+
pDK/I5r/YGjhaEJhHL2E2ni2s/9mN5eWJHhCGaCUfC7BB800tuRcluvLhbN2Qhj+
YHDQHpOFEuPr/VCs5+ZGRmW8o4tY5kSj1IUNljDCjZQFXHCIWLx3nSrecaPK9hlX
SBfJ4MSVAIZ7WmiyQgfgJXmeHtPj2oAOeZPBf+V8mfL4uptNJRI=
=Tr1M
-----END PGP SIGNATURE-----

--t5H9JHlfBVdAGKzg--
