From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 2/2] mm, slab: Extend vm/drop_caches to shrink kmem slabs
Date: Fri, 28 Jun 2019 16:33:41 +0000
Message-ID: <20190628163334.GA3118@tower.DHCP.thefacebook.com>
References: <20190624174219.25513-1-longman@redhat.com>
 <20190624174219.25513-3-longman@redhat.com>
 <20190626201900.GC24698@tower.DHCP.thefacebook.com>
 <063752b2-4f1a-d198-36e7-3e642d4fcf19@redhat.com>
 <20190627212419.GA25233@tower.DHCP.thefacebook.com>
 <0100016b9eb7685e-0a5ab625-abb4-4e79-ab86-07744b1e4c3a-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=EmhpIaJshMDOvbE5U+8uSwIg98rUZbLjquMoASS+As4=;
 b=d2kzLdC1eeaHJHOoWr+scUpxldlFk6WltbQ2tfkRhX/uSvm9Ex55kZlOo87pGpZUDIDz
 TVnLNJPHPCbNIsXqZMBPn5fcT2yJW6v+hJ1u6H8jbGe502vDWbsD4oXnPI2Sixu5yjoj
 G7S3jR6b3/M+LDagStuXIPBAADgl8YoRiL0= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EmhpIaJshMDOvbE5U+8uSwIg98rUZbLjquMoASS+As4=;
 b=jTwDqfJLEUqryXxoR+eLFrAl2/zXVVFbnAKJNltP6rZISWjW2x88Bb+QgoVhW0foCnSUZ9I0/AhrsTxXMB6JutPWDAUW5LOeyO0RGaJFfM8caU6la9HeTFDZ2VXYs61WbMANebYb/EhCm3e1XL/YAaAXZFNWPU7yJlXYykgeGaM=
In-Reply-To: <0100016b9eb7685e-0a5ab625-abb4-4e79-ab86-07744b1e4c3a-000000@email.amazonses.com>
Content-Language: en-US
Content-ID: <7763BC919F3B554094D311CA81F5E330@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Christopher Lameter <cl@linux.com>
Cc: Waiman Long <longman@redhat.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Shakeel Butt <shakeelb@goog>

On Fri, Jun 28, 2019 at 03:32:28PM +0000, Christopher Lameter wrote:
> On Thu, 27 Jun 2019, Roman Gushchin wrote:
>=20
> > so that objects belonging to different memory cgroups can share the sam=
e page
> > and kmem_caches.
> >
> > It's a fairly big change though.
>=20
> Could this be done at another level? Put a cgoup pointer into the
> corresponding structures and then go back to just a single kmen_cache for
> the system as a whole?
> You can still account them per cgroup and there
> will be no cleanup problem anymore. You could scan through a slab cache
> to remove the objects of a certain cgroup and then the fragmentation
> problem that cgroups create here will be handled by the slab allocators i=
n
> the traditional way. The duplication of the kmem_cache was not designed
> into the allocators but bolted on later.
>=20

Yeah, this is exactly what I'm talking about. Idk how big the performance
penalty will be for small and short-living objects, it should be measured.
But for long-living objects it will be much better for sure...

Thanks!
