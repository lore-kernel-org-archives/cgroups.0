From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2] memcg: reduce the size of struct memcg 244-fold.
Date: Thu, 24 Jan 2013 11:52:10 +0400
Message-ID: <5100E82A.3060608@parallels.com>
References: <1359009996-5350-1-git-send-email-glommer@parallels.com> <xr93r4lbrpdk.fsf@gthelen.mtv.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <xr93r4lbrpdk.fsf-aSPv4SP+Du0KgorLzL7FmE7CuiCeIGUxQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


>> +static inline size_t memcg_size(void)
>> +{
>> +	return sizeof(struct mem_cgroup) +
>> +		nr_node_ids * sizeof(struct mem_cgroup_per_node);
>> +}
>> +
> 
> Tangential question: why use inline here?  I figure that modern
> compilers are good at making inlining decisions.
I was born last century.

No reason, really. Just habit.

