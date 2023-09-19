From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATH v2] cgroup: add cgroup_favordynmods= command-line option
Date: Tue, 19 Sep 2023 13:00:15 +0200
Message-ID: <7zv7lqkondaacjhmc7oscyqzwugguxvjw2yhdhkv4axhhkts7a@upoxgl3qpunt>
References: <20230906005712.66461-1-luizcap@amazon.com>
 <29bdb453-c6e3-a047-1f27-e9656da92301@amazon.com>
 <ZQiNIWQe7spOwjil@slm.duckdns.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fq5yevqc27dto7fu"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1695121217; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kUW8+lJZM7K/XgtkgyMNw3L0b83uwQqlZMHcQJDzIAc=;
        b=RL/WIN6uROihO8XYV/Rp8U4wVyp11s2T+EP8TBn6cVrqrApsc7WL1JTnAbNytc6oe6ZYID
        jsyLxdp3PAXEQ3J0vw/dXVOL+5la0I1iAr4XLFMiEQxQ1eiZS/20BMnBFPjrCbo+fQ+yqb
        MfImqgqcXiOhnW4rbFh2GFp39D/PP+I=
Content-Disposition: inline
In-Reply-To: <ZQiNIWQe7spOwjil-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Luiz Capitulino <luizcap-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lcapitulino-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org


--fq5yevqc27dto7fu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 18, 2023 at 07:47:13AM -1000, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Michal raised some valid concerns. I don't really mind that it's not great
> on the edges tho. Michal, what do you think?

I'd have a few suggestions:
- reset to have_dynmods value instead of false in cgroup_destroy_root()
  (to the benefing of the users of this option, not the common default
  users) or not touch the value in cgroup_destroy_root() at all
- s/CONFIG_FAVOR_DYNMODS/CONFIG_CGROUP_FAVOR_DYNMODS/ in commit message

Those should be minor tweaks,
Michal

--fq5yevqc27dto7fu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZQl/PQAKCRAGvrMr/1gc
jrkrAP0Tym353enXva+j6+YL+Gm0V3UvU+Jj6RKzfoMExDArZwEAwZ8CC+0DQZW1
1VW13GrliCR0DXybstlYxSDVzLFvcAk=
=OD1D
-----END PGP SIGNATURE-----

--fq5yevqc27dto7fu--
