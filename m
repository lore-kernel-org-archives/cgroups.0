From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/2 cgroup/for-6.1] cgroup: Improve cftype add/rm error
 handling
Date: Tue, 6 Sep 2022 21:11:12 +0200
Message-ID: <20220906191112.GF30763@blackbody.suse.cz>
References: <YxUUISLVLEIRBwEY@slm.duckdns.org>
 <20220905131435.GA1765@blackbody.suse.cz>
 <YxeCdHfk2nOUISDw@slm.duckdns.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qoTlaiD+Y2fIM3Ll"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1662491473; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ghVpqZbCJEhGOm8vLPxrUgwg0tE4oNBHkbMpPGSkKp8=;
        b=ZgVGHVOWUvLJp6O/urOg6d9Ib+KoIAVvUO6gWNPASSId7g7IdYUAz6JDkdmrdnxzzLXjAn
        u6i5fRzCbsduiSupoCb6NuhSSyE0mYQsqgHjkM+s0hXXcxQma7RjBIjqHA3yrs0DCZOzEJ
        OWsp5Lw5kMCLfXZizGz/+PYmO8dBw+o=
Content-Disposition: inline
In-Reply-To: <YxeCdHfk2nOUISDw-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org


--qoTlaiD+Y2fIM3Ll
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 06, 2022 at 07:25:08AM -1000, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> I prefer having it as a separate flag because it's explicit and can be
> tested together with other flags. It's a weak preference tho and I can go
> either way if it bothers you much.

No trouble, please proceed with the new flag.

BTW, while I was just looking over the patch I noticed that in

@@ -1717,14 +1722,22 @@ static int css_populate_dir(struct cgrou
                return 0;

        if (!css->ss) {
-               if (cgroup_on_dfl(cgrp))
-                       cfts = cgroup_base_files;
-               else
-                       cfts = cgroup1_base_files;
-
-               ret = cgroup_addrm_files(&cgrp->self, cgrp, cfts, true);
-               if (ret < 0)
-                       return ret;
+               if (cgroup_on_dfl(cgrp)) {
+                       ret = cgroup_addrm_files(&cgrp->self, cgrp,
+                                                cgroup_base_files, true);
+                       if (ret < 0)
+                               return ret;
+
+                       if (cgroup_psi_enabled()) {
+                               ret = cgroup_addrm_files(&cgrp->self, cgrp,
+                                                        cgroup_psi_files, true);
+                               if (ret < 0)
+                                       return ret;

Before the return here, the function should revert the base files first (or
silence the return value to 0 if such a partial population is acceptable).

(Actually, it looks like the revert in the subsys branch is unnecessary as
callers of css_populate_dir() would issue css_clear_dir() upon failure
eventually.)


Thanks,
Michal

--qoTlaiD+Y2fIM3Ll
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCYxebSgAKCRAkDQmsBEOq
uX0hAP9JqfWxYBZ3k0lSDZiVadqGLr3H8eImMSC797nuN/vfPQEAt/Phe/hqdaM2
vOwjpoJwAVfE+EDmv3Hfb6RMYlZZNgY=
=sKtv
-----END PGP SIGNATURE-----

--qoTlaiD+Y2fIM3Ll--
