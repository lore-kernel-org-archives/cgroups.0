From: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/6] memcg: replace unsigned long by u64 to avoid overflow
Date: Mon, 25 Jun 2012 12:46:38 +0800
Message-ID: <20120625044638.GB3894@kernel>
References: <1340432134-5178-1-git-send-email-liwp.linux@gmail.com>
 <20120623081514.GJ27816@cmpxchg.org>
 <20120623090339.GA6184@kernel>
 <20120623092654.GL27816@cmpxchg.org>
 <4FE7E7FA.80702@jp.fujitsu.com>
Reply-To: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=xmmsZsygc00WH1EqP8CUwS7CJAFzVXQLZALKxdE+IfE=;
        b=b40N8unSe66REjdUfMvfw7SrqttIQYDgW3XHSBP7A62C6dxs000y4PuHJZC/KCmLcS
         Z+uke0Vb9Xok9poDhIhnYjNTRxOB1bUhc/asqay/uJzWzx41t7MNmTZQ/sYu4YXJiAnF
         ME5CqqjHJfLdYIfXH0BeBtTrLpQPMYLmYmHRPeY9Q2Q/cwk/osBA+by04sniso3O/76K
         1nJoRhM6w1vK06FRTC7A+TMBtTQF8713E9tOtlbP4Z0coN36/k0w/r/JoOAgcn1ZIxQ9
         5RkOSDYwmoMddb4SpDoVJXii7SCNxgZe/1jcizGOD/N4KhEuISl5S5wxGTlxjwWCCSED
         K0kw==
Content-Disposition: inline
In-Reply-To: <4FE7E7FA.80702-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mel-wPRd99KPJ+uzQB+pC5nmwQ@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gavin Shan <shangw-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Wanpen Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Mon, Jun 25, 2012 at 01:24:26PM +0900, Kamezawa Hiroyuki wrote:
>(2012/06/23 18:26), Johannes Weiner wrote:
>>On Sat, Jun 23, 2012 at 05:03:39PM +0800, Wanpeng Li wrote:
>>>On Sat, Jun 23, 2012 at 10:15:14AM +0200, Johannes Weiner wrote:
>>>>On Sat, Jun 23, 2012 at 02:15:34PM +0800, Wanpeng Li wrote:
>>>>>From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>>>>>
>>>>>Since the return value variable in mem_cgroup_zone_nr_lru_pages and
>>>>>mem_cgroup_node_nr_lru_pages functions are u64, so replace the return
>>>>>value of funtions by u64 to avoid overflow.
>>>>
>>>>I wonder what 16 TB of memory must think running on a 32-bit kernel...
>>>>"What is this, an address space for ants?"
>>>
>>>Hi Johannes,
>>>
>>>You mean change all u64 in memcg to unsigned long? or something I
>>>miss....
>>
>>Not _all_ of them, we have some that count bytes.  But those counting
>>pages should probably be ulong, yes.
>>
>>I think Kame added the ones that you wanted to adjust the surroundings
>>for in particular, so let's ask him.  Kame?
>>
>
>I've been using 'unsigned long' for the number of pages and 'u64' for the number of
>bytes. I think it's enough and it should be. I don't have any reason to use u64 for
>the number of pages on 32bit archs.
>If 'bytes' are handled by 'unsigned long', please fix it.
>
>BTW, zone_page_state()::/include/linux/vmstat.h returns 'unsigned long'.
>If you want to change this in memcg, please change zone's ones first.

Thank you for your comments Kame! :-) I will do this in next version.
Is any suggestion about patches in this patchset.

Regards,
Wanpeng Li

>
>Thanks,
>-Kame
>
