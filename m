From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/5] Optimize single thread migration
Date: Mon, 7 Oct 2019 07:12:24 -0700
Message-ID: <20191007141224.GD3404308@devbig004.ftw2.facebook.com>
References: <20191004105743.363-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=PJgpiGwK2u8oGo+/mbFwzQEWjjSrhtsq1rT3sToNXug=;
        b=D3EPjAtHnXMj06oi4eFAESMOwlvhVr1brLGRpLfMw3+ot0vTbafp3rijEo/vvXOHKw
         +U+I2Hk8Xv50JgEYWP5pi/6IaHdw/2NxvBdBbt5UOu9GDay5d01B6eNobiwqKgRq16ZX
         yp/F2nHltzuMp1iDStX+sTlD/mtz+REv6t8jnMZhDRvyrTUd6KvD0t4UJaUEt8z72+Oc
         9dAZsozshBuhPj3MaI6l+tJZrVAsVw4S/HYF4Dc9bVRDW7lMorMffRtRBNgnyrBQC8XR
         j8/UB1qKysjRxb4ep6pE6FUAP4Yf146BcIX+PX03d7LaMAGxHxJRfaskU4nWftebkEZk
         GPHg==
Content-Disposition: inline
In-Reply-To: <20191004105743.363-1-mkoutny@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>

On Fri, Oct 04, 2019 at 12:57:38PM +0200, Michal Koutn=FD wrote:
> Hello.
>=20
> The important part is the patch 02 where the reasoning is.
>=20
> The rest is mostly auxiliar and split out into separate commits for
> better readability.
>=20
> The patches are based on v5.3.=20

This is great.  Applied to the series to cgroup/for-5.5

Thanks!

--=20
tejun
