From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v5 6/7] mm: reparent slab memory on cgroup removal
Date: Tue, 28 May 2019 21:52:42 +0000
Message-ID: <20190528215238.GD27847@tower.DHCP.thefacebook.com>
References: <20190521200735.2603003-1-guro@fb.com>
 <20190521200735.2603003-7-guro@fb.com>
 <20190528183302.zv75bsxxblc6v4dt@esperanza>
 <20190528195808.GA27847@tower.DHCP.thefacebook.com>
 <20190528201102.63t6rtsrpq7yac44@esperanza>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=2csGm4rlE1Qqi8mXN7Sub2LV7EaIFkK5VMSLrb4jJfc=;
 b=NNmN7x5ePH9+/3PEx9NOhAzPIONn2jMLy72MnqV3NMqQG2JCOFXP+LrtkJuaIZ06nOYA
 fiYdtDRgkV9lpDBsV786Vg6CF1k56vbOKfst9gVSUnhU5+4RDLyKzxLOPQSc1Rb7gMV3
 Ot9qtYNwLfSfsg4DcWfmaPS+3hIPzkZ3PmQ= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2csGm4rlE1Qqi8mXN7Sub2LV7EaIFkK5VMSLrb4jJfc=;
 b=XP/g4gO8xI9CM1osd4/iJcff8D0lgbK1r468C0Ks1SQjacsbtWvenwrKEUMS9XuftI4d1DGlZa2NVcxnu9R+E0tVMEe6WsFZpUgsHKB+9A+INQFYRI3mCUzpD2GmA04kWPF8TmILV6JbJLarRrhMzhaF4K9Hr6iql8avcUa8Kzc=
In-Reply-To: <20190528201102.63t6rtsrpq7yac44@esperanza>
Content-Language: en-US
Content-ID: <79BD7F195AE57C48A44E1FC6FE044ED0@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Shakeel Butt <shakeelb@google.com>, Christoph Lameter <cl@linux.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Waiman Long <longman@redhat.com>

On Tue, May 28, 2019 at 11:11:02PM +0300, Vladimir Davydov wrote:
> On Tue, May 28, 2019 at 07:58:17PM +0000, Roman Gushchin wrote:
> > It looks like outstanding questions are:
> > 1) synchronization around the dying flag
> > 2) removing CONFIG_SLOB in 2/7
> > 3) early sysfs_slab_remove()
> > 4) mem_cgroup_from_kmem in 7/7
> >=20
> > Please, let me know if I missed anything.
>=20
> Also, I think that it might be possible to get rid of RCU call in kmem
> cache destructor, because the cgroup subsystem already handles it and
> we could probably piggyback - see my comment to 5/7. Not sure if it's
> really necessary, since we already have RCU in SLUB, but worth looking
> into, I guess, as it might simplify the code a bit.

Added to the list. Thank you!
