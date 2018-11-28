From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v2 3/6] cgroup: cgroup v2 freezer
Date: Wed, 28 Nov 2018 17:36:28 +0000
Message-ID: <20181128173622.GA22882@tower.DHCP.thefacebook.com>
References: <20181112230422.5911-1-guro@fb.com>
 <20181112230422.5911-5-guro@fb.com> <20181113154825.GC30990@redhat.com>
 <20181113215919.GC15590@tower.DHCP.thefacebook.com>
 <20181114165631.GE13885@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=OCGIgRcpxduPNPXad1ZkrGVGa7pcF5jdEdemT6YgYeM=;
 b=NXeryYgftpXETazZz3U4/MweNGRj1sf5NoMYkOuhQVAJvFD1PsLyxj5mdSojgkH/HJdl
 PWvgFOJyNDJkA7ot63U4EI2TcsrjkzcQqPKWcdXYYkrmnaxQfdE5bpQX+2pf8ls0LDes
 uYe9wYL83OYgpOaIfwr9+Zqh7aTqBryI4z8= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OCGIgRcpxduPNPXad1ZkrGVGa7pcF5jdEdemT6YgYeM=;
 b=f0Op8P/OhT03Dkhqm0ZOhUDnvOZdPJsV6aJK7Y2OBCRhrCLE+5Mkh7kLUHGf5L0z68piaCto3OAsWQA53ieptf93rrsmxaKv2rABpmXW4XJQggTx4RwLcd2v0PYPxItGAjnRPU87tkgaSo/EjmCGTmhkdUdAZgUAWsnzEqgp1nY=
In-Reply-To: <20181114165631.GE13885@redhat.com>
Content-Language: en-US
Content-ID: <622259CAEDB0B143B8C259C3B9CAC130@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Wed, Nov 14, 2018 at 05:56:32PM +0100, Oleg Nesterov wrote:
> Hi Roman,
>=20
> OK, it seems you are going to make the new version anyway, so I can wait =
for it
> and not read this series ;)

Hi Oleg!

Can you, please, take a look at v3, which I posted recently?
https://lkml.org/lkml/2018/11/17/193

Thank you!
