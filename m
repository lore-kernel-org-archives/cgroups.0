From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm: memcontrol.c: move mem_cgroup_id_get_many under
 CONFIG_MMU
Date: Tue, 17 Dec 2019 16:19:31 +0100
Message-ID: <20191217151931.GD7272@dhcp22.suse.cz>
References: <20191217135440.GB58496@chrisdown.name>
 <392D7C59-5538-4A9B-8974-DB0B64880C2C@lca.pw>
 <20191217144652.GA7272@dhcp22.suse.cz>
 <20191217150921.GA136178@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191217150921.GA136178@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris@chrisdown.name>
Cc: Qian Cai <cai@lca.pw>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Tue 17-12-19 15:09:21, Chris Down wrote:
[...]
> (Side note: I'm moderately baffled that a tightly scoped __maybe_unused is
> considered sinister but somehow disabling -Wunused-function is on the table
> :-))

Well, I usually do not like to see __maybe_unused because that is prone
to bit-rot and loses its usefulness. Looking into the recent git logs
most -Wunused-function led to the code removal (which is really good
but the compiler is likely to do that already so the overall impact is
not that large) or more ifdefery. I do not really see many instance of
__maybe_unused.

-- 
Michal Hocko
SUSE Labs
