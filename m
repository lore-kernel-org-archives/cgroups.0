From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] mm/memcontrol.c: fix another unused function warning
Date: Tue, 1 Oct 2019 18:00:50 +0200
Message-ID: <CAK8P3a04nMwy3VpdtD6x_tdPC14LPPbt3JKrGN48qRo_sDVk-Q@mail.gmail.com>
References: <20191001142227.1227176-1-arnd@arndb.de> <1569940805.5576.257.camel@lca.pw>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1569940805.5576.257.camel@lca.pw>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qian Cai <cai@lca.pw>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, Linux-MM <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, clang-built-linux <clang-built-linux@googlegroups.com>

On Tue, Oct 1, 2019 at 4:40 PM Qian Cai <cai@lca.pw> wrote:
>
> On Tue, 2019-10-01 at 16:22 +0200, Arnd Bergmann wrote:
> > Removing the mem_cgroup_id_get() stub function introduced a new warning
> > of the same kind when CONFIG_MMU is disabled:
>
> Shouldn't CONFIG_MEMCG depends on CONFIG_MMU instead?

Maybe. Generally we allow building a lot of stuff without CONFIG_MMU that
may not make sense, so I just followed the same idea here.

      Arnd
