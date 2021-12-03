From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] mm: add group_oom_kill memory event
Date: Fri, 3 Dec 2021 15:37:08 -0800
Message-ID: <YaqqJPe9yvhLfQgM@carbon.dhcp.thefacebook.com>
References: <20211203162426.3375036-1-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=oBR2+xUVvPcb5jyrgmPTBCCS07U+FThFRatAqFHsCYY=;
 b=pGTxt6a/BbFCqXN73eJXT2fQIIlvyytSPYUOl4jMtY+rBZKorarUUOwfn/tvtYZItnoX
 VaC7KE73XDlkSO7eXHVLi6YHlinn+WLiKW6Rx9kNOVJD72beY4xnEPuQxxsyh/My5hRd
 flgbXe7qNDtFJBlOKVyD0yioaGIzadU1XtQ= 
Content-Disposition: inline
In-Reply-To: <20211203162426.3375036-1-schatzberg.dan@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <schatzberg.dan@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeelb@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Muchun Song <songmuchun@bytedance.com>, Alex Shi <alexs@kernel.org>, Wei Yang <richard.weiyang@gmail.com>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>

On Fri, Dec 03, 2021 at 08:24:23AM -0800, Dan Schatzberg wrote:
> Our container agent wants to know when a container exits if it was OOM
> killed or not to report to the user. We use memory.oom.group = 1 to
> ensure that OOM kills within the container's cgroup kill
> everything. Existing memory.events are insufficient for knowing if
> this triggered:
> 
> 1) Our current approach reads memory.events oom_kill and reports the
> container was killed if the value is non-zero. This is erroneous in
> some cases where containers create their children cgroups with
> memory.oom.group=1 as such OOM kills will get counted against the
> container cgroup's oom_kill counter despite not actually OOM killing
> the entire container.
> 
> 2) Reading memory.events.local will fail to identify OOM kills in leaf
> cgroups (that don't set memory.oom.group) within the container cgroup.
> 
> This patch adds a new oom_group_kill event when memory.oom.group
> triggers to allow userspace to cleanly identify when an entire cgroup
> is oom killed.
> 
> Signed-off-by: Dan Schatzberg <schatzberg.dan@gmail.com>

Reviewed-by: Roman Gushchin <guro@fb.com>

Thanks!
