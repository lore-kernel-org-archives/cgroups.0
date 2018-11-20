From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v3 4/7] cgroup: cgroup v2 freezer
Date: Tue, 20 Nov 2018 16:43:52 +0000
Message-ID: <20181120164349.GB21462@tower.DHCP.thefacebook.com>
References: <20181117003830.15344-1-guro@fb.com>
 <20181117003830.15344-5-guro@fb.com>
 <20181120162529.GU2509588@devbig004.ftw2.facebook.com>
 <20181120163304.GA21462@tower.DHCP.thefacebook.com>
 <20181120163604.GX2509588@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ofVL+ggquv88hnR3uyRp1SYaszN31SFysNi2uYqIwVA=;
 b=VE/XxHYyonmm0hByt8o/fSkfRaa1cM8Jqb92Rds/+FJnfmPIHEhQVMGM/jBfhMHJmK/O
 BVd4YvppRl9ksYRfHCMITfup37DRpK6OQUTicePJ4ch88TbJ0ZjrFWd2JQ8onwqUkbsB
 U4tC0wuckpzm+w5no2BnWCdy0zfzC3/qnIg= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ofVL+ggquv88hnR3uyRp1SYaszN31SFysNi2uYqIwVA=;
 b=dt7sULZfEnlppAKSWl6Wd5TH1yNycNSWopbdmN81z9L+PV9QePm/QonSIc3wJTQAYUfv9rHyHu0KHiEtmHVYYyBd6S8KckD7LnJZydwaV2xzhFUDUdX9nx4y8+YzDpnxuxV7pdN2TEhnitKEGshVyj+3Jzu8Kk+LyvhgWo2Q+f0=
In-Reply-To: <20181120163604.GX2509588@devbig004.ftw2.facebook.com>
Content-Language: en-US
Content-ID: <5BDF97299AA57540AA815ECADEB34026@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guroan@gmail.com>, Oleg Nesterov <oleg@redhat.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Tue, Nov 20, 2018 at 08:36:04AM -0800, Tejun Heo wrote:
> On Tue, Nov 20, 2018 at 04:33:11PM +0000, Roman Gushchin wrote:
> > > If a non-frozen task is being moved into a frozen cgroup, shouldn't
> > > that also trigger frozen state update?
> >=20
> > It does! Just below these lines:
> >=20
> > 	/*
> > 	 * If the task isn't in the desired state, force it to it.
> > 	 */
> > 	if (task->frozen !=3D test_bit(CGRP_FREEZE, &dst->flags))
> > 		cgroup_freeze_task(task, test_bit(CGRP_FREEZE, &dst->flags));
>=20
> But that wouldn't udpate the cgroup's frozen state and generate
> notifications, right?

Why? The task will be eventually trapped into cgroup_enter_frozen(),
and from there cgroup_update_frozen() will be called.

You are right, that notification will not be issued, because the cgroup
is not changing its state (frozen->frozen). I'm not sure that it makes
sense to change the cgroup state back and forth in this case. Are there
any reasons I'm missing?

Thanks!
