From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v4 5/7] mm: rework non-root kmem_cache lifecycle
 management
Date: Mon, 20 May 2019 17:56:46 +0000
Message-ID: <20190520175640.GA24204@tower.DHCP.thefacebook.com>
References: <20190514213940.2405198-1-guro@fb.com>
 <20190514213940.2405198-6-guro@fb.com>
 <CALvZod6Zb_kYHyG02jXBY9gvvUn_gOug7kq_hVa8vuCbXdPdjQ@mail.gmail.com>
 <5e3c4646-3e4f-414a-0eca-5249956d68a5@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ZiG/s3OPwoUxswb+C2dKoiuIlrtNc7Ss7KDaPAFqyZg=;
 b=rA4LGsS5aYKGac27pVplwvVYqfQ+bM3ff142NEYp7ETU4F1d5MbqOpMFGD7YfI7Qfuwp
 qDY5mC4qpbX8HQSSoyC9UIDEZxik8cCeD2AtglXP2wKX9V0PKbmfGMWeP0N/0Fw0v6+u
 m4IhoUFUsD+R03vxZ8ww0k5xQyIq3PbJtis= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZiG/s3OPwoUxswb+C2dKoiuIlrtNc7Ss7KDaPAFqyZg=;
 b=GuMF0nCwIKAVEvMlixihJm3hjQALm+Qv4YVIo4UF5s19OLw6pegSyvK2OiNZacKCtId5btboBCDy2dRa49lCLEXDhogGqddghRN5Oc5NssHCC9QA02isUYbARR1yLf0ADxIKkTa35AEM8f9D0ggICxXAX3TFRNsnES0ScXbMejI=
In-Reply-To: <5e3c4646-3e4f-414a-0eca-5249956d68a5@gmail.com>
Content-Language: en-US
Content-ID: <8521F75896B0D548B2274FB23420AC8E@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman9394@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Christoph Lameter <cl@linux.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Cgroups <cgroups@vger.kernel.org>

On Mon, May 20, 2019 at 10:54:24AM -0400, Waiman Long wrote:
> On 5/14/19 8:06 PM, Shakeel Butt wrote:
> > diff --git a/mm/slab_common.c b/mm/slab_common.c
> > index 4e5b4292a763..1ee967b4805e 100644
> > --- a/mm/slab_common.c
> > +++ b/mm/slab_common.c
> > @@ -45,6 +45,8 @@ static void slab_caches_to_rcu_destroy_workfn(struct =
work_struct *work);
> >  static DECLARE_WORK(slab_caches_to_rcu_destroy_work,
> >                     slab_caches_to_rcu_destroy_workfn);
> >
> > +static void kmemcg_queue_cache_shutdown(struct percpu_ref *percpu_ref)=
;
> > +
>=20
> kmemcg_queue_cache_shutdown is only defined if CONFIG_MEMCG_KMEM is
> defined. If it is not defined, a compilation warning can be produced.
> Maybe putting the declaration inside a CONFIG_MEMCG_KMEM block:

Hi Waiman!

Yes, that makes total sense to me. Thank you for letting me know!
How about this one?

--

From 0fa19369adc240cc93281911a59713822a4f3e07 Mon Sep 17 00:00:00 2001
From: Roman Gushchin <guro@fb.com>
Date: Mon, 20 May 2019 10:52:07 -0700
Subject: [PATCH] mm: guard kmemcg_queue_cache_shutdown() with
 CONFIG_MEMCG_KMEM

Currently kmemcg_queue_cache_shutdown() is defined only
if CONFIG_MEMCG_KMEM is set, however the declaration is not guarded
with corresponding ifdefs. So a compilation warning might be produced.

Let's move the declaration to the section of slab_common.c, where all
kmemcg-specific stuff is defined.

Reported-by: Waiman Long <longman9394@gmail.com>
Signed-off-by: Roman Gushchin <guro@fb.com>
---
 mm/slab_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 9d2a3d6245dc..e818609c8209 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -45,8 +45,6 @@ static void slab_caches_to_rcu_destroy_workfn(struct work=
_struct *work);
 static DECLARE_WORK(slab_caches_to_rcu_destroy_work,
 		    slab_caches_to_rcu_destroy_workfn);
=20
-static void kmemcg_queue_cache_shutdown(struct percpu_ref *percpu_ref);
-
 /*
  * Set of flags that will prevent slab merging
  */
@@ -134,6 +132,8 @@ int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t=
 flags, size_t nr,
 LIST_HEAD(slab_root_caches);
 static DEFINE_SPINLOCK(memcg_kmem_wq_lock);
=20
+static void kmemcg_queue_cache_shutdown(struct percpu_ref *percpu_ref);
+
 void slab_init_memcg_params(struct kmem_cache *s)
 {
 	s->memcg_params.root_cache =3D NULL;
--=20
2.20.1
