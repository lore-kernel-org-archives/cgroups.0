From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: PROBLEM: cgroup cost too much memory when transfer small files
 to tmpfs
Date: Tue, 21 Jul 2020 11:49:59 -0700
Message-ID: <20200721184959.GA8266@carbon.DHCP.thefacebook.com>
References: <2E04DD7753BE0E4ABABF0B664610AD6F2620CAF7@dggeml528-mbx.china.huawei.com>
 <20200721174126.GA271870@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=4s+vd1Qc9vSJKOvGKojMsuSCa8vtZBJEKSLRiGpxA3w=;
 b=cDnJ+ovuuciqwx/l19WDmRARlx5xsi75yxvZ7+yvbHmqb5U7LFDS/e3MwwAcvsmrfvTd
 7xvnMf2aQ9AsFEXz/lpZN7ikZ3QQvODpYFEXZv/n0jCjdxIHmmnHjcZk+fJCSgslzgXR
 xSnIvQz498MfVUtpiDRSGufnOa+dp1sk2qg= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8M/cBuC1UyRRanrQRIl6K2fS1SHf26nXYrCdKmFdo1w=;
 b=eVR13tM6LmOUJtBI+kf7aLDL7nNl3ZWaG9CrWmDURhrh0/dCO7Iw/VvmvlBmw/d3vILOSa+EJbNV1nm4yp69su+sDf4y7W+GE6Gz7r8s5USmOT/9WGrxu2gxsdGBe+Yrt+/I53fqSesrhdlAIKkPmj6UqHNL5me5gl6cr0oI7X4=
Content-Disposition: inline
In-Reply-To: <20200721174126.GA271870-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: jingrui <jingrui-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Lizefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, caihaomin <caihaomin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Weiwei (N)" <wick.wei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, guro-druUgvl0LCNAfugRpC6u6w@public.gmane.org

On Tue, Jul 21, 2020 at 01:41:26PM -0400, Johannes Weiner wrote:
> On Tue, Jul 21, 2020 at 11:19:52AM +0000, jingrui wrote:
> > Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> ; =
Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>; Vladimir Dav=
ydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >=20
> > Thanks.
> >=20
> > ---
> > PROBLEM: cgroup cost too much memory when transfer small files to tmpfs.
> >=20
> > keywords: cgroup PERCPU/memory cost too much.
> >=20
> > description:
> >=20
> > We send small files from node-A to node-B tmpfs /tmp directory using sf=
tp. On
> > node-B the systemd configured with pam on like below.
> >=20
> > cat /etc/pam.d/password-auth | grep systemd
> > -session=A0=A0=A0=A0 optional=A0=A0=A0=A0=A0 pam_systemd.so
> >=20
> > So when transfer a file, a systemd session is created, that means a cgr=
oup is
> > created, then file saved at /tmp will associated with a cgroup object. =
After
> > file transferred, session and cgroup-dir will be removed, but the file =
in /tmp
> > still associated with the cgroup object. The PERCPU memory in cgroup/cs=
s object
> > cost a lot(about 0.5MB/per-cgroup-object) on 200/cpus machine.
>=20
> CC Roman who had a patch series to free all this extended (percpu)
> memory upon cgroup deletion:
>=20
> https://lore.kernel.org/patchwork/cover/1050508/
>=20
> It looks like it never got merged for some reason.

The mentioned patchset can make the problem less noticeable, but can't solv=
e it completely.
It has never been merged, because the dying cgroup problem was mostly solve=
d by other methods:
slab memory reparenting and various reclaim fixes. So there was no more rea=
son to complicate
the code to release the memcg memory early.

The overhead of creating and destroying a new memory cgroup for a transfer =
of a small
file will be noticeable anyway. So IMO the solution is to use a single cgro=
up for all
transfers. I don't know if systemd supports such mode out of the box, but i=
t shouldn't
be hard to add it.

But also I wonder if we need a special tmpfs mount option, something like "=
noaccount".
Not only for this specific case, but also for the case when tmpfs is extens=
ively
shared between multiple cgroups or if it's used to pass some data from one =
cgroup
to another, or if we care about the performance more than about the account=
ing;
in other words for cases where the accounting makes more harm than good.

Thanks!
