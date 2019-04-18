From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 0/5] mm: reparent slab memory on cgroup removal
Date: Thu, 18 Apr 2019 18:27:17 +0000
Message-ID: <20190418182714.GD11008@tower.DHCP.thefacebook.com>
References: <20190417215434.25897-1-guro@fb.com>
 <20190418081538.prspe27lqudvvu3u@esperanza>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=IXulJh/FgqYyotf43koBiEZBD43j5St1HHGGcJU+mZA=;
 b=cjFy83iZQfoz7LPg9XQLT2DOK6pE5xBhKAZeuMf66WNhnWezaagIWY/nd7D6JS1JXlNE
 vSElNrg8sHXOHO2knrW0C4nO7sq6JSpW2zkoSsBnwsFgxQeZcG2/nqtwco+VWymre/2E
 ireOk3AYr9BgtBWIOyg20Sg+toM0GNuq3/I= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IXulJh/FgqYyotf43koBiEZBD43j5St1HHGGcJU+mZA=;
 b=XRR+MgJfvfbDJKlT1x0eiy/mzB0NHswLQq5j93ov8qwxgsk2G2TRQvPiL67enqRFWOlsmpR8JEVeStgAzo9DWUH1gaAKiua07ZqkO0HhnlEMKGw2s5Hz5yXQE9CoMo3K0ipFL2GoGIpBvk/YEaf2gtFZZSqIIiZUL2vz6Iyp4N8=
In-Reply-To: <20190418081538.prspe27lqudvvu3u@esperanza>
Content-Language: en-US
Content-ID: <6199B9832BACEB4A82B2F0815266A507@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Roman Gushchin <guroan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, "david@fromorbit.com" <david@fromorbit.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>

On Thu, Apr 18, 2019 at 11:15:38AM +0300, Vladimir Davydov wrote:
> Hello Roman,
>=20
> On Wed, Apr 17, 2019 at 02:54:29PM -0700, Roman Gushchin wrote:
> > There is however a significant problem with reparenting of slab memory:
> > there is no list of charged pages. Some of them are in shrinker lists,
> > but not all. Introducing of a new list is really not an option.
>=20
> True, introducing a list of charged pages would negatively affect
> SL[AU]B performance since we would need to protect it with some kind
> of lock.
>=20
> >=20
> > But fortunately there is a way forward: every slab page has a stable po=
inter
> > to the corresponding kmem_cache. So the idea is to reparent kmem_caches
> > instead of slab pages.
> >=20
> > It's actually simpler and cheaper, but requires some underlying changes=
:
> > 1) Make kmem_caches to hold a single reference to the memory cgroup,
> >    instead of a separate reference per every slab page.
> > 2) Stop setting page->mem_cgroup pointer for memcg slab pages and use
> >    page->kmem_cache->memcg indirection instead. It's used only on
> >    slab page release, so it shouldn't be a big issue.
> > 3) Introduce a refcounter for non-root slab caches. It's required to
> >    be able to destroy kmem_caches when they become empty and release
> >    the associated memory cgroup.
>=20
> Which means an unconditional atomic inc/dec on charge/uncharge paths
> AFAIU. Note, we have per cpu batching so charging a kmem page in cgroup
> v2 doesn't require an atomic variable modification. I guess you could
> use some sort of per cpu ref counting though.

Yes, looks like I have to switch to the percpu counter (see the thread
with Shakeel).

>=20
> Anyway, releasing mem_cgroup objects, but leaving kmem_cache objects
> dangling looks kinda awkward to me. It would be great if we could
> release both, but I assume it's hardly possible due to SL[AU]B
> complexity.

Kmem_caches are *much* smaller than memcgs. If the size of kmem_cache
is smaller than the size of objects which are pinning it, I think it's
acceptable. I hope to release all associated percpu memory early to make
it even smaller.

On the other hand memcgs are much larger than typical object which
are pinning it (dentries and inodes). And it rends to grow with new feature=
s
being added.

I agree that releasing both would be cool, but I doubt it's possible.

>=20
> What about reusing dead cgroups instead? Yeah, it would be kinda unfair,
> because a fresh cgroup would get a legacy of objects left from previous
> owners, but still, if we delete a cgroup, the workload must be dead and
> so apart from a few long-lived objects, there should mostly be cached
> objects charged to it, which should be easily released on memory
> pressure. Sorry if somebody's asked this question before - I must have
> missed that.

It's an interesting idea. The problem is that the dying cgroup can be
an almost fully functional cgroup for a long time: it can have associated
sockets, pagecache, kernel objects, etc. It's a part of cgroup tree,
all constraints and limits are still applied, it might have some background
activity.

Thanks!
