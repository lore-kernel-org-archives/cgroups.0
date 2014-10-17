From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [patch 4/5] mm: memcontrol: continue cache reclaim from
 offlined groups
Date: Thu, 16 Oct 2014 21:42:40 -0700
Message-ID: <20141016214240.ade3712f.akpm@linux-foundation.org>
References: <1413303637-23862-1-git-send-email-hannes@cmpxchg.org>
	<1413303637-23862-5-git-send-email-hannes@cmpxchg.org>
	<20141015152555.GI23547@dhcp22.suse.cz>
	<20141017030221.GA8506@phnom.home.cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141017030221.GA8506-HTCKtW7iVlxqnrmGgq4/JMIURNUf+fel@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 16 Oct 2014 23:02:21 -0400 Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:

> Andrew, could you update the changelog in place to have that paragraph
> read
> 
> Since c2931b70a32c ("cgroup: iterate cgroup_subsys_states directly")
> css iterators now also include offlined css, so memcg iterators can be
> changed to include offlined children during reclaim of a group, and
> leftover cache can just stay put.

Done.
