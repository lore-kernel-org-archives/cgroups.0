From: Tejun Heo <tj@kernel.org>
Subject: Re: memcg: softlimit on internal nodes
Date: Sun, 21 Apr 2013 21:39:39 -0700
Message-ID: <20130422043939.GB25089@mtj.dyndns.org>
References: <20130420002620.GA17179@mtj.dyndns.org>
 <20130420031611.GA4695@dhcp22.suse.cz>
 <20130421022321.GE19097@mtj.dyndns.org>
 <20130421124554.GA8473@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=bI8Z2ayqPgZ4cYPnAt5RtU/TK9QrOMZxM45/+mqdGp8=;
        b=sk1mm2ZP/hZEJ3ziVcPJOEj3qbe59Ql/ub7IMgKCV7gm/RbaemEDaIdTfkRu+HtWzn
         zLpBUTIPWSWePXIBXqEMian/IDkqc6gKgNc75ob3x2E/yrdXDNgxc7bC9WLqXktcrLy9
         W/81MpDFcOgAw4lhSFr0OY6dltfzWy3zwAWLOmI8A5rSmRmdUcNlMSnMDeyIYerGhYA7
         3UDSzgdAJzdFR3adMHAWbmd0J9V+Z1L954vD99D5lWJOC8G+xO1jUx6JwO6oHfRc43bM
         4FZ0yyXF+5j+efCrzb31aa3rT2jGR8A3HYKpBGlg2TUo/jOe1YC/0TQ+jC52hizfsMuS
         4a3A==
Content-Disposition: inline
In-Reply-To: <20130421124554.GA8473@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>, Glauber Costa <glommer@parallels.com>, Michel Lespinasse <walken@google.com>, Greg Thelen <gthelen@google.com>

Hey, Michal.

On Sun, Apr 21, 2013 at 02:46:06PM +0200, Michal Hocko wrote:
> [I am terribly jet lagged so I should probably postpone any serious
> thinking for few days but let me try]

Sorry about raising a flame war so soon after the conference week.
None of these is really urgent, so please take your time.

> The current implementation stores all subtrees that are over the soft
> limit in a tree sorted by how much they are excessing the limit. Have
> a look at mem_cgroup_update_tree and its callers (namely down from
> __mem_cgroup_commit_charge). My patch _preserves_ this behavior it just
> makes the code much saner and as a bonus it doesn't touch groups (not
> hierarchies) under the limit unless necessary which wasn't the case
> previously.

What you describe is already confused.  What does that knob mean then?
Google folks seem to think it's an allocation guarantee but global
reclaim is broken and breaches the configuration (which I suppose is
arising from their usage of memcg) and I don't understand what your
definition of the knob is apart from the description of what's
implemented now, which apparently is causing horrible confusion on all
the involved parties.

> So yes, I can understand why this is confusing for you. The soft limit
> semantic is different because the limit is/was considered only if it
> is/was in excess.
> 
> Maybe I was using word _guarantee_ too often to confuse you, I am sorry
> if this is the case. The guarantee part comes from the group point of
> view. So the original semantic of the hierarchical behavior is
> unchanged.

I don't care what word you use.  There are two choices.  Pick one and
stick with it.  Don't make it something which inhibits reclaim if
under limit for leaf nodes but behaves somewhat differently if an
ancestor is under pressure or whatever.  Just pick one.  It is either
an reclaim inhibitor or actual soft limit.

> What to does it mean that an inter node is under the soft limit
> for the subhierarchy is questionable and there are usecases where

It's not frigging questionable.  You're just horribly confused.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
