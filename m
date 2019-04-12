From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 3/4] mm: memcontrol: fix recursive statistics correctness
 & scalabilty
Date: Fri, 12 Apr 2019 20:15:38 +0000
Message-ID: <20190412201534.GB24377@tower.DHCP.thefacebook.com>
References: <20190412151507.2769-1-hannes@cmpxchg.org>
 <20190412151507.2769-4-hannes@cmpxchg.org>
 <CALvZod4xu10+E41YyaamigysZAnDcdA09f5m-hGd72LeJ9VmEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=tj8d9Aesqk59fYl7HFJeF3PryMc8P4Ae1h5Ah3FbvZ0=;
 b=ND5cG26i3vMtxZnN8OPgYUA0GjvVFAP9FzCxsJBJ9NWkrMnjeXA0PNMgz9uz0exAgMX9
 /PghIVhdFWaC7GAaSmnid7++khsytxHo8qioGdfm793DlT5NAf3eTJqmRGWrrt4Qkkh7
 XKUXhf/OOtnJcUMlDVYkY8EeuPRsmq1SeY4= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tj8d9Aesqk59fYl7HFJeF3PryMc8P4Ae1h5Ah3FbvZ0=;
 b=crVB3ElFsL4Vd2R9GD6Bvj8BQ2Zenr25Ra3dS4S3a7zO9ivqs/rslGABqTj+RjbTpTBnlMvEmmlnKfThc9U8VSY+NqCIukGDONENfiBVPfubqbohnuzXjF4heeBsimJzHOAgOyLf/XkL/XWY+HF3hewt8EaotYrObq9RSOoPWbk=
In-Reply-To: <CALvZod4xu10+E41YyaamigysZAnDcdA09f5m-hGd72LeJ9VmEg@mail.gmail.com>
Content-Language: en-US
Content-ID: <83C4D58C79AA094F9D9733F4C0F7C635@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Fri, Apr 12, 2019 at 12:55:10PM -0700, Shakeel Butt wrote:
> On Fri, Apr 12, 2019 at 8:15 AM Johannes Weiner <hannes@cmpxchg.org> wrot=
e:
> >
> > Right now, when somebody needs to know the recursive memory statistics
> > and events of a cgroup subtree, they need to walk the entire subtree
> > and sum up the counters manually.
> >
> > There are two issues with this:
> >
> > 1. When a cgroup gets deleted, its stats are lost. The state counters
> > should all be 0 at that point, of course, but the events are not. When
> > this happens, the event counters, which are supposed to be monotonic,
> > can go backwards in the parent cgroups.
> >
>=20
> We also faced this exact same issue as well and had the similar solution.
>=20
> > 2. During regular operation, we always have a certain number of lazily
> > freed cgroups sitting around that have been deleted, have no tasks,
> > but have a few cache pages remaining. These groups' statistics do not
> > change until we eventually hit memory pressure, but somebody watching,
> > say, memory.stat on an ancestor has to iterate those every time.
> >
> > This patch addresses both issues by introducing recursive counters at
> > each level that are propagated from the write side when stats change.
> >
> > Upward propagation happens when the per-cpu caches spill over into the
> > local atomic counter. This is the same thing we do during charge and
> > uncharge, except that the latter uses atomic RMWs, which are more
> > expensive; stat changes happen at around the same rate. In a sparse
> > file test (page faults and reclaim at maximum CPU speed) with 5 cgroup
> > nesting levels, perf shows __mod_memcg_page state at ~1%.
> >
>=20
> (Unrelated to this patchset) I think there should also a way to get
> the exact memcg stats. As the machines are getting bigger (more cpus
> and larger basic page size) the accuracy of stats are getting worse.
> Internally we have an additional interface memory.stat_exact for that.
> However I am not sure in the upstream kernel will an additional
> interface is better or something like /proc/sys/vm/stat_refresh which
> sync all per-cpu stats.

I was thinking about eventually consistent counters: sync them periodically
from a worker thread. It should keep the cost of reading small, but
should increase the accuracy. Will it work for you?
