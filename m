From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH] mm: add group_oom_kill memory event
Date: Sat, 4 Dec 2021 09:36:46 +0000
Message-ID: <Yas2ro/NCDY+1n09@chrisdown.name>
References: <20211203162426.3375036-1-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Fa6xeDSp50/P8rOL+C54lxIGIVulHb+9yCsfNo1/Wpw=;
        b=FWWeWvzsX0lVcVoLsRisdgMqOjZy/JOgW6iYDCzNR3aS7WRsMEBPIai+ZFNIuMynAr
         BT2jMNkIswwTyxFGrp3xMLb/eXReYAVYgdBy/v3oHKfoEgRChUczwjAU2SBhL9tXhriA
         MJOvZgEQz3GgTo7U+U9Zs7ICijCpUjoRP6E8g=
Content-Disposition: inline
In-Reply-To: <20211203162426.3375036-1-schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

Dan Schatzberg writes:
>Our container agent wants to know when a container exits if it was OOM
>killed or not to report to the user. We use memory.oom.group = 1 to
>ensure that OOM kills within the container's cgroup kill
>everything. Existing memory.events are insufficient for knowing if
>this triggered:
>
>1) Our current approach reads memory.events oom_kill and reports the
>container was killed if the value is non-zero. This is erroneous in
>some cases where containers create their children cgroups with
>memory.oom.group=1 as such OOM kills will get counted against the
>container cgroup's oom_kill counter despite not actually OOM killing
>the entire container.
>
>2) Reading memory.events.local will fail to identify OOM kills in leaf
>cgroups (that don't set memory.oom.group) within the container cgroup.
>
>This patch adds a new oom_group_kill event when memory.oom.group
>triggers to allow userspace to cleanly identify when an entire cgroup
>is oom killed.
>
>Signed-off-by: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Thanks! Acking with one minor point on the documentation front.

Acked-by: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>

>---
> Documentation/admin-guide/cgroup-v2.rst | 4 ++++
> include/linux/memcontrol.h              | 1 +
> mm/memcontrol.c                         | 5 +++++
> mm/oom_kill.c                           | 1 +
> 4 files changed, 11 insertions(+)
>
>diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
>index 2aeb7ae8b393..eec830ce2068 100644
>--- a/Documentation/admin-guide/cgroup-v2.rst
>+++ b/Documentation/admin-guide/cgroup-v2.rst
>@@ -1268,6 +1268,10 @@ PAGE_SIZE multiple when read back.
> 		The number of processes belonging to this cgroup
> 		killed by any kind of OOM killer.
>
>+          oom_group_kill
>+                The number of times all tasks in the cgroup were killed
>+                due to memory.oom.group.

Maybe pedantic, but this reads as unclear to me whether in cgroup with 3 tasks 
we get the value "3" or "1" when a group kill occurs.

Maybe rephrase to not make be about tasks and just say "number of times a group 
OOM occurred"?
