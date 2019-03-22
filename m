From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH REBASED] mm, memcg: Make scan aggression always exclude
 protection
Date: Fri, 22 Mar 2019 23:01:02 +0000
Message-ID: <20190322230054.GA11625@tower.DHCP.thefacebook.com>
References: <20190228213050.GA28211@chrisdown.name>
 <20190322160307.GA3316@chrisdown.name>
 <20190322222907.GA17496@tower.DHCP.thefacebook.com>
 <20190322224946.GA12527@chrisdown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=fa+tMZG2kBtBSTSbDQRVIvcUjPD1/3k13sgEyM6tr2s=;
 b=m+dyKmDO1DNtCA3BIDm0x1kgypByM+wKW0iN8wLwScUJULe5v3prnUWNk84jpIPUI/ei
 f8b814nraklXSFC7oT3Ii0gYwRZVxKNkEHcAmDRBU96jTF6V46m5aUqsF0U0x4lki5z0
 GRDnjzPwOC53f4GZWjefQXqXOz9+698CbVk= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fa+tMZG2kBtBSTSbDQRVIvcUjPD1/3k13sgEyM6tr2s=;
 b=ThIKySIDLaX9uORRfhaE9MTVCrFtE146gMvsKVRB1oeoYZQv+Nr8Ditjf023OrpvHuHGS+jkp3Y42Rkt4IFfJuMEsVwDAJEXs3Xh6bWZ2pTFeNo4M5BR/1QHyuz4JuYuNAfkB3mC0B0lLXRId6p4wZBa8Ml0t+QGS2MGr6akaeo=
In-Reply-To: <20190322224946.GA12527@chrisdown.name>
Content-Language: en-US
Content-ID: <3094D3D488845C44BF820DA1A4FFFC13@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Kernel Team <Kernel-team@fb.com>

On Fri, Mar 22, 2019 at 10:49:46PM +0000, Chris Down wrote:
> Roman Gushchin writes:
> > I've noticed that the old version is just wrong: if cgroup_size is way =
smaller
> > than max(min, low), scan will be set to -lruvec_size.
> > Given that it's unsigned long, we'll end up with scanning the whole lis=
t
> > (due to clamp() below).
>=20
> Are you certain? If so, I don't see what you mean. This is how the code
> looks in Linus' tree after the fixups:
>=20
>    unsigned long cgroup_size =3D mem_cgroup_size(memcg);
>    unsigned long baseline =3D 0;
>=20
>    if (!sc->memcg_low_reclaim)
>            baseline =3D lruvec_size;
>    scan =3D lruvec_size * cgroup_size / protection - baseline;

>=20
> This works correctly as far as I can tell:

I'm blaming the old version, not the new one.

New one is perfectly fine, thanks to these lines:
+                       /* Avoid TOCTOU with earlier protection check */
+                       cgroup_size =3D max(cgroup_size, protection);

The old one was racy.

Thanks!
