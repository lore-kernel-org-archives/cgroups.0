From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH] cgroup/pids: Make pids.events notifications affine
 to pids.max
Date: Mon, 2 Dec 2019 11:11:00 -0800
Message-ID: <20191202191100.GF16681@devbig004.ftw2.facebook.com>
References: <20191128172612.10259-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=Cwz6dYY9z4DxZQ5/f+vTSU4IwIt72HsTGUbyi+vmDkI=;
        b=eHpXuxnoiIv7Vq2GQyfaaWZbunEntyK6amEKPxAgDXh2F7i6pgY5JOrOxmRYBWA/bK
         SLP1DHchXwPfowdj5JvhSMqHWJ7QFOLj7S2hSIL6q74qGRvBlMbVhdd4v4Zy4ytfu78z
         UeCcDaZGD86MzV5eApmB6/1ivXULShR+kN92UZjAxReIvbkora7ad9nnH48Ft6hy1IGB
         olUfx22vze29Uq/6Ds41WgDpod/ax0ksHshy1zaH+DEUGhmxJeAa06AQaEhB2fDCukYe
         htwTeqMbepZamefzWks0AUPXeBloI9/BFb2Y472dRAJOIRWU41rsOUmWavuiJf9QETF5
         H6eg==
Content-Disposition: inline
In-Reply-To: <20191128172612.10259-1-mkoutny@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org

Hello,

On Thu, Nov 28, 2019 at 06:26:12PM +0100, Michal Koutn=FD wrote:
> Currently, when pids.max limit is breached in the hierarchy, the event
> is counted and reported in the cgroup where the forking task resides.
>=20
> The proper hierarchical behavior is to count and report the event in the
> cgroup whose limit is being exceeded. Apply this behavior in the default
> hierarchy.
>=20
> Reasons for RFC:
>=20
> 1) If anyone has adjusted their readings to this behavior, this is a BC
>    break.
>=20
> 2) This solves no reported bug, just a spotted inconsistency.
>=20
> 3) One step further would be to distinguish pids.events and
>    pids.events.local for proper hierarchical counting. (The current
>    behavior wouldn't match neither though.)

Yeah this is incosistent with memcg but there max / high events are
essentially useless because that doesn't indicate actual limit breach.
Both events are interesting - which cgroup's limit was reached and who
suffered because of that.

So, maybe sth like the following?

1. Make max event propagate hierarchically.  This is a behavior change
   but also an obvious bug fix.  Given that internal cgroups don't
   have processes in cgroup2, maybe it's safe enough?

2. Add another (hierarchical, of course) event which counts the number
   of fork rejects.  I can't think of a good name.  Any ideas?

Thanks.

--=20
tejun
