From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch -v4 4/8] memcg: enhance memcg iterator to support
 predicates
Date: Tue, 4 Jun 2013 22:48:07 +0200
Message-ID: <20130604204807.GA13231@dhcp22.suse.cz>
References: <1370254735-13012-1-git-send-email-mhocko@suse.cz>
 <1370254735-13012-5-git-send-email-mhocko@suse.cz>
 <20130604010737.GF29989@mtj.dyndns.org>
 <20130604134523.GH31242@dhcp22.suse.cz>
 <20130604193619.GA14916@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=VYZ+dE7uqw2E2bFTLgo9lf24SbrLjO9uyCS31cvDM7I=;
        b=neaugJQp8UaFM0epuTRvvJk9AKRp+GlSZteD7bAMujoq6tX8gsDb2PcIs0IaUB5Ry8
         XzoFWn34wci/+ggLTPmnCdv0I4M5Clt9fpZpFwHmhWC2a4mQVddzyxeINt12wb86hTx5
         NwLMTTExgVRaddOpOpGddPQ5gqhUdnhdVOWgb5dyRGSFoqOK+l8HmpJMUZ3OxGhAIo41
         pG/2TtfZZngvKDkjcYAvbT7CD7BfWSM6bgaiK+KKTFVVrk6mQ2rjGy+QJXuZAjl3w4ex
         0Kb0vc7WQ040nDi3lrMseJgA2juCDD0ziL2a697i0Ujpz14cWWW4lIaUXWeH4OFRY5YJ
         9esw==
Content-Disposition: inline
In-Reply-To: <20130604193619.GA14916-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Tue 04-06-13 12:36:19, Tejun Heo wrote:
> Hey, Michal.
> 
> On Tue, Jun 04, 2013 at 03:45:23PM +0200, Michal Hocko wrote:
> > Is this something that you find serious enough to block this series?
> > I do not want to push hard but I would like to settle with something
> > finally. This is taking way longer than I would like.
> 
> I really don't think memcg can afford to add more mess than there
> already is.  Let's try to get things right with each change, please.

Is this really about inside vs. outside skipping? I think this is a
general improvement to the code. I really prefer not duplicating common
code and skipping handling is such a code (we have a visitor which can
control the walk). With a side bonus that it doesn't have to pollute
vmscan more than necessary.

Please be more specific about _what_ is so ugly about this interface so
that it matters so much.

> Can we please see how the other approach would look like?  I have a
> suspicion that it's likely be simpler but the devils are in the
> details and all...
>
> > > The iteration only depends on the current position.  Can't you factor
> > > out skipping part outside the function rather than rolling into this
> > > monstery thing with predicate callback?  Just test the condition
> > > outside and call a function to skip whatever is necessary?
> > > 
> > > Also, cgroup_rightmost_descendant() can be pretty expensive depending
> > > on how your tree looks like. 
> > 
> > I have no problem using something else. This was just the easiest to
> > use and it behaves more-or-less good for hierarchies which are more or
> > less balanced. If this turns out to be a problem we can introduce a
> > new cgroup_skip_subtree which would get to last->sibling or go up the
> > parent chain until there is non-NULL sibling. But what would be the next
> > selling point here if we made it perfect right now? ;)
> 
> Yeah, sure thing.  I was just worried because the skipping here might
> not be as good as the code seems to indicate.  There will be cases,
> which aren't too uncommon, where the skipping doesn't save much
> compared to just continuing the pre-order walk, so....  And nobody
> would really notice it unless [s]he looks really hard for it, which is
> the more worrisome part for me.  Maybe just stick a comment there
> explaining that we probably want something better in the future?

Sure thing. I will stick there a comment:

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 91740f7..43e955a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1073,6 +1073,14 @@ skip_node:
 			prev_cgroup = next_cgroup;
 			goto skip_node;
 		case SKIP_TREE:
+			/*
+			 * cgroup_rightmost_descendant is not an optimal way to
+			 * skip through a subtree (especially for imbalanced
+			 * trees leaning to right) but that's what we have right
+			 * now. More effective solution would be traversing
+			 * right-up for first non-NULL without calling
+			 * cgroup_next_descendant_pre afterwards.
+			 */
 			prev_cgroup = cgroup_rightmost_descendant(next_cgroup);
 			goto skip_node;
 		case VISIT:

Better?
-- 
Michal Hocko
SUSE Labs
