From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 2/2] mm, slab: Extend vm/drop_caches to shrink kmem slabs
Date: Thu, 27 Jun 2019 21:24:25 +0000
Message-ID: <20190627212419.GA25233@tower.DHCP.thefacebook.com>
References: <20190624174219.25513-1-longman@redhat.com>
 <20190624174219.25513-3-longman@redhat.com>
 <20190626201900.GC24698@tower.DHCP.thefacebook.com>
 <063752b2-4f1a-d198-36e7-3e642d4fcf19@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=sNOu3HJF9ywLPRfufTO5OfZzrVkrGyiQosuhKaX+PKU=;
 b=YPadNksSiOYGqw+BAyyZpfaWwww3OIwZFi6ng0BIayOywkVkfgsAdBfmb9YVPMxK74It
 Q0uaE6NWTpZtpHPvoM9tcirgjyokdmfxVBQT/AmILxIwLyHYd0///NDHfpeoaXlwW0aW
 daP1EJnhvurny0ESMh7mg/6yf0Nr/PAJRBc= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sNOu3HJF9ywLPRfufTO5OfZzrVkrGyiQosuhKaX+PKU=;
 b=cONWwgOqiZvAyWfGsIE5JImH/EeoYWyEdx0i35coVnU44YH+rI70/oJFtukfMwsDwEUb1Fbmerf+wkYujPyNwU38S7yFmSRfU7aiGGIz2cDUfguMXYwVzxVxCILeR2rmsemJktFjhYGBkfnq9cBlL7jamXSiLJ4sUkhH7D9bR6w=
In-Reply-To: <063752b2-4f1a-d198-36e7-3e642d4fcf19@redhat.com>
Content-Language: en-US
Content-ID: <7E5727AEB2313B4682CD26ADDCB22D2A@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Shakeel Butt <shake>

On Thu, Jun 27, 2019 at 04:57:50PM -0400, Waiman Long wrote:
> On 6/26/19 4:19 PM, Roman Gushchin wrote:
> >> =20
> >> +#ifdef CONFIG_MEMCG_KMEM
> >> +static void kmem_cache_shrink_memcg(struct mem_cgroup *memcg,
> >> +				    void __maybe_unused *arg)
> >> +{
> >> +	struct kmem_cache *s;
> >> +
> >> +	if (memcg =3D=3D root_mem_cgroup)
> >> +		return;
> >> +	mutex_lock(&slab_mutex);
> >> +	list_for_each_entry(s, &memcg->kmem_caches,
> >> +			    memcg_params.kmem_caches_node) {
> >> +		kmem_cache_shrink(s);
> >> +	}
> >> +	mutex_unlock(&slab_mutex);
> >> +	cond_resched();
> >> +}
> > A couple of questions:
> > 1) how about skipping already offlined kmem_caches? They are already sh=
runk,
> >    so you probably won't get much out of them. Or isn't it true?
>=20
> I have been thinking about that. This patch is based on the linux tree
> and so don't have an easy to find out if the kmem caches have been
> shrinked. Rebasing this on top of linux-next, I can use the
> SLAB_DEACTIVATED flag as a marker for skipping the shrink.
>=20
> With all the latest patches, I am still seeing 121 out of a total of 726
> memcg kmem caches (1/6) that are deactivated caches after system bootup
> one of the test systems. My system is still using cgroup v1 and so the
> number may be different in a v2 setup. The next step is probably to
> figure out why those deactivated caches are still there.

It's not a secret: these kmem_caches are holding objects, which are in use.
It's a drawback of the current slab accounting implementation: every
object holds a whole page and the corresponding kmem_cache. It's optimized
for a large number of objects, which are created and destroyed within
the life of the cgroup (e.g. task_structs), and it works worse for long-liv=
ing
objects like vfs cache.

Long-term I think we need a different implementation for long-living object=
s,
so that objects belonging to different memory cgroups can share the same pa=
ge
and kmem_caches.

It's a fairly big change though.

>=20
> > 2) what's your long-term vision here? do you think that we need to shri=
nk
> >    kmem_caches periodically, depending on memory pressure? how a user
> >    will use this new sysctl?
> Shrinking the kmem caches under extreme memory pressure can be one way
> to free up extra pages, but the effect will probably be temporary.
> > What's the problem you're trying to solve in general?
>=20
> At least for the slub allocator, shrinking the caches allow the number
> of active objects reported in slabinfo to be more accurate. In addition,
> this allow to know the real slab memory consumption. I have been working
> on a BZ about continuous memory leaks with a container based workloads.
> The ability to shrink caches allow us to get a more accurate memory
> consumption picture. Another alternative is to turn on slub_debug which
> will then disables all the per-cpu slabs.

I see... I agree with Michal here, that extending drop_caches sysctl isn't
the best idea. Isn't it possible to achieve the same effect using slub sysf=
s?

Thanks!
