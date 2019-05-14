From: Roman Gushchin <guro@fb.com>
Subject: Re: WARNING: CPU: 1 PID: 228 at kernel/cgroup/cgroup.c:5929
Date: Tue, 14 May 2019 20:05:57 +0000
Message-ID: <20190514200553.GF12629@tower.DHCP.thefacebook.com>
References: <CAGnkfhwMSNm4uSkcGtqaGmYanfNK9rx6m2a3TqJh08YitbGAUg@mail.gmail.com>
 <20190514194249.GD12629@tower.DHCP.thefacebook.com>
 <CAGnkfhxwP1SwJLv2E-6Xd7ZXN8XUPRyXkM=tB0Z=jre8Rij6=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=nAvEob6Kh3imkf/jkDHpX8X0Pv+7hR1jBzS4jh+zXhg=;
 b=AI5EJ0PjpAn0WpxTLN4yXat5kceFTVPe7QaKQSJeQLv8uUNNdNQZIJqVr6UZaWzI9dFm
 VxH/gcc6bONw8F2UGlH0D/sRTGu/aASdOcAcl/X/FnztKflroV2fvLst8udTFyLPoGLr
 LX79H+IScBBo8JyPglVk7qDPiQHfUrtNNSc= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nAvEob6Kh3imkf/jkDHpX8X0Pv+7hR1jBzS4jh+zXhg=;
 b=OFGnSFKLrl+vrJLTNfKuPeI79meaMHFTGvGreLRTu9AxVUvwFoqcqodm+DOU+YBLVviolmiKV1bCPNjqULA8HQtTR+uBKREv92/oRH4UlEL7E+SaDYUNumUA3u/mxw4fzyRnYHQ3QvzYID56b93g0K+Digjr33OcU6ryT3vIFCQ=
In-Reply-To: <CAGnkfhxwP1SwJLv2E-6Xd7ZXN8XUPRyXkM=tB0Z=jre8Rij6=A@mail.gmail.com>
Content-Language: en-US
Content-ID: <84E68961D69B6B4FB14640807D9BDB97@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Matteo Croce <mcroce@redhat.com>
Cc: "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>

On Tue, May 14, 2019 at 09:54:46PM +0200, Matteo Croce wrote:
> Hi Roman,
>=20
> yes, this one fixes it.
>=20
> --=20
> Matteo Croce
> per aspera ad upstream

Thank you for the confirmation!

The patch will be merged upstream soon.

Thanks!
