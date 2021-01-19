From: Dan Schatzberg <dschatzberg-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v2 0/2] cgroup: fix psi monitor for root cgroup
Date: Tue, 19 Jan 2021 16:46:44 +0000
Message-ID: <MN2PR15MB32937C185D521E6AEEFB4095D0A30@MN2PR15MB3293.namprd15.prod.outlook.com>
References: <20210116173634.1615875-1-odin@uged.al>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=My85n9gAnslKDRKKwaErn0o9lUBJOk3+wcNS9dC0CKA=;
 b=EZ2HVGcz7tRC9Aq51cishSr5in8FOaYh14rq05LW/xVQrqGzY/KdW2DB3WzO50Iilc/H
 6K454dHU69lI/bngMFXAsBMvIgFQhriMkDD2Z1kkHJi8OPQldq5nGMdfr3snGATLgT+x
 txgU8k4u7KvabmGXqfd1DnzihVPaRoYdx+4= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=My85n9gAnslKDRKKwaErn0o9lUBJOk3+wcNS9dC0CKA=;
 b=BaLHQMf0zTvqEIZCW2r1nsFLRY5cJ+TlhYGBOOLwYv8WaY8zxChdE1qzbP8AVdRcciiBvQ9bR1osavPxW0wWYTvtjiafrNDwDqx5Mdfg8TyBpgMEUOvo3qE/Mut22c5qO7QwJFVHw7x2x/iLnPvJ2RYEZr8G3hGiNr/CGGAs7jo=
In-Reply-To: <20210116173634.1615875-1-odin-RObV4cXtwVA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
Cc: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

> This patchset fixes PSI monitors on the root cgroup, as they currently=0A=
> only works on the non-root cgroups. Reading works for all, since that=0A=
> was fixed when adding support for the root PSI files. It also contains=0A=
> a doc update to reflect the current implementation.=0A=
> =0A=
> Changes since v1:=0A=
>=A0- Added Reviewed-by tag on the original patch (Suren)=0A=
>=A0- Updated patch title=0A=
>=A0- Added a separate patch to update doc=0A=
>=0A=
>=0A=
> Odin Ugedal (2):=0A=
>=A0 cgroup: fix psi monitor for root cgroup=0A=
>=A0 cgroup: update PSI file description in docs=0A=
>=0A=
>=A0Documentation/admin-guide/cgroup-v2.rst | 6 +++---=0A=
>=A0kernel/cgroup/cgroup.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 | 4 +++-=0A=
>=A02 files changed, 6 insertions(+), 4 deletions(-)=0A=
=0A=
Both patches look good.=0A=
=0A=
Acked-by: Dan Schatzberg <dschatzberg-b10kYP2dOMg@public.gmane.org>=
