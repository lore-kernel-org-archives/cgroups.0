From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v2 0/3] mm: memcontrol: recursive memory protection
Date: Fri, 20 Dec 2019 04:06:22 +0000
Message-ID: <20191220040618.GA8069@localhost.localdomain>
References: <20191219200718.15696-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Sn8mdDEZbmlAseTcnBwC4N9LFeeFcWpfGwn1PGVmyY8=;
 b=GPmOI/HWcKnxg7HnTO1FwOjg0Q7Cy8Zm+Q5z1xLXncu66dTMEVGL1LwUJkfg60PWdYam
 tJOL+C7zdoAIjA8vRDBQI07uIRL5/Hj+G7K6vb83qp4cyZKuxOfR0lCtcOSi/Vp/M/KI
 YfXmpNSua/RGYvodwUd+ifVPcdAE5d5zQ0g= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sn8mdDEZbmlAseTcnBwC4N9LFeeFcWpfGwn1PGVmyY8=;
 b=ZABfVH0t5DzZpNrVRqKHif4o/rRO+S4OE71/DkDPLJ5+TcVeIdwpe9jDAH//9HKT9oqlBk2xW951mjogBqimcQ8Xor6JJcurRn21Kgryoy32yuYHZocL6GjYiq2oqi4FN7C5tPWLBTTR+g/hBSlwl8UvmhG1FpU27gBfanBzzsY=
In-Reply-To: <20191219200718.15696-1-hannes@cmpxchg.org>
Content-Language: en-US
Content-ID: <CAFF278338101D4AB85FB890F3EC784B@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Thu, Dec 19, 2019 at 03:07:15PM -0500, Johannes Weiner wrote:
> Changes since v1:
> - improved Changelogs based on the discussion with Roman. Thanks!
> - fix div0 when recursive & fixed protection is combined
> - fix an unused compiler warning
>=20
> The current memory.low (and memory.min) semantics require protection
> to be assigned to a cgroup in an untinterrupted chain from the
> top-level cgroup all the way to the leaf.
>=20
> In practice, we want to protect entire cgroup subtrees from each other
> (system management software vs. workload), but we would like the VM to
> balance memory optimally *within* each subtree, without having to make
> explicit weight allocations among individual components. The current
> semantics make that impossible.
>=20
> This patch series extends memory.low/min such that the knobs apply
> recursively to the entire subtree. Users can still assign explicit
> protection to subgroups, but if they don't, the protection set by the
> parent cgroup will be distributed dynamically such that children
> compete freely - as if no memory control were enabled inside the
> subtree - but enjoy protection from neighboring trees.
>=20
> Patch #1 fixes an existing bug that can give a cgroup tree more
> protection than it should receive as per ancestor configuration.
>=20
> Patch #2 simplifies and documents the existing code to make it easier
> to reason about the changes in the next patch.
>=20
> Patch #3 finally implements recursive memory protection semantics.
>=20
> Because of a risk of regressing legacy setups, the new semantics are
> hidden behind a cgroup2 mount option, 'memory_recursiveprot'.

I really like the new semantics: it looks nice and doesn't require
any new magic values aka "bypass", which have been discussed previously.
The ability to disable the protection for a particular cgroup inside
the protected sub-tree looks overvalued: I don't have any practical
example when it makes any sense. So it's totally worth it to sacrifice
it. Thank you for adding comments to the changelog!

Acked-by: Roman Gushchin <guro@fb.com>
for the series.

Thanks!
