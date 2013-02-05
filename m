From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2] memcg: reduce the size of struct memcg 244-fold.
Date: Tue, 5 Feb 2013 23:06:09 +0400
Message-ID: <51115821.4020100@parallels.com>
References: <1359009996-5350-1-git-send-email-glommer@parallels.com> <20130205185324.GB6481@cmpxchg.org> <20130205190454.GC3959@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130205190454.GC3959-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 02/05/2013 11:04 PM, Michal Hocko wrote:
> On Tue 05-02-13 13:53:24, Johannes Weiner wrote:
> [...]
>> Subject: [patch] memcg: reduce the size of struct memcg 244-fold morrr fix
>>
>> Remove struct mem_cgroup_lru_info.  It only holds the nodeinfo array
>> and is actively misleading because there is all kinds of per-node
>> stuff in addition to the LRU info in there.  On that note, remove the
>> incorrect comment as well.
>>
>> Move comment about the nodeinfo[0] array having to be the last field
>> in struct mem_cgroup after said array.  Should be more visible when
>> attempting to append new members to the struct.
>>
>> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> 
> Yes, I like this. The info level is just artificatial and without any
> good reason.
> 
> Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> 
Acked-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
