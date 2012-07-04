From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 1/7] memcg: update cgroup memory document
Date: Wed, 4 Jul 2012 14:47:57 +0200
Message-ID: <20120704124757.GE29842@tiehlicka.suse.cz>
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com>
 <1340881055-5511-1-git-send-email-handai.szj@taobao.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1340881055-5511-1-git-send-email-handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Thu 28-06-12 18:57:35, Sha Zhengju wrote:
> From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> 
> Document cgroup dirty/writeback memory statistics.
> 
> The implementation for these new interface routines come in a series
> of following patches.

I would expect this one the be the last...

> 
> Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

Ackedy-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  Documentation/cgroups/memory.txt |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
> index dd88540..24d7e3c 100644
> --- a/Documentation/cgroups/memory.txt
> +++ b/Documentation/cgroups/memory.txt
> @@ -420,6 +420,8 @@ pgpgin		- # of charging events to the memory cgroup. The charging
>  pgpgout		- # of uncharging events to the memory cgroup. The uncharging
>  		event happens each time a page is unaccounted from the cgroup.
>  swap		- # of bytes of swap usage
> +dirty		- # of bytes that are waiting to get written back to the disk.
> +writeback	- # of bytes that are actively being written back to the disk.
>  inactive_anon	- # of bytes of anonymous memory and swap cache memory on
>  		LRU list.
>  active_anon	- # of bytes of anonymous and swap cache memory on active
> -- 
> 1.7.1
> 

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
