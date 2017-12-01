From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm, oom: simplify alloc_pages_before_oomkill handling
Date: Fri, 1 Dec 2017 14:54:53 +0100
Message-ID: <20171201135453.jrldrcrwpped4b5d@dhcp22.suse.cz>
References: <20171130152824.1591-1-guro@fb.com>
 <20171201091425.ekrpxsmkwcusozua@dhcp22.suse.cz>
 <20171201133214.GB7741@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171201133214.GB7741@castle.DHCP.thefacebook.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@vger.kernel.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Fri 01-12-17 13:32:15, Roman Gushchin wrote:
> Hi, Michal!
> 
> I totally agree that out_of_memory() function deserves some refactoring.
> 
> But I think there is an issue with your patch (see below):
> 
> On Fri, Dec 01, 2017 at 10:14:25AM +0100, Michal Hocko wrote:
> > Recently added alloc_pages_before_oomkill gained new caller with this
> > patchset and I think it just grown to deserve a simpler code flow.
> > What do you think about this on top of the series?
> > 
> > ---
[...]
> > @@ -1112,13 +1111,8 @@ bool out_of_memory(struct oom_control *oc)
> >  	}
> >  
> >  	if (mem_cgroup_select_oom_victim(oc)) {
> > -		oc->page = alloc_pages_before_oomkill(oc);
> > -		if (oc->page) {
> > -			if (oc->chosen_memcg &&
> > -			    oc->chosen_memcg != INFLIGHT_VICTIM)
> > -				mem_cgroup_put(oc->chosen_memcg);
> 
> You're removing chosen_memcg releasing here, but I don't see where you
> do this instead. And I'm not sure that putting mem_cgroup_put() into
> alloc_pages_before_oomkill() is a way towards simpler code.

Dohh, I though I did. But obviously it is not there.

> I was thinking about a bit larger refactoring: splitting out_of_memory()
> into the following parts (defined as separate functions): victim selection
> (per-process, memcg-aware or just allocating task), last allocation attempt,
> OOM action (kill process, kill memcg, panic). Hopefully it can simplify the things,
> but I don't have code yet.

OK, I will not push if you have further plans of course. This just hit
my eyes...

-- 
Michal Hocko
SUSE Labs
