From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: memcg: expose mem_cgroup_put API
Date: Thu, 8 Mar 2018 15:45:01 -0800
Message-ID: <20180308154501.a42bb22af0da6ccd727773c8@linux-foundation.org>
References: <20180308024850.39737-1-shakeelb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180308024850.39737-1-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <guro@fb.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@kernel.org>, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, David Rientjes <rientjes@google.com>

On Wed,  7 Mar 2018 18:48:50 -0800 Shakeel Butt <shakeelb@google.com> wrote:

> This patch exports mem_cgroup_put API to put the refcnt of the memory
> cgroup.

OK, I remember now.  This is intended to make
fs-fsnotify-account-fsnotify-metadata-to-kmemcg.patch independent of
mm-oom-cgroup-aware-oom-killer.patch by extracting mem_cgroup_put()
from mm-oom-cgroup-aware-oom-killer.patch.

However it will not permit me to stage
fs-fsnotify-account-fsnotify-metadata-to-kmemcg.patch ahead of
mm-oom-cgroup-aware-oom-killer.patch because there are quite a lot of
syntactic clashes.

I can resolve those if needed, but am keenly hoping that the
mm-oom-cgroup-aware-oom-killer.patch issues are resolved soon so there
isn't a need to do this.

