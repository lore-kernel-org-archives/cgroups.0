From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v5 0/7] mm: reparent slab memory on cgroup removal
Date: Wed, 22 May 2019 22:23:01 +0000
Message-ID: <20190522222254.GA5700@castle>
References: <20190521200735.2603003-1-guro@fb.com>
 <20190522214347.GA10082@tower.DHCP.thefacebook.com>
 <20190522145906.60c9e70ac0ed7ee3918a124c@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=dGmKexW93ziU4gaxGu2r8jazHHWX79RJa8vFWpgs9PA=;
 b=IAEjEkbK1fNS9QuZ5RtI4RWq2cpu9zKkLk4Rti/yV01QYV8kG1U3eIz5Rah4wzJUsQ91
 lSWbqIWGduow+/cXrlgLSYo97fZs4fRK21NSP3TJC+xqcBs4VdBs0o9nvHnGqZiba22o
 IqaKjwpzRVCF60QB4mRiNEpjyT+fqY3uqOc= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dGmKexW93ziU4gaxGu2r8jazHHWX79RJa8vFWpgs9PA=;
 b=r4T7y0il9x6ORmFiY+ATgUu27a5Q8elRA6V5CL9dgARrsp6Vv6YqHqQA57GRa5IZAjHFAYbw76PmE0c4fh8ahy2zDrKyWxs3f7au137fhrs5yg4vJZzTFKtioDF86B4DDVh/7n9ELX1UqbDAznWxbH8D44z06Ktz0XQ8rn5V1y8=
In-Reply-To: <20190522145906.60c9e70ac0ed7ee3918a124c@linux-foundation.org>
Content-Language: en-US
Content-ID: <65249C67D481204287EF3B3478D04766@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Shakeel Butt <shakeelb@google.com>, Christoph Lameter <cl@linux.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Waiman Long <longman@redhat.com>

On Wed, May 22, 2019 at 02:59:06PM -0700, Andrew Morton wrote:
> On Wed, 22 May 2019 21:43:54 +0000 Roman Gushchin <guro@fb.com> wrote:
>=20
> > Is this patchset good to go? Or do you have any remaining concerns?
> >=20
> > It has been carefully reviewed by Shakeel; and also Christoph and Waima=
n
> > gave some attention to it.
> >=20
> > Since commit 172b06c32b94 ("mm: slowly shrink slabs with a relatively")
> > has been reverted, the memcg "leak" problem is open again, and I've hea=
rd
> > from several independent people and companies that it's a real problem
> > for them. So it will be nice to close it asap.
> >=20
> > I suspect that the fix is too heavy for stable, unfortunately.
> >=20
> > Please, let me know if you have any issues that preventing you
> > from pulling it into the tree.
>=20
> I looked, and put it on ice for a while, hoping to hear from
> mhocko/hannes.  Did they look at the earlier versions?

Johannes has definitely looked at one of early versions of the patchset,
and one of the outcomes was his own patchset about pushing memcg stats
up by the tree, which eliminated the need to deal with memcg stats
on kmem_cache reparenting.

The problem and the proposed solution have been discussed on latest LSFMM,
and I didn't hear any opposition. So I assume that Michal is at least
not against the idea in general. A careful code review is always welcome,
of course.

Thanks!
