From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm: memcontrol.c: move mem_cgroup_id_get_many under
 CONFIG_MMU
Date: Tue, 17 Dec 2019 16:13:43 +0100
Message-ID: <20191217151343.GC7272@dhcp22.suse.cz>
References: <20191217144652.GA7272@dhcp22.suse.cz>
 <43881F9C-90D0-4DE0-BA1E-B74ACF8567BD@lca.pw>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <43881F9C-90D0-4DE0-BA1E-B74ACF8567BD@lca.pw>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qian Cai <cai@lca.pw>
Cc: Chris Down <chris@chrisdown.name>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Tue 17-12-19 10:04:36, Qian Cai wrote:
> 
> 
> > On Dec 17, 2019, at 9:46 AM, Michal Hocko <mhocko@kernel.org> wrote:
> > 
> > yes, I would just ignore this warning. Btw. it seems that this is
> > enabled by default for -Wall. Is this useful for kernel builds at
> > all? Does it realistically help discovering real issues? If not then
> > can we simply blacklist it?
> 
> -Wunused-function is useful in-general as it caught many dead code
> that some commits left unintentionally with real-world configs.

I do understand the general purpose of the warning. I am simply not sure
the kernel tree is a good candidate with a huge number of different
config combinations that might easily result in warnings which would
tend to result in even more ifdeferry than we have.
-- 
Michal Hocko
SUSE Labs
