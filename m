From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 4/4] cgroup/bpf: Honor cgroup NS in cgroup_iter for
 ancestors
Date: Mon, 29 Aug 2022 14:59:57 +0200
Message-ID: <20220829125957.GB3579@blackbody.suse.cz>
References: <20220826165238.30915-1-mkoutny@suse.com>
 <20220826165238.30915-5-mkoutny@suse.com>
 <CAJD7tkZZ6j6mPfwwFDy_ModYux5447HFP=oPwa6MFA_NYAZ9-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661777998; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sSRqVVn5SCoLVeckWTZ5Gj/nBtXDD5MTT0sRUoTFBiw=;
        b=UqKZNoswzkT4opbT0CFX0E2k4fxB6asNd34TQMJiKraxmyY5Oy62NiBcyrPldyXJ7KDJHR
        7Wzx8mJy2LXH7P8HqiXtIjspI2kHyviaLuibhQeNTELPHHnPMRqkdbRM750kNErG6GV8Br
        EgX2s0bkY6Ph0Hv59W0uEeHHnYScYaw=
Content-Disposition: inline
In-Reply-To: <CAJD7tkZZ6j6mPfwwFDy_ModYux5447HFP=oPwa6MFA_NYAZ9-g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Muneendra Kumar <muneendra.kumar-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 26, 2022 at 10:41:37AM -0700, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> I understand that currently cgroup_iter is the only user of this, but
> for future use cases, is it safe to assume that cgrp will always be
> inside ns? Would it be safer to do something like:

I preferred the simpler root_cgrp comparison to avoid pointer
arithmetics in cgroup_is_descendant. But I also made the assumption of
cgrp in ns.

Thanks, I'll likely adjust cgroup_path_ns to make it more robust for
an external cgrp.


I'd like to clarify, if a process A in a broad cgroup ns sets up a BPF
cgroup iterator, exposes it via bpffs and than a process B in a narrowed
cgroup ns (which excludes the origin cgroup) wants to traverse the
iterator, should it fail straight ahead (regardless of iter order)?
The alternative would be to allow self-dereference but prohibit any
iterator moves (regardless of order).


Thanks,
Michal

--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCYwy4SQAKCRAkDQmsBEOq
uZX4AQDqrzGBoULhzyvm8GveGTXVJYAupuXli8zU2n5T8KXI1wEA/d5JS9XKNwTR
qMIafR6at0V6U72iM2jn2OX84ZgiKgk=
=auEQ
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--
