From: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/5 v2] memcg: replace unsigned long by u64 to avoid
 overflow
Date: Wed, 4 Jul 2012 20:24:27 +0800
Message-ID: <20120704122427.GA21598@kernel>
References: <1340604266-7937-1-git-send-email-liwp.linux@gmail.com>
 <20120625075215.GW27816@cmpxchg.org>
 <4FE82193.1070307@jp.fujitsu.com>
Reply-To: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=M6mFQ0qj2VI2YUwo1Yq9K2XLI6lJ43B65Xlg1vqjU1c=;
        b=owWn/QZEmfQjBmo+IDooOZY0rO9PApqJPlctzaf/D2zSKMs98zE2TfFXCbyruk9+67
         tERnpFvoFWV49NRv+QgiNpRmHjnGmS0Z09slGTVM6WTW9YGQWfQJd3L5VDvU6MWUamH6
         oXCuD+wo9LFP63DsJT5b7/jo44r1y8ARuKjnxd1ap7PZAenPotOrk8rIqmXgtXnbFeTR
         J28cHjuKA7udrLV2C/flfPzCCbpfHjPh+GnK5o5T9Tl6Dv8x/tvjEgzsCeT4HsYAwuLx
         aPLlJO3QmwxrINon34N/jfvWvUgWRpKY7jI/IXWcDKdvmjTz3vgHQR75NZmvb26iDQdQ
         cIOQ==
Content-Disposition: inline
In-Reply-To: <4FE82193.1070307-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, AndrewMorton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Arun Sharma <asharma-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Mon, Jun 25, 2012 at 05:30:11PM +0900, Kamezawa Hiroyuki wrote:
>(2012/06/25 16:52), Johannes Weiner wrote:
>>On Mon, Jun 25, 2012 at 02:04:20PM +0800, Wanpeng Li wrote:
>>>Changlog:
>>>
>>>V2 -> V1:
>>>* fix zone_page_state()::/include/linux/vmstat.h returns 'unsigned long'
>>>
>>>From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>>>
>>>Since the return value variable in mem_cgroup_zone_nr_lru_pages and
>>>mem_cgroup_node_nr_lru_pages functions are u64, so replace the return
>>>value of funtions by u64 to avoid overflow.
>>>
>>>Signed-off-by: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>---
>>>  include/linux/vmstat.h |    2 +-
>>>  mm/memcontrol.c        |    5 ++---
>>>  2 files changed, 3 insertions(+), 4 deletions(-)
>>>
>>>diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
>>>index 65efb92..6a14291 100644
>>>--- a/include/linux/vmstat.h
>>>+++ b/include/linux/vmstat.h
>>>@@ -106,7 +106,7 @@ static inline unsigned long global_page_state(enum zone_stat_item item)
>>>  	return x;
>>>  }
>>>
>>>-static inline unsigned long zone_page_state(struct zone *zone,
>>>+static inline u64 zone_page_state(struct zone *zone,
>>>  					enum zone_stat_item item)
>>>  {
>>>  	long x = atomic_long_read(&zone->vm_stat[item]);
>>
>>We established that there is no known reason to use ulong for page
>>counters and that IF YOU HAD ONE, you should obviously say so and then
>>do a wholesale conversion.  But I don't think you have one.
>>
>>This patch makes absolutely no sense.
>>
>I agree. Then, Nack from me.
>
>Thanks,
>-Kame

static unsigned long
mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
			int nid, unsigned int lru_mask)
{
	u64 total = 0;
	int zid;

	for (zid = 0; zid < MAX_NR_ZONES; zid++)
		total += mem_cgroup_zone_nr_lru_pages(memcg,
					    nid, zid, lru_mask);

	return total;
}

Since you use unsigned long to caculate nr_pages and unsigned long long
to caculate bytes, so u64 in function mem_cgroup_node_nr_lru_pages should 
replace by unsigned long to save kernel stack, right?

Regards,
Wanpeng Li

>
>
