From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 2/2] mm, slab: Extend vm/drop_caches to shrink kmem slabs
Date: Fri, 28 Jun 2019 17:30:46 +0000
Message-ID: <20190628173040.GA11971@tower.DHCP.thefacebook.com>
References: <20190624174219.25513-1-longman@redhat.com>
 <20190624174219.25513-3-longman@redhat.com>
 <20190626201900.GC24698@tower.DHCP.thefacebook.com>
 <063752b2-4f1a-d198-36e7-3e642d4fcf19@redhat.com>
 <20190627212419.GA25233@tower.DHCP.thefacebook.com>
 <0100016b9eb7685e-0a5ab625-abb4-4e79-ab86-07744b1e4c3a-000000@email.amazonses.com>
 <CAHbLzkr+EJWgAQ9VhAdeTtMx+11=AX=mVVEvC-0UihROf2J+PA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=VgE/836/q1ZgHFTz46BuTxhY1pWpQQygQXnKQTtXWWg=;
 b=RG3h+qO2eUkVxxSHAw1yZ6M0fUOP0KjgMeAjUlRXexZDZWhyluqnvVzPEhWsIwWNPXqG
 dg4mNOO7A3fUPL/Y6peIx8gp8Sx5drQdBAFlA1Ycs9Ex46yB47K1vGFDURUCjVpJHKF4
 ITfAstaTyrYZWotQcUkEEokEsMSZvDvRY2A= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VgE/836/q1ZgHFTz46BuTxhY1pWpQQygQXnKQTtXWWg=;
 b=fnCP2Z3ei5ogfSNC2Z7AO3ZfRV6TRW3tg09Sr8nVG+XpuZuPDzbRa/h1puTh8gKAKyO+FAw3z5+B7sGcVAeCdH7i/cJxcpfwbyoQd0pGxbXhwSbiK5Mltb70urDIMfiwETSB4YCBdvpA2FAIKMdTy1w2lGm4UIe3V6kdhxSmr0k=
In-Reply-To: <CAHbLzkr+EJWgAQ9VhAdeTtMx+11=AX=mVVEvC-0UihROf2J+PA@mail.gmail.com>
Content-Language: en-US
Content-ID: <96E427C466A25B4EB9262E3679EF031A@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Yang Shi <shy828301@gmail.com>
Cc: Christopher Lameter <cl@linux.com>, Waiman Long <longman@redhat.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.>

On Fri, Jun 28, 2019 at 10:16:13AM -0700, Yang Shi wrote:
> On Fri, Jun 28, 2019 at 8:32 AM Christopher Lameter <cl@linux.com> wrote:
> >
> > On Thu, 27 Jun 2019, Roman Gushchin wrote:
> >
> > > so that objects belonging to different memory cgroups can share the s=
ame page
> > > and kmem_caches.
> > >
> > > It's a fairly big change though.
> >
> > Could this be done at another level? Put a cgoup pointer into the
> > corresponding structures and then go back to just a single kmen_cache f=
or
> > the system as a whole? You can still account them per cgroup and there
> > will be no cleanup problem anymore. You could scan through a slab cache
> > to remove the objects of a certain cgroup and then the fragmentation
> > problem that cgroups create here will be handled by the slab allocators=
 in
> > the traditional way. The duplication of the kmem_cache was not designed
> > into the allocators but bolted on later.
>=20
> I'm afraid this may bring in another problem for memcg page reclaim.
> When shrinking the slabs, the shrinker may end up scanning a very long
> list to find out the slabs for a specific memcg. Particularly for the
> count operation, it may have to scan the list from the beginning all
> the way down to the end. It may take unbounded time.
>=20
> When I worked on THP deferred split shrinker problem, I used to do
> like this, but it turns out it may take milliseconds to count the
> objects on the list, but it may just need reclaim a few of them.

I don't think the shrinker mechanism should be altered. Shrinker lists
already contain individual objects, and I don't see any reasons, why
these objects can't reside on a shared set of pages.

What we're discussing is that it's way too costly (under some conditions)
to have many sets of kmem_caches, if each of them is containing only
few objects.

Thanks!
