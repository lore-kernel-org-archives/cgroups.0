From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: add unlikely to mercg->move_charge_at_immigrate
Date: Mon, 18 Jun 2012 17:09:36 +0400
Message-ID: <4FDF2890.3020004@parallels.com>
References: <1340025022-7272-1-git-send-email-liwp.linux@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340025022-7272-1-git-send-email-liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gavin Shan <shangw-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

On 06/18/2012 05:10 PM, Wanpeng Li wrote:
> From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>
> move_charge_at_immigrate feature is disabled by default. Charges
> are moved only when you move mm->owner and it also add additional
> overhead.

How big is this overhead?

That's hardly a fast path. And if it happens to matter, it will be just 
bigger when you enable it, and the compiler start giving the wrong hints 
to the code.
