From: Roman Gushchin <guro@fb.com>
Subject: Re: memleak in cgroup
Date: Tue, 28 Apr 2020 10:45:37 -0700
Message-ID: <20200428174537.GB158422@carbon.dhcp.thefacebook.com>
References: <6e4d5208-ba26-93ed-c600-4776fc620456@huawei.com>
 <34dfdb52-6efd-7b11-07c8-9461a13b3aa4@huawei.com>
 <20200427171304.GC29022@cmpxchg.org>
 <20200427172421.GA122591@carbon.DHCP.thefacebook.com>
 <abc222e3-7038-fa4e-f18d-70ba20f11568@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=19VCB1U7MfltrLcG2fRJbhVIWCe9VJtdiRq/m/MQcFk=;
 b=Zc35tzDOkgJIhNLBgPiidyBt8SRoV5/gX2sWBNqD3loA+eAiD84j3DesSIWvjXGc/im6
 gvd/KV05+mmwCB4kwZeHsmkOSJ3Lhiqs5Hfvd+cMi5YNwgMUrQblNFOgZ6aXoQyRhpmg
 jpB39i0NqEqpp8aTF9QbW++qGKG0MNGejgw= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wzQu7Uku13xgVHfcVqPVs/ZKDW2m8DxVCYxXRsM3q98=;
 b=gO/S3PjqK34q9eTAJyYzgfv8Yep0sRRXD3wYFUfcMWfn+ecum4CJp/+6sjtjms9+jjI47PGZ497pWT0ahdmFWY1dXprKu4f8uxvLUWshT3A3SvHpbwCYY/IyNC8dlquWC/9NiCC0pNLPu2uTIad7cApCh5PD6+jKrRJ/R2I+BiM=
Content-Disposition: inline
In-Reply-To: <abc222e3-7038-fa4e-f18d-70ba20f11568@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Yang Yingliang <yangyingliang@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, tj@kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com, linux-mm@kvack.org, guro@cmpxchg.org

On Tue, Apr 28, 2020 at 05:10:33PM +0800, Yang Yingliang wrote:
> Hi,
>=20
> On 2020/4/28 1:24, Roman Gushchin wrote:
> > On Mon, Apr 27, 2020 at 01:13:04PM -0400, Johannes Weiner wrote:
> > > +cc Roman who has been looking the most at this area
> > >=20
> > > On Mon, Apr 27, 2020 at 03:48:13PM +0800, Yang Yingliang wrote:
> > > > +cc linux-mm@kvack.org <mailto:linux-mm@kvack.org>
> > > >=20
> > > > On 2020/4/26 19:21, Yang Yingliang wrote:
> > > > > Hi,
> > > > >=20
> > > > > When I doing the follow test in kernel-5.7-rc2, I found mem-free =
is
> > > > > decreased
> > > > >=20
> > > > > #!/bin/sh
> > > > > cd /sys/fs/cgroup/memory/
> > > > >=20
> > > > > for((i=3D0;i<45;i++))
> > > > > do
> > > > >  =A0=A0=A0=A0=A0=A0=A0 for((j=3D0;j<60000;j++))
> > > > >  =A0=A0=A0=A0=A0=A0=A0 do
> > > > >  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 mkdir /sys/fs/cgro=
up/memory/yyl-cg$j
> > > > >  =A0=A0=A0=A0=A0=A0=A0 done
> > > > >  =A0=A0=A0=A0=A0=A0=A0 sleep 1
> > > > >  =A0=A0=A0=A0=A0=A0=A0 ls /sys/fs/cgroup/memory/ | grep yyl | xar=
gs rmdir
> > > > > done
> > > Should be easy enough to reproduce, thanks for the report. I'll try to
> > > take a look later this week, unless Roman beats me to it.
> > >=20
> > > Is this a new observation in 5.7-rc2?
> > >=20
> > > Can you provide /sys/fs/cgroup/unified/cgroup.stat after the test?
> I re-tested in 5.7-rc3, it has same problem and the
> /sys/fs/cgroup/unified/cgroup.stat afther test is:
>=20
> nr_descendants 50
> nr_dying_descendants 0
>=20
> > I'm actually trying to reproduce it now, but so far haven't found any i=
ssues.
> >=20
> > Yang, can you, please, attach the config you're using?
> >=20
> > And also confirm that you're giving the system some time before looking
> > at the memory statistics? Reclaim of internal cgroup structure is a com=
plex
> > process which might take some time to finish.
> >=20
> > Is dmesg also clean?
> config and dmesg are attached.

Interesting...

I've tried hard to reproduce, but haven't managed to get anything so far.
You've a huge machine with a non-trivial hardware setup (e.g. those cpuset =
warnings
in dmesg), so there must be something special about it. Could be anything:
percpu, rcu, some incorrectly handled ENOMEM case.

I've several questions, which might help the investigation:
1) Is there any known good revision, which doesn't leak?
2) Can you, please, check that all those cgroups were actually created? I m=
ean
   if some mkdir calls returned an error, it could be a huge hint for us
   where to look.
3) Can you, please, dump /proc/slabinfo before and after the experiment?
4) Can you, please, repeat the experiment creating cgroups in /sys/fs/cgrou=
p/unified
   instead of /sys/fs/cgroup/memory ?
5) If you're familiar with bcc tools (https://github.com/iovisor/bcc), can =
you, please,
   run memleak.py during the experiment?

Thank you!
