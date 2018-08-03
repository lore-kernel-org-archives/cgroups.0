From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v1] mm:memcg: skip memcg of current in
 mem_cgroup_soft_limit_reclaim
Date: Fri, 3 Aug 2018 08:18:17 +0200
Message-ID: <20180803061817.GC27245@dhcp22.suse.cz>
References: <1533275285-12387-1-git-send-email-zhaoyang.huang@spreadtrum.com>
 <CAGWkznE_Z+eJ+81eZN_KT7KXSFyCxfoafeMFSzirT7OaL+vbRA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGWkznE_Z+eJ+81eZN_KT7KXSFyCxfoafeMFSzirT7OaL+vbRA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhaoyang Huang <huangzhaoyang@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>, cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-patch-test@lists.linaro.org

On Fri 03-08-18 14:11:26, Zhaoyang Huang wrote:
> On Fri, Aug 3, 2018 at 1:48 PM Zhaoyang Huang <huangzhaoyang@gmail.com> wrote:
> >
> > for the soft_limit reclaim has more directivity than global reclaim, we40960
> > have current memcg be skipped to avoid potential page thrashing.
> >
> The patch is tested in our android system with 2GB ram.  The case
> mainly focus on the smooth slide of pictures on a gallery, which used
> to stall on the direct reclaim for over several hundred
> millionseconds. By further debugging, we find that the direct reclaim
> spend most of time to reclaim pages on its own with softlimit set to
> 40960KB. I add a ftrace event to verify that the patch can help
> escaping such scenario. Furthermore, we also measured the major fault
> of this process(by dumpsys of android). The result is the patch can
> help to reduce 20% of the major fault during the test.

I have asked already asked. Why do you use the soft limit in the first
place? It is known to cause excessive reclaim and long stalls.
-- 
Michal Hocko
SUSE Labs
