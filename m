From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] cgroup: use kv(malloc|free) instead of
 pidlist_(allocate|free)
Date: Mon, 9 Sep 2019 16:23:38 +0000
Message-ID: <20190909162333.GA8571@tower.dhcp.thefacebook.com>
References: <20190908144041.19667-1-insafonov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=m/+u36wyBdJNgYpeuMX8Bk/u91XmjHB9gZiyi7/IxXk=;
 b=DGSmxlg0ivDhney3HH603x02F4rWpPqa7jDUV095V+eM4fwK7KOLAfllr6/ATr1BYSVd
 Ic8hvBXuXsSzEJBPDJXbYsaBv4nN1Hc8HmdDCeEcaRZdMRqGSS93o9CMytRJIqq8aPkJ
 AJouNGGa4tYqLJykb6rH+sxzrqb1hYiVicA= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m/+u36wyBdJNgYpeuMX8Bk/u91XmjHB9gZiyi7/IxXk=;
 b=PwZO/p4kQfRAep7egQlDvK3iqZyNv9M023X5cuQy4/hdgPyuHUdawsxN04FlKcDUwI9zSbqQe8PIuNJhzQudXQc8Z0L5NINE2/aSYO5uXqXesz5/NGsMT0jIcw4L9iJPa9dFC/Vf2539w8Nc5p3Jaqb5dpkIBMf535HL3PXBXRk=
In-Reply-To: <20190908144041.19667-1-insafonov@gmail.com>
Content-Language: en-US
Content-ID: <627F6A5E88B2754E875DE38D7C361586@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Ivan Safonov <insafonov@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Sun, Sep 08, 2019 at 05:40:41PM +0300, Ivan Safonov wrote:
> Resolve TODO:
> > The following two functions "fix" the issue where there are more pids
> > than kmalloc will give memory for; in such cases, we use vmalloc/vfree.
> > TODO: replace with a kernel-wide solution to this problem
>=20
> kv(malloc|free) is appropriate replacement for pidlist_(allocate|free).
>=20
> Signed-off-by: Ivan Safonov <insafonov@gmail.com>

Looks good to me!

Acked-by: Roman Gushchin <guro@fb.com>

Thanks!
