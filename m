From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v2] mm, memcg: introduce memory.events.local
Date: Sat, 18 May 2019 00:59:30 +0000
Message-ID: <20190518005927.GB3431@tower.DHCP.thefacebook.com>
References: <20190518001818.193336-1-shakeelb@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=7qKsPldQKiOqJbT53B5lYvQu0Xny2wWC1bg1lwvSMV8=;
 b=bL0Fp2IGZVpRpN+z+SEaYK1ZNTKQ+3piBoXDKKa7LmBwXpuSFVwHr80Tu/3vHZ0TrG+l
 +5jy4zy/BuKY+EhamjEcTW6KTbin/K4JHkyPiQZrI6VCPsFggbUXjN96lINoM9+hiniC
 1Fcak6ezMO7lfzWRHtmarfH83dwaKSloEqc= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7qKsPldQKiOqJbT53B5lYvQu0Xny2wWC1bg1lwvSMV8=;
 b=EQBUwShtpY7RYKBOdCLPE58QQ/OmVEj7witCilVlDuuT7K4Ehy+j1Zy5zbEMfnQgNcGkNWmGpBbWylmYW+YtSHapMPxlt12Wpj9Kq/Zwj+TOSqeCyzVetBUz0jn0zVGAHkX007eYR9poZtG+isrHYIMlzWUbs6M+4HDGS/udKo0=
In-Reply-To: <20190518001818.193336-1-shakeelb@google.com>
Content-Language: en-US
Content-ID: <F4C49EE3FF59984090F0BB32EF187949@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Chris Down <chris@chrisdown.name>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Fri, May 17, 2019 at 05:18:18PM -0700, Shakeel Butt wrote:
> The memory controller in cgroup v2 exposes memory.events file for each
> memcg which shows the number of times events like low, high, max, oom
> and oom_kill have happened for the whole tree rooted at that memcg.
> Users can also poll or register notification to monitor the changes in
> that file. Any event at any level of the tree rooted at memcg will
> notify all the listeners along the path till root_mem_cgroup. There are
> existing users which depend on this behavior.
>=20
> However there are users which are only interested in the events
> happening at a specific level of the memcg tree and not in the events in
> the underlying tree rooted at that memcg. One such use-case is a
> centralized resource monitor which can dynamically adjust the limits of
> the jobs running on a system. The jobs can create their sub-hierarchy
> for their own sub-tasks. The centralized monitor is only interested in
> the events at the top level memcgs of the jobs as it can then act and
> adjust the limits of the jobs. Using the current memory.events for such
> centralized monitor is very inconvenient. The monitor will keep
> receiving events which it is not interested and to find if the received
> event is interesting, it has to read memory.event files of the next
> level and compare it with the top level one. So, let's introduce
> memory.events.local to the memcg which shows and notify for the events
> at the memcg level.
>=20
> Now, does memory.stat and memory.pressure need their local versions.
> IMHO no due to the no internal process contraint of the cgroup v2. The
> memory.stat file of the top level memcg of a job shows the stats and
> vmevents of the whole tree. The local stats or vmevents of the top level
> memcg will only change if there is a process running in that memcg but
> v2 does not allow that. Similarly for memory.pressure there will not be
> any process in the internal nodes and thus no chance of local pressure.
>=20
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> ---
> Changelog since v1:
> - refactor memory_events_show to share between events and events.local

Reviewed-by: Roman Gushchin <guro@fb.com>

You also need to add some stuff into cgroup v2 documentation.

Thanks!
