From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v1 0/7] mm/memcontrol: recharge mlocked pages
Date: Wed, 4 Sep 2019 23:13:54 +0000
Message-ID: <20190904231350.GA5246@tower.dhcp.thefacebook.com>
References: <156760509382.6560.17364256340940314860.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=4Ul75V30fqg4tJL6AUehuDGJapCIoB5ZrB+HTS8LLpk=;
 b=pJ2gHKdGifN8CNjgU7HV5nuCIIzfX11XJlKcHZM1ax6ypV1uSDfZ0+MCD639VYr9SaI5
 Q8ffYW1o3OYG1MEZx+arnhT12sHPGBLXg9+H6e7nya15X2AORb+HugoAUORjVRJedbLm
 gPixdCfnK5QjfNCWIvchAjgFmqoMj4Jcy0E= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Ul75V30fqg4tJL6AUehuDGJapCIoB5ZrB+HTS8LLpk=;
 b=ijbRmKJisfWxcyzK5Y351mYbicHFxusReORY87YCZb366NVHVOckZpGPneVHegf1M9DI0Y/cRefOlTKhb8SxOd6oWeuAhy6q/O9at8kBTDNpwmZcRQUM4Y5UmyHY4ySvJeKFe27cuZcI6vNYqmgUpBJGQYiVt1+MgZtFzWULsNQ=
In-Reply-To: <156760509382.6560.17364256340940314860.stgit@buzz>
Content-Language: en-US
Content-ID: <59294D3005729C4181703E55A0E5DA85@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>

On Wed, Sep 04, 2019 at 04:53:08PM +0300, Konstantin Khlebnikov wrote:
> Currently mlock keeps pages in cgroups where they were accounted.
> This way one container could affect another if they share file cache.
> Typical case is writing (downloading) file in one container and then
> locking in another. After that first container cannot get rid of cache.

Yeah, it's a valid problem, and it's not about mlocked pages only,
the same thing is true for generic pagecache. The only difference is that
in theory memory pressure should fix everything. But in reality
pagecache used by the second container can be very hot, so the first
once can't really get rid of it.
In other words, there is no way to pass a pagecache page between cgroups
without evicting it and re-reading from a storage, which is sub-optimal
in many cases.

We thought about new madvise(), which will uncharge pagecache but set
a new page flag, which will mean something like "whoever first starts using
the page, should be charged for it". But it never materialized in a patchse=
t.

> Also removed cgroup stays pinned by these mlocked pages.

Tbh, I don't think it's a big issue here. If only there is a huge number
of 1-page sized mlock areas, but this seems to be unlikely.

>=20
> This patchset implements recharging pages to cgroup of mlock user.
>=20
> There are three cases:
> * recharging at first mlock
> * recharging at munlock to any remaining mlock
> * recharging at 'culling' in reclaimer to any existing mlock
>=20
> To keep things simple recharging ignores memory limit. After that memory
> usage temporary could be higher than limit but cgroup will reclaim memory
> later or trigger oom, which is valid outcome when somebody mlock too much=
.

OOM is a concern here. If quitting an application will cause an immediate O=
OM
in an other cgroup, that's not so good. Ideally it should work like
memory.high, forcing all threads in the second cgroup into direct reclaim.

Thanks!
