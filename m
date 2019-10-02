From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm/memcontrol.c: fix another unused function warning
Date: Wed, 2 Oct 2019 09:54:51 +0200
Message-ID: <20191002075451.GG15624@dhcp22.suse.cz>
References: <20191001142227.1227176-1-arnd@arndb.de>
 <CAKwvOdn7J6bvF=58UkeXA8LVAMt-g76EDFT+j5EWc0LdsyX_CQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKwvOdn7J6bvF=58UkeXA8LVAMt-g76EDFT+j5EWc0LdsyX_CQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Qian Cai <cai@lca.pw>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, clang-built-linux <clang-built-linux@googlegroups.com>

On Tue 01-10-19 09:36:24, Nick Desaulniers wrote:
> On Tue, Oct 1, 2019 at 7:22 AM Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > Removing the mem_cgroup_id_get() stub function introduced a new warning
> > of the same kind when CONFIG_MMU is disabled:
> >
> > mm/memcontrol.c:4929:13: error: unused function 'mem_cgroup_id_get_many' [-Werror,-Wunused-function]
> >
> > Address this using a __maybe_unused annotation.
> >
> > Note: alternatively, this could be moved into an #ifdef block.  Marking it
> 
> Hi Arnd,
> Thank you for the patch!  I would prefer to move the definition to the
> correct set of #ifdef guards rather than __maybe_unused.  Maybe move
> the definition of mem_cgroup_id_get_many() to just before
> __mem_cgroup_clear_mc()?  I find __maybe_unused to be a code smell.

Agreed!
-- 
Michal Hocko
SUSE Labs
