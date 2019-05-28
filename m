From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v5 6/7] mm: reparent slab memory on cgroup removal
Date: Tue, 28 May 2019 19:58:17 +0000
Message-ID: <20190528195808.GA27847@tower.DHCP.thefacebook.com>
References: <20190521200735.2603003-1-guro@fb.com>
 <20190521200735.2603003-7-guro@fb.com>
 <20190528183302.zv75bsxxblc6v4dt@esperanza>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=LkSxTZxdxqWXHs6bcjODkfy5ThgF4ZzKI+BFcFNhJwc=;
 b=WmXfvDLJbX5jj5IFNgc0Wbxcie3JyXKz9Bk3P4JXDoblWYirieoymNy8a43A8rPtyjlv
 a+7676R4Xe6PtyLU232Wz1VTz8k7FgXegFLYnOf7eGQXu/N1kUZHgqPegNxC3nYcd3kV
 AgXMKWUaCJDzC89vCHMFvtIL0uK1O7kHVQo= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LkSxTZxdxqWXHs6bcjODkfy5ThgF4ZzKI+BFcFNhJwc=;
 b=mz3MGrm9QwsvbTIAx5Q3kP7X2sKuVY/oejW6MoPS8f8Y0CrH7SlH9GlLZxfSGbpJ8Qw/lJH/ptvSFpYKxqWL6sB097D1QFMuAbwF6dIlXVGxK0gJLzzEJtPhN8LpHfPG9WwwjMrBqiYlfrMKJTNCyu05IHUz3bnYGjU6QebJxW4=
In-Reply-To: <20190528183302.zv75bsxxblc6v4dt@esperanza>
Content-Language: en-US
Content-ID: <0850A1DD02DABC429A7DDA28E4AFE9A8@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Shakeel Butt <shakeelb@google.com>, Christoph Lameter <cl@linux.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Waiman Long <longman@redhat.com>

On Tue, May 28, 2019 at 09:33:02PM +0300, Vladimir Davydov wrote:
> On Tue, May 21, 2019 at 01:07:34PM -0700, Roman Gushchin wrote:
> > Let's reparent memcg slab memory on memcg offlining. This allows us
> > to release the memory cgroup without waiting for the last outstanding
> > kernel object (e.g. dentry used by another application).
> >=20
> > So instead of reparenting all accounted slab pages, let's do reparent
> > a relatively small amount of kmem_caches. Reparenting is performed as
> > a part of the deactivation process.
> >=20
> > Since the parent cgroup is already charged, everything we need to do
> > is to splice the list of kmem_caches to the parent's kmem_caches list,
> > swap the memcg pointer and drop the css refcounter for each kmem_cache
> > and adjust the parent's css refcounter. Quite simple.
> >=20
> > Please, note that kmem_cache->memcg_params.memcg isn't a stable
> > pointer anymore. It's safe to read it under rcu_read_lock() or
> > with slab_mutex held.
> >=20
> > We can race with the slab allocation and deallocation paths. It's not
> > a big problem: parent's charge and slab global stats are always
> > correct, and we don't care anymore about the child usage and global
> > stats. The child cgroup is already offline, so we don't use or show it
> > anywhere.
> >=20
> > Local slab stats (NR_SLAB_RECLAIMABLE and NR_SLAB_UNRECLAIMABLE)
> > aren't used anywhere except count_shadow_nodes(). But even there it
> > won't break anything: after reparenting "nodes" will be 0 on child
> > level (because we're already reparenting shrinker lists), and on
> > parent level page stats always were 0, and this patch won't change
> > anything.
> >=20
> > Signed-off-by: Roman Gushchin <guro@fb.com>
> > Reviewed-by: Shakeel Butt <shakeelb@google.com>
>=20
> This one looks good to me. I can't see why anything could possibly go
> wrong after this change.

Hi Vladimir!

Thank you for looking into the series. Really appreciate it!

It looks like outstanding questions are:
1) synchronization around the dying flag
2) removing CONFIG_SLOB in 2/7
3) early sysfs_slab_remove()
4) mem_cgroup_from_kmem in 7/7

Please, let me know if I missed anything.

I'm waiting now for Johanness's review, so I'll address these issues
in background and post the next (and hopefully) final version.

Thanks!
