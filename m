From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v11 7/8] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Mon, 13 Jun 2022 08:00:56 -1000
Message-ID: <Yqd7WMFj6AEyV3Cy@slm.duckdns.org>
References: <20220510153413.400020-1-longman@redhat.com>
 <20220510153413.400020-8-longman@redhat.com>
 <YqYnQ4U4t6j/3UaL@slm.duckdns.org>
 <404171dc-0da3-21f2-5003-9718f875e967@redhat.com>
 <YqarMyNo9oHxhZFh@slm.duckdns.org>
 <20220613142452.GB6910@blackbody.suse.cz>
 <YqdzuSQuAeiPXQvy@slm.duckdns.org>
 <20220613175548.GB21665@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=jM/lvPuhC14LsEb9ZlEVVzCAu03nvQX/OUwWLzY69FM=;
        b=RYsqMVjNGft/mA4IooAZRbob/vH4Mo9pz2WNFRyPqpKB7ZI7v1N453mnVzkf2rwPf1
         2DsXUtAIOlbcJLG3RIesO2Cdl6+9dakwiWAYxMykcvkwKXxD2WESsQkWF+1tQYobZWhk
         k4A5cBm4QluwxzMC9yB+NGTJm+pGk1ifFlSqDfI+Nrc66JDGkXlKEWLsX3IbUIMsiBii
         uv55sk99KqDJPXyni0G8/7szT3++WIpQUjJPWsSMB182M/JK5oeX9kXYbLI8LD0qJB1n
         eusYcktRqkfvzZvIuxjXerxetX1ofNtrhkAYkRsKWPYwOEROIbU39S1v7uNxwOoVg8Zx
         GhqQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220613175548.GB21665-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello,

On Mon, Jun 13, 2022 at 07:55:49PM +0200, Michal Koutn=FD wrote:
> On Mon, Jun 13, 2022 at 07:28:25AM -1000, Tejun Heo <tj-DgEjT+Ai2ygdnm+yR=
OfE0A@public.gmane.org> wrote:
> > I see. Is this part even necessary? All the .cpus files of the siblings=
 are
> > owned by the parent who's responsible for configuring both the mode tha=
t the
> > cgroup subtree is gonna be in and their cpumasks.=20
>=20
> Do you mean such an example:
>=20
>     parent	cpuset.cpus=3DSET (root)	cpuset.cpus.partition=3Disolated=20
>     `- child_1	cpuset.cpus=3Dpartition_of(SET) (root)	cpuset.cpus.partiti=
on=3Disolated
>     `- ...
>     `- child_n	cpuset.cpus=3Dpartition_of(SET) (root)	cpuset.cpus.partiti=
on=3Disolated
> ?
>=20
> I don't think child_*/cpuset.cpus must be owned by root.

I meant the parent.

> Actually, the root would only configure the parent, i.e.
> parent/cpuset.cpus (whose changes would be disallowed to the
> unprivileged tasks) and the distribution among siblings would up to the
> whatever runs below.
>=20
> > Given that all the other errors it can make are notified through
> > "invalid (REASON)" in the mode file, wouldn't it fit better to notify
> > cpus configuration error the same way too?
>=20
> Do you suggest that a write into child_*/cpuset.cpus that'd not be
> exclusive wrt a sibling would result in an error string in
> parent/cpuset.cpus.partition?

Yeah, I don't know why this part is different from any other errors that the
parent can make.

Thanks.

--=20
tejun
