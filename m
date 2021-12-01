From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v8 5/6] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Wed, 1 Dec 2021 15:13:50 +0100
Message-ID: <20211201141350.GA54766@blackbody.suse.cz>
References: <20211018143619.205065-1-longman@redhat.com>
 <20211018143619.205065-6-longman@redhat.com>
 <20211115193122.GA16798@blackbody.suse.cz>
 <8f68692b-bd8f-33fd-44ae-f6f83bf2dc00@redhat.com>
 <20211116175411.GA50019@blackbody.suse.cz>
 <293d7abf-aff6-fcd8-c999-b1dbda1cffb8@redhat.com>
 <YaZbXArNIMNvwJD/@slm.duckdns.org>
 <2347fe66-dc68-6d58-e63b-7ed2b8077b48@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1638368032; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fOp73N+RHazrUHrc9GoZ30ZU9IWHl5ZMpNXXLtab7Ck=;
        b=lOHMSLqwKO+hgmrKd7CP5mHIPjlZyI7Yhk3rECaCnHJucYwQY1IISq5BFNr5YqK8OCiDtx
        UnLW2QK4RtUKX76MkQl45OMKHugvm4ZRw70Ao4+17ONC1TViG+SsGNtrqDvdZXELnr2Y/A
        zUsTJ5dJQYy+Av+smN+1VCWSjjlwxkQ=
Content-Disposition: inline
In-Reply-To: <2347fe66-dc68-6d58-e63b-7ed2b8077b48-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 30, 2021 at 10:56:34PM -0500, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
> > >  =A0=A0 =A0A valid parent partition may distribute out all its CPUs to
> > >  =A0=A0 =A0its child partitions as long as it is not the root cgroup =
and
> > >  =A0=A0 =A0there is no task associated with it.
> > A valid parent partition which isn't root never has tasks in them to be=
gin
> > with.
> I believe there is some corner cases where it is possible to put task in =
an
> intermediate partition. That is why I put down this statement.

Just mind the threads -- cpuset controller is threaded and having tasks
in inner cgroup nodes is a real scenario. I wouldn't consider it a
corner case.

[ Actually, the paragraph could IMO be simplified:

> A valid parent partition may distribute out all its CPUs to
>=A0its child partitions as long as there is no task associated with it.

Assuming there's always at least one kernel thread in the root cgroup
that can't be migrated anyway.]


Michal

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTiq06H1IhXbF2mqzsiXqxkP0JkRwUCYaeDFQAKCRAiXqxkP0Jk
RwNCAP97/71glMvylTDowYwhdI5KleBFVwxoUX0JYOli5Z1++gD/VWelsoQUVWOo
1YdBl5Ei0UknFyqYHDcKnBbttGx1hQM=
=h6LI
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
