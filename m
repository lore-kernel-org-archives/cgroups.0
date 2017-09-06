From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [v7 2/5] mm, oom: cgroup-aware OOM killer
Date: Wed, 6 Sep 2017 16:10:34 +0200
Message-ID: <20170906141034.aw2nzl577m5tt6om@dhcp22.suse.cz>
References: <20170904142108.7165-1-guro@fb.com>
 <20170904142108.7165-3-guro@fb.com>
 <20170905145700.fd7jjd37xf4tb55h@dhcp22.suse.cz>
 <20170905202357.GA10535@castle.DHCP.thefacebook.com>
 <20170906083158.gvqx6pekrsy2ya47@dhcp22.suse.cz>
 <20170906125750.GB12904@castle>
 <20170906132249.c2llo5zyrzgviqzc@dhcp22.suse.cz>
 <20170906134142.GA15796@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170906134142.GA15796@castle.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed 06-09-17 14:41:42, Roman Gushchin wrote:
[...]
> Although, I don't think the whole thing is useful without any way
> to adjust the memcg selection, so we can't postpone if for too long.
> Anyway, if you think it's a way to go forward, let's do it.

I am not really sure we are in a rush here. The whole oom_score_adj
fiasco has showed that most users tend to only care "to never kill this
and that". A better fine tuned oom control sounds useful at first but
apart from very special usecases turns out very impractical to set
up. At least that is my experience. There are special cases of course
but we should target general use first.

Kill the whole memcg is a really useful feature on its own for proper
container cleanup.
-- 
Michal Hocko
SUSE Labs
