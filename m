From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v11 7/8] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Tue, 14 Jun 2022 13:53:45 +0200
Message-ID: <20220614115345.GA6771@blackbody.suse.cz>
References: <20220510153413.400020-1-longman@redhat.com>
 <20220510153413.400020-8-longman@redhat.com>
 <YqYnQ4U4t6j/3UaL@slm.duckdns.org>
 <404171dc-0da3-21f2-5003-9718f875e967@redhat.com>
 <YqarMyNo9oHxhZFh@slm.duckdns.org>
 <20220613142452.GB6910@blackbody.suse.cz>
 <YqdzuSQuAeiPXQvy@slm.duckdns.org>
 <20220613175548.GB21665@blackbody.suse.cz>
 <Yqd7WMFj6AEyV3Cy@slm.duckdns.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1655207627; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=enED3+mwpyEj3HYd1xYYpNVTbgUm7frMywot5/XVq7k=;
        b=MKNAdTBQZJDywcGSMhM7eKVDS9hIFTqkt9SPhb/KumTuThcjnWgew5g35qS1WfIN35FvMH
        +jmoTfwK7Sml47xjNTXbVEOEhtfUIjQJ3l2yz4rYR/B37fK1VH4zw9FonngffORHliRegZ
        t1BTLwB3rgE1pXUmN+ycYXWzqtGXp5U=
Content-Disposition: inline
In-Reply-To: <Yqd7WMFj6AEyV3Cy-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 13, 2022 at 08:00:56AM -1000, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Yeah, I don't know why this part is different from any other errors that the
> parent can make.

It's different because a write to parent's cpuset.cpus is independent of
whether cpuset.cpus of its children are exclusive or not.
In an extreme case the children may be non-exclusive

    parent	cpuset.cpus=0-3 //   valid partition
    `- child_1	cpuset.cpus=0-1	// invalid partition
    `- child_2	cpuset.cpus=1-2 // invalid partition

but the parent can still be a valid partition (thanks to cpu no. 3 in
the example above).

Do I miss anything?

Thanks,
Michal

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCYqh2xwAKCRAkDQmsBEOq
uYpOAQCf85csUj8650NOSj8/SYGx1Rke2TaokzgsJH1Dl9CDigD9GRFyEDBK4gUH
O3ICbyDSHByTv2ncDcIRjpX6QGMWSAM=
=mVZv
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
