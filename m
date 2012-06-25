From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH v3 1/4] memcg: cleanup useless LRU_ALL_EVICTABLE
Date: Mon, 25 Jun 2012 18:59:49 +0900
Message-ID: <4FE83695.6010007@jp.fujitsu.com>
References: <1340613812-9458-1-git-send-email-liwp.linux@gmail.com> <20120625093328.GD19805@tiehlicka.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120625093328.GD19805-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Arun Sharma <asharma-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

(2012/06/25 18:33), Michal Hocko wrote:
> Marking this patch as memcg is quite misleading. mm is more suitable.
>
> On Mon 25-06-12 16:43:32, Wanpeng Li wrote:
>> From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>>
>> Since LRU_ALL_EVICTABLE is useless, just remove it.
>
> It's really strange but I do not see any usage of this except for it's
> introduction. So agreed to remove it.
>
>> Add LRU_ALL_UNEVICTABLE to mask unevictable pages.
>
> Does it really make sense to introduce just for two uses in a single
> function?
>

I don't think so.

I doubt LRU_ALL_UNEVICTABLE implies there are other UNEVICTABLE LRUS
other than LRU_UNEVICTABLE.

For example, LRU_ALL_UNEVICTABLE means
	if total_swap==0, UNEVICTABLE+ANON
	if total_swap!=0, UNEVICTABLE,

This will have its own meanings...but I don't see there are any users.

Thanks,
-Kame

