From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v5 5/7] mm: rework non-root kmem_cache lifecycle
 management
Date: Tue, 28 May 2019 22:28:51 +0000
Message-ID: <20190528222847.GE27847@tower.DHCP.thefacebook.com>
References: <20190521200735.2603003-1-guro@fb.com>
 <20190521200735.2603003-6-guro@fb.com> <20190528220353.GC26614@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=BqXrZYH8sAaIkc8wS42rAiXcrgzZJ8PEYyOJZew7260=;
 b=bJeQPDz5+RldEeWucq7npQkgDLVkDJHnjE1C7txLMO0hEbjmBTLTLhbJcMYMsyAp2nuD
 7cDoEBk6m8RMx26tbta3gIFD/ih/A0KRm8h5TFVdR+WnHs2PSPnblWKchdFXl5ZziRZ5
 BLw80p7bespEMYEQ4oXLd/64GyGYflKMo3g= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BqXrZYH8sAaIkc8wS42rAiXcrgzZJ8PEYyOJZew7260=;
 b=W5H/OB32nlYnyCx1cX+yqAc+BMQLLLnII/4CTmGvxwMg/BcQM2NqiYDfwc3dgAigFO7KHR5exNJEC7P4a72HNMkFW2i1EA6lhzxkSCnXeiH3HIwFp15LUvGesIRMMFYmTqPZo9R2ERe05ydABJxjraBtpY9CuDD1hKF5rZTEOxY=
In-Reply-To: <20190528220353.GC26614@cmpxchg.org>
Content-Language: en-US
Content-ID: <CA0D957DFE75114BB468938EE4F4C758@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Shakeel Butt <shakeelb@google.com>, Christoph Lameter <cl@linux.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Waiman Long <longman@redhat.com>

On Tue, May 28, 2019 at 06:03:53PM -0400, Johannes Weiner wrote:
> On Tue, May 21, 2019 at 01:07:33PM -0700, Roman Gushchin wrote:
> > +	arr =3D rcu_dereference(cachep->memcg_params.memcg_caches);
> > +
> > +	/*
> > +	 * Make sure we will access the up-to-date value. The code updating
> > +	 * memcg_caches issues a write barrier to match this (see
> > +	 * memcg_create_kmem_cache()).
> > +	 */
> > +	memcg_cachep =3D READ_ONCE(arr->entries[kmemcg_id]);
>=20
> READ_ONCE() isn't an SMP barrier, it just prevents compiler
> muckery. This needs an explicit smp_rmb() to pair with the smp_wmb()
> on the other side.

I believe rcu_dereference()/rcu_assign_pointer()/... are better replacement=
s.

>=20
> I realize you're only moving this code, but it would be good to fix
> that up while you're there.

Right. I'll try to fix it with new-ish rcu API in a separate patch
preceding this one.

Thank you for looking into the series!
