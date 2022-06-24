From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH mm v5 0/9] memcg: accounting for objects allocated by
 mkdir, cgroup
Date: Fri, 24 Jun 2022 14:26:10 +0200
Message-ID: <20220624122610.GG16004@blackbody.suse.cz>
References: <4e685057-b07d-745d-fdaa-1a6a5a681060@openvz.org>
 <0fe836b4-5c0f-0e32-d511-db816d359748@openvz.org>
 <c516033f-a9e4-3485-26d9-a68afa694c1d@openvz.org>
 <YrSP25ebDmXE+kPS@dhcp22.suse.cz>
 <CALvZod4WsmrpfZtfnP4AmvtnkvBRngXXGyhM6+aQzkdfjsinAQ@mail.gmail.com>
 <0f8146e3-5865-b7e6-6728-5baada375cf2@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="HG+GLK89HZ1zG0kk"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1656073571; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+3cWh7Nkfv7QaM5e4ajRtU4xW3swpukjf7WrfRWPE6E=;
        b=mrYLsPoEEQjRnhUtwsgNCoXCtrKNyvFVbXRqAwPxnnjWRxGMXjfszLzHbhAFKwx+uBW8CZ
        yuxjkWUMBCdNt+cgyQoLNqirpOBMsxu9PydMYcuN5QwltNVl12wnAOqK/fInVpSJGV7Mty
        XPJvhw0hfSqQTdSlEe9+UkTfFT9IMi4=
Content-Disposition: inline
In-Reply-To: <0f8146e3-5865-b7e6-6728-5baada375cf2-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


--HG+GLK89HZ1zG0kk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 24, 2022 at 01:40:14PM +0300, Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
> Btw could you please explain why memory cgroups have MEM_CGROUP_ID_MAX limit
> Why it is required at all and why it was set to USHRT_MAX? I believe that
> in the future it may be really reachable:

IIRC, one reason is 2B * nr_swap_pages of memory overhead (in
swap_cgroup_swapon()) that's ~0.05% of swap space occupied additionally
in RAM (fortunately swap needn't cover whole RAM).

HTH,
Michal

--HG+GLK89HZ1zG0kk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCYrWtXgAKCRAkDQmsBEOq
uTryAQCHh6ZZYDD+j5lciUOhDxLFMQ15T9S7Ty/OmIhNzCcXwwD/YhFGF7ylqaSv
BYyT9akQtqnK5O1l1tmp4Hp0oIkmMAs=
=mx99
-----END PGP SIGNATURE-----

--HG+GLK89HZ1zG0kk--
