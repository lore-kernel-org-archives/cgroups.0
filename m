From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v1 0/7] mm/memcontrol: recharge mlocked pages
Date: Thu, 5 Sep 2019 23:11:39 +0000
Message-ID: <20190905231135.GA9822@tower.dhcp.thefacebook.com>
References: <156760509382.6560.17364256340940314860.stgit@buzz>
 <20190904143747.GA3838@dhcp22.suse.cz>
 <6171edb1-4598-5709-bb62-07bed89175b1@yandex-team.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=tenXssdW4E1XDma9BTQJomHLmn+Qu+z0mCqwlEqDzYs=;
 b=F8/80u1slN9HC/YtGJK/rShXYA2o4026fN+fSphKy8YOUvBL0lDmcDDIkFDqnwYrp9Xs
 fUmZNNU4P2xbD27FwXnLaP7aii0n/Q/W+VfTPIaDrbw4qKXY7pgKwjGdxw/AETAczk2p
 XM7H7q6E6USAbjdKjtts8gMeBX14HIbqTPE= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tenXssdW4E1XDma9BTQJomHLmn+Qu+z0mCqwlEqDzYs=;
 b=ewhH9JB/UPMc5I0NbM1EMkDIrXce2AzNEhasy7O5betKiOrRkrvFAg+jw0ao5yx2bm0UIroit+/pGSKrB7RnpeNd6Xfxfhj31LOi7mv/QJUb2i+LfXA9cc/eS4AWqS5950ZB1PV3XOBy9jEvjkAZqtJFDGyQkEJoTIEmy3bSfW8=
In-Reply-To: <6171edb1-4598-5709-bb62-07bed89175b1@yandex-team.ru>
Content-Language: en-US
Content-ID: <015F4A3CFBCB944290F5F79213C6A233@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Michal Hocko <mhocko@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>

On Thu, Sep 05, 2019 at 10:38:16AM +0300, Konstantin Khlebnikov wrote:
> On 04/09/2019 17.37, Michal Hocko wrote:
> > On Wed 04-09-19 16:53:08, Konstantin Khlebnikov wrote:
> > > Currently mlock keeps pages in cgroups where they were accounted.
> > > This way one container could affect another if they share file cache.
> > > Typical case is writing (downloading) file in one container and then
> > > locking in another. After that first container cannot get rid of cach=
e.
> > > Also removed cgroup stays pinned by these mlocked pages.
> > >=20
> > > This patchset implements recharging pages to cgroup of mlock user.
> > >=20
> > > There are three cases:
> > > * recharging at first mlock
> > > * recharging at munlock to any remaining mlock
> > > * recharging at 'culling' in reclaimer to any existing mlock
> > >=20
> > > To keep things simple recharging ignores memory limit. After that mem=
ory
> > > usage temporary could be higher than limit but cgroup will reclaim me=
mory
> > > later or trigger oom, which is valid outcome when somebody mlock too =
much.
> >=20
> > I assume that this is mlock specific because the pagecache which has th=
e
> > same problem is reclaimable and the problem tends to resolve itself
> > after some time.
> >=20
> > Anyway, how big of a problem this really is? A lingering memcg is
> > certainly not nice but pages are usually not mlocked for ever. Or is
> > this a way to protect from an hostile actor?
>=20
> We're using mlock mostly to avoid non-deterministic behaviour in cache.
> For example some of our applications mlock index structures in databases
> to limit count of major faults in worst case.
>=20
> Surprisingly mlock fixates unwanted effects of non-predictable cache shar=
ing.
>=20
> So, it seems makes sense to make mlock behaviour simple and completely
> deterministic because this isn't cheap operation and needs careful
> resource planning.
>

Totally agree.

>=20
>=20
> On 05/09/2019 02.13, Roman Gushchin wrote:> On Wed, Sep 04, 2019 at 04:53=
:08PM +0300, Konstantin Khlebnikov wrote:
> >> Currently mlock keeps pages in cgroups where they were accounted.
> >> This way one container could affect another if they share file cache.
> >> Typical case is writing (downloading) file in one container and then
> >> locking in another. After that first container cannot get rid of cache=
.
> >
> > Yeah, it's a valid problem, and it's not about mlocked pages only,
> > the same thing is true for generic pagecache. The only difference is th=
at
> > in theory memory pressure should fix everything. But in reality
> > pagecache used by the second container can be very hot, so the first
> > once can't really get rid of it.
> > In other words, there is no way to pass a pagecache page between cgroup=
s
> > without evicting it and re-reading from a storage, which is sub-optimal
> > in many cases.
> >
> > We thought about new madvise(), which will uncharge pagecache but set
> > a new page flag, which will mean something like "whoever first starts u=
sing
> > the page, should be charged for it". But it never materialized in a pat=
chset.
>=20
> I've implemented something similar in OpenVZ kernel - "shadow" LRU sets f=
or
> abandoned cache which automatically changes ownership at first activation=
.
>=20
> I'm thinking about fadvise() or fcntl() for moving cache into current mem=
ory cgroup.
> This should give enough control to solve all our problems.

Idk, it feels a bit fragile: because only one cgroup can own a page, there
should be a strong coordination, otherwise cgroups may just spend non-trivi=
al
amount of cpu time stealing pages back and forth.

I'm not strictly against such fadvise() though, it can be useful in certain
cases. But in general the abandoning semantics makes more sense to me.
If a cgroup doesn't plan to use the page anymore, it marks it in a special =
way,
so that the next one who want to use it pays the whole price. So it works
exactly as if the page had been evicted, but more efficiently.

Thanks!
