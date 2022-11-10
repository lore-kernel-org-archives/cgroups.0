From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: problem with remove cgroup in function cgroup_addrm_files
Date: Thu, 10 Nov 2022 16:15:22 +0100
Message-ID: <20221110151522.GB10562@blackbody.suse.cz>
References: <CADn0Px_+-z5-cjJ6t6fO86=oq9Se-uLDA1nJ0OUSxwf+zHJgWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="OwLcNYc0lM97+oe1"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1668093323; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aKymvBvNUc8tSCUQvAi1PjPsqmEYDlbDheSS2WGM6TE=;
        b=gUJwt0jof4XdlEV8c5oNAwU7p6Z4rKIk1smBOSJqHG7koAWfNIf/A173AOq+zxW7NIUUZv
        vOmPFyi3vfoq5zU5Sy6qaAT8ukiEbdlLRmd8BFf7U5/XU/BFL4bpftu40v5izx8TXFs0id
        ooSzWIy74jATH1hJ2frezuXNvGy44fQ=
Content-Disposition: inline
In-Reply-To: <CADn0Px_+-z5-cjJ6t6fO86=oq9Se-uLDA1nJ0OUSxwf+zHJgWQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Sergey Dolgov <palza00-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--OwLcNYc0lM97+oe1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi.

On Mon, Nov 07, 2022 at 12:50:04PM +0600, Sergey Dolgov <palza00-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> we faced problem in removing cgroup in cgroup_addrm_files in kernel 5.4

Do you have a reproducer for this issue? Ideally, with a current kernel?



> crash> struct cgroup_subsys.cfts 0xffff88fc910d9f80
>   cfts = {
>     next = 0x703,
>     prev = 0x0
>   },

The cgroup_subsys pointed in css->ss doesn't look like a valid
cgroup_subsys, cfts.next looks like a rubbish.

>  from (!css->ss) to (!(css->ss or css == css->cgroup->self)) it will
> be resolve problem

This doesn't seem correct to me. The condition in this place should
capture whether css represents a true subsys state or just a cgroup.
You made it effectively always false, regardless of css->ss is valid or
not. (Maybe there's a typo in your posting and the "fix" was making the
condition always true but that still doesn't seem correct to me, it's
just masking the garbled css->ss.)

> loaded Tainted: G           OE     5.4.0-73-generic #82~18.04.1-Ubuntu

`(O)`  externally-built ("out-of-tree") module was loaded

My bets are off.

HTH,
Michal

--OwLcNYc0lM97+oe1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY20VhgAKCRAkDQmsBEOq
uQ2IAQDSlyu5enLN9jLXDkH7Dtke8PPrLhE5nVjo6rrcpmlhQQD/QKJ3rDxmsCcK
zJ8aumroXcoYId9hWISTWsa4q7FX6AI=
=JZjC
-----END PGP SIGNATURE-----

--OwLcNYc0lM97+oe1--
