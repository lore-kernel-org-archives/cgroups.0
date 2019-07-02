From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] mm, slab: Extend slab/shrink to shrink all the memcg
 caches
Date: Tue, 2 Jul 2019 19:30:44 +0000
Message-ID: <20190702193038.GA9224@tower.DHCP.thefacebook.com>
References: <20190702183730.14461-1-longman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=mppx4FLBiOac/STDzA0e2oKlDa48wRKnZw4fy6/xPlc=;
 b=Sl2hfYv7BKnoXDEV6t5+vb+gHPHKTRGE9nl2b/t5suoVFtFpQHYtcj5qhBmv+yHz7LJV
 t+uoABQDo2kuUu3wA0jpuUoLIyc/lDfOEn0d63UcevCBgPkCpuIyi6FbPDHjTUqm2tC8
 jbHJIaKyrtTEzBA6SIm2ZhIAawwGUleeHEg= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mppx4FLBiOac/STDzA0e2oKlDa48wRKnZw4fy6/xPlc=;
 b=IRNQCbfTPXOGzWmovInNOQNAMQy3AEeUph5ZYNTBCU5nqqexohVGS+GKA1a78vw8fENTvo1+sbilmNMMS1VBCZyqGAMcCAZVIgiwbW8gRXBfSOUUu0xI5l6zF9E+h6GFlVcZzG01KzCRUwViG8nnpEUTeqTHdROeWGgBc1xwfg0=
In-Reply-To: <20190702183730.14461-1-longman@redhat.com>
Content-Language: en-US
Content-ID: <98243A29FC6FF44DA4B92FB487069E95@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Shakeel Butt <shakeelb@goog>

On Tue, Jul 02, 2019 at 02:37:30PM -0400, Waiman Long wrote:
> Currently, a value of '1" is written to /sys/kernel/slab/<slab>/shrink
> file to shrink the slab by flushing all the per-cpu slabs and free
> slabs in partial lists. This applies only to the root caches, though.
>=20
> Extends this capability by shrinking all the child memcg caches and
> the root cache when a value of '2' is written to the shrink sysfs file.
>=20
> On a 4-socket 112-core 224-thread x86-64 system after a parallel kernel
> build, the the amount of memory occupied by slabs before shrinking
> slabs were:
>=20
>  # grep task_struct /proc/slabinfo
>  task_struct         7114   7296   7744    4    8 : tunables    0    0
>  0 : slabdata   1824   1824      0
>  # grep "^S[lRU]" /proc/meminfo
>  Slab:            1310444 kB
>  SReclaimable:     377604 kB
>  SUnreclaim:       932840 kB
>=20
> After shrinking slabs:
>=20
>  # grep "^S[lRU]" /proc/meminfo
>  Slab:             695652 kB
>  SReclaimable:     322796 kB
>  SUnreclaim:       372856 kB
>  # grep task_struct /proc/slabinfo
>  task_struct         2262   2572   7744    4    8 : tunables    0    0
>  0 : slabdata    643    643      0
>=20
> Signed-off-by: Waiman Long <longman@redhat.com>

Acked-by: Roman Gushchin <guro@fb.com>

Thanks, Waiman!
