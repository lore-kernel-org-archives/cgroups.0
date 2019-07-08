From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] cgroup: minor tweak for logic to get cgroup css
Date: Mon, 8 Jul 2019 17:29:49 +0000
Message-ID: <20190708172944.GA24662@tower.DHCP.thefacebook.com>
References: <20190703020749.22988-1-rocking@whu.edu.cn>
 <20190708164243.GE657710@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=x56FKSBgXOLvZMD+y3raguvfgHanfiop/tmf7yxKJYY=;
 b=YtjbrlQZ1KnjfbBOiHBpCkWxxlXu0WZ8e8LiV2iz/QSCTRBX4nOUMYB1ARsvrYmEaTRQ
 rohnfxxdCKGBlpzne6+IQ0oP6YNIxYdoOSWPtQn2yV5X4FDQcyXgr5Ht6XDT6Azpw+Fn
 x397Fd9PX3m85t6LqvHpus3MORRFLAId9l8= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x56FKSBgXOLvZMD+y3raguvfgHanfiop/tmf7yxKJYY=;
 b=J72ID1e6yEPH/JQFvABF23eQcysYppP2uH5TKtl3nY3p/kNHZbyJ1ycd43oO93NckS3ZJNg1wu22xcpawtqMjlm2m+bS2jLv2Q+/k08LNz/ZukYuOO0FYMV/uiRygmzMJFLGYx6tOjwVzmeFOBlgwPfaPVSlEXyYU+tf7qXWcds=
In-Reply-To: <20190708164243.GE657710@devbig004.ftw2.facebook.com>
Content-Language: en-US
Content-ID: <1CF7146E8EDAE740858C66A1B5C99F4E@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Peng Wang <rocking@whu.edu.cn>, "lizefan@huawei.com" <lizefan@huawei.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Mon, Jul 08, 2019 at 09:42:43AM -0700, Tejun Heo wrote:
> On Wed, Jul 03, 2019 at 10:07:49AM +0800, Peng Wang wrote:
> > We could only handle the case that css exists
> > and css_try_get_online() fails.
>=20
> As css_tryget_online() can't handle NULL input, this is a bug fix.
> Can you please clarify that in the description?

-       if (!css || !css_tryget_online(css))
+       if (css && !css_tryget_online(css))

If css =3D=3D NULL, !css is true, and the second part of the || statement
will not be evaluated. So it's not a bug fix.

Thanks!
