From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: memcg: softlimit on internal nodes
Date: Tue, 23 Apr 2013 14:51:01 +0200
Message-ID: <20130423125101.GE8001@dhcp22.suse.cz>
References: <20130420002620.GA17179@mtj.dyndns.org>
 <20130420031611.GA4695@dhcp22.suse.cz>
 <20130421022321.GE19097@mtj.dyndns.org>
 <CANN689GuN_5QdgPBjr7h6paVmPeCvLHYfLWNLsJMWib9V9G_Fw@mail.gmail.com>
 <20130422042445.GA25089@mtj.dyndns.org>
 <20130422153730.GG18286@dhcp22.suse.cz>
 <20130422154620.GB12543@htj.dyndns.org>
 <20130422155454.GH18286@dhcp22.suse.cz>
 <CANN689Hz5A+iMM3T76-8RCh8YDnoGrYBvtjL_+cXaYRR0OkGRQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANN689Hz5A+iMM3T76-8RCh8YDnoGrYBvtjL_+cXaYRR0OkGRQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Tue 23-04-13 02:58:19, Michel Lespinasse wrote:
[...]
> However, your proposal takes that weak guarantee away as soon as one
> tries to use cgroup hierarchies with it, because it reclaims from
> every child cgroup as soon as the parent hits its soft limit.

Reading this again I am really getting confused. The primary objection
used to be that under-soft-limit inter-node subtree shouldn't be
reclaimed although there are children over their soft limits. Now we
have moved to over-limit inder-node shouldn't hammer its subtree?
-- 
Michal Hocko
SUSE Labs
