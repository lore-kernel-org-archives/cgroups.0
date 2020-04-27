From: Roman Gushchin <guro@fb.com>
Subject: Re: memleak in cgroup
Date: Mon, 27 Apr 2020 10:24:21 -0700
Message-ID: <20200427172421.GA122591@carbon.DHCP.thefacebook.com>
References: <6e4d5208-ba26-93ed-c600-4776fc620456@huawei.com>
 <34dfdb52-6efd-7b11-07c8-9461a13b3aa4@huawei.com>
 <20200427171304.GC29022@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=GZ9GjamGT+A0A+SJhZXVkvpA+FGAIwEm1X+n/+7paQ0=;
 b=TCciwyKFyZMzT4+Eq4sazZg8gyQ+9vwxHjYTKSzWp4AmQUy7E9/nm/GALnbEUk10MmKZ
 GvDywdOra8XVimWVNdNc4arPAi9CgN3BX79umvH7/5hSOGWTR4PJGIkeXMdgPKyc6Avo
 61gQBm4NnfZ4gWMKhI+vERI8WGP7doc12xw= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2gIlpWB4No8dxSMwkkUhV0bsKH8iSUF+NgmE3bfR/uY=;
 b=TemQQlP10HZATr6CSH/csr4rxTb9xPx80gTHSM6FWB1Grtk7FFhUa1mmp8+ECPjT79FBgzwjxL1AVpQWnTZ3875QKF0z/wCAFyDLo8aO1yMaNqX63ZcGHlj4s2FqYD1OIzIhLjwMnkZrEVEnuo5V93enMWp4ThxfPl8JiyB5ij8=
Content-Disposition: inline
In-Reply-To: <20200427171304.GC29022@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yang Yingliang <yangyingliang@huawei.com>, tj@kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com, linux-mm@kvack.org, guro@cmpxchg.org

On Mon, Apr 27, 2020 at 01:13:04PM -0400, Johannes Weiner wrote:
> +cc Roman who has been looking the most at this area
>=20
> On Mon, Apr 27, 2020 at 03:48:13PM +0800, Yang Yingliang wrote:
> > +cc linux-mm@kvack.org <mailto:linux-mm@kvack.org>
> >=20
> > On 2020/4/26 19:21, Yang Yingliang wrote:
> > > Hi,
> > >=20
> > > When I doing the follow test in kernel-5.7-rc2, I found mem-free is
> > > decreased
> > >=20
> > > #!/bin/sh
> > > cd /sys/fs/cgroup/memory/
> > >=20
> > > for((i=3D0;i<45;i++))
> > > do
> > > =A0=A0=A0=A0=A0=A0=A0 for((j=3D0;j<60000;j++))
> > > =A0=A0=A0=A0=A0=A0=A0 do
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 mkdir /sys/fs/cgroup/me=
mory/yyl-cg$j
> > > =A0=A0=A0=A0=A0=A0=A0 done
> > > =A0=A0=A0=A0=A0=A0=A0 sleep 1
> > > =A0=A0=A0=A0=A0=A0=A0 ls /sys/fs/cgroup/memory/ | grep yyl | xargs rm=
dir
> > > done
>=20
> Should be easy enough to reproduce, thanks for the report. I'll try to
> take a look later this week, unless Roman beats me to it.
>=20
> Is this a new observation in 5.7-rc2?
>=20
> Can you provide /sys/fs/cgroup/unified/cgroup.stat after the test?

I'm actually trying to reproduce it now, but so far haven't found any issue=
s.

Yang, can you, please, attach the config you're using?

And also confirm that you're giving the system some time before looking
at the memory statistics? Reclaim of internal cgroup structure is a complex
process which might take some time to finish.

Is dmesg also clean?

Thanks!
