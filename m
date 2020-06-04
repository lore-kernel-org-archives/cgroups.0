From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH mm v6 4/4] mm: automatically penalize tasks with high
 swap use
Date: Thu, 4 Jun 2020 17:57:00 +0200
Message-ID: <20200604155700.GD4362@dhcp22.suse.cz>
References: <20200527195846.102707-1-kuba@kernel.org>
 <20200527195846.102707-5-kuba@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200527195846.102707-5-kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Wed 27-05-20 12:58:46, Jakub Kicinski wrote:
> Add a memory.swap.high knob, which can be used to protect the system
> from SWAP exhaustion. The mechanism used for penalizing is similar
> to memory.high penalty (sleep on return to user space).
> 
> That is not to say that the knob itself is equivalent to memory.high.
> The objective is more to protect the system from potentially buggy
> tasks consuming a lot of swap and impacting other tasks, or even
> bringing the whole system to stand still with complete SWAP
> exhaustion. Hopefully without the need to find per-task hard
> limits.
> 
> Slowing misbehaving tasks down gradually allows user space oom
> killers or other protection mechanisms to react. oomd and earlyoom
> already do killing based on swap exhaustion, and memory.swap.high
> protection will help implement such userspace oom policies more
> reliably.
> 
> We can use one counter for number of pages allocated under
> pressure to save struct task space and avoid two separate
> hierarchy walks on the hot path. The exact overage is
> calculated on return to user space, anyway.
> 
> Take the new high limit into account when determining if swap
> is "full". Borrowing the explanation from Johannes:
> 
>   The idea behind "swap full" is that as long as the workload has plenty
>   of swap space available and it's not changing its memory contents, it
>   makes sense to generously hold on to copies of data in the swap
>   device, even after the swapin. A later reclaim cycle can drop the page
>   without any IO. Trading disk space for IO.
> 
>   But the only two ways to reclaim a swap slot is when they're faulted
>   in and the references go away, or by scanning the virtual address space
>   like swapoff does - which is very expensive (one could argue it's too
>   expensive even for swapoff, it's often more practical to just reboot).
> 
>   So at some point in the fill level, we have to start freeing up swap
>   slots on fault/swapin. Otherwise we could eventually run out of swap
>   slots while they're filled with copies of data that is also in RAM.
> 
>   We don't want to OOM a workload because its available swap space is
>   filled with redundant cache.
> 
> Signed-off-by: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

I am sorry for being late here but thanks for adding clarifications
which make the semantic much more clear now! Also thanks for simplifying 
the throttling implementation. If a different scaling is needed then
this can be added later on.

I do not see any other problems with the patch.

Thanks!
-- 
Michal Hocko
SUSE Labs
