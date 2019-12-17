From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm: memcontrol.c: move mem_cgroup_id_get_many under
 CONFIG_MMU
Date: Tue, 17 Dec 2019 15:46:52 +0100
Message-ID: <20191217144652.GA7272@dhcp22.suse.cz>
References: <20191217135440.GB58496@chrisdown.name>
 <392D7C59-5538-4A9B-8974-DB0B64880C2C@lca.pw>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <392D7C59-5538-4A9B-8974-DB0B64880C2C@lca.pw>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qian Cai <cai@lca.pw>
Cc: Chris Down <chris@chrisdown.name>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Tue 17-12-19 09:16:36, Qian Cai wrote:
> 
> 
> > On Dec 17, 2019, at 8:54 AM, Chris Down <chris@chrisdown.name> wrote:
> > 
> > Let's just add __maybe_unused, since it seems like what we want in this scenario -- it avoids new users having to enter preprocessor madness, while also not polluting the build output.
> 
> __maybe_unused should only be used in the last resort as it mark the compiler to catch the real issues in the future. In this case, it might be better just ignore it as only non-realistic compiling test would use !CONFIG_MMU in this case.

yes, I would just ignore this warning. Btw. it seems that this is
enabled by default for -Wall. Is this useful for kernel builds at
all? Does it realistically help discovering real issues? If not then
can we simply blacklist it?
-- 
Michal Hocko
SUSE Labs
