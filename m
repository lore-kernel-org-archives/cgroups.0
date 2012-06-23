From: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/6] memcg: move recent_rotated and recent_scanned
 informations
Date: Sat, 23 Jun 2012 18:13:28 +0800
Message-ID: <20120623101328.GA2153@kernel>
References: <1340432259-5317-1-git-send-email-liwp.linux@gmail.com>
 <20120623095112.GO27816@cmpxchg.org>
Reply-To: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Sn9GOfzOmPo/UMq3HYFC9Be7J6+LqIKBc8z0/dV4xv8=;
        b=ywGcn4+WdrYC4e7iGVfv1Au0NswkuQSSeUrngiBYdRDuJdwt/DElPnD3VSTP1x3axG
         FlNIk+yJPJK4cI43dX9x7td7UsNQEcVbBu6g54UkCTTJmkrG0D+OLbG9m3DPvSWN2B3z
         nTd45X5nDV5IGggCZ7xOPUq2+b6Nu7f7iCH/RbPzSFM06NsVGiCXYzgmJgFjf27c5SyK
         120u2UB5nrTMtqfy7stg791KadtFZwAkBWYgG/BiiLLsHmApGWP2k3EP42Q50UXurnmo
         yUKlkh1+rwrX22ajpGBo7gMAxouTiSjjG6q8voMxZUvZnw+Bg9qU5j2oT6PSxC9aA/n3
         Zzsw==
Content-Disposition: inline
In-Reply-To: <20120623095112.GO27816-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mel-wPRd99KPJ+uzQB+pC5nmwQ@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gavin Shan <shangw-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Sat, Jun 23, 2012 at 11:51:13AM +0200, Johannes Weiner wrote:
>On Sat, Jun 23, 2012 at 02:17:39PM +0800, Wanpeng Li wrote:
>> From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> 
>> Move recent_rotated and recent_scanned prints next to inactive_anon,
>> ative_anon, inactive_file, active_file, and unevictable prints to
>> save developers' time. Since they have to go a long way(when cat memory.stat)
>> to find recent_rotated and recent_scanned prints which has relationship
>> with the memory cgroup we care. These prints are behind total_* which
>> not just focus on the memory cgroup we care currently.
>
>The hierarchical stats are about that memcg, too.  And I don't want to

Move recent_rotated and recent_scanned prints next to file lru lists
just because the pageout code in vmscan.c keeps track of how many of 
the mem/swap backed and file backed pages are referenced, and the 
higher the rotated/scanned ratio, the more valuable that cache is. 
Move five lru lists and associated debug informations together can 
make things convenience. :-)

Regards,
Wanpeng Li

>turn on debugging and then look for the extra information hiding in
>the middle of regular stats.
