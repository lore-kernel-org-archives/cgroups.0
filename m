From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 2/6] memcg: Don't account root memcg CACHE/RSS stats
Date: Wed, 20 Mar 2013 11:07:45 +0400
Message-ID: <51496041.4090900@parallels.com>
References: <1363082773-3598-1-git-send-email-handai.szj@taobao.com> <1363082977-3753-1-git-send-email-handai.szj@taobao.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1363082977-3753-1-git-send-email-handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On 03/12/2013 02:09 PM, Sha Zhengju wrote:
> If memcg is enabled and no non-root memcg exists, all allocated pages
> belong to root_mem_cgroup and go through root memcg statistics routines
> which brings some overheads.
> 
> So for the sake of performance, we can give up accounting stats of root
> memcg for MEM_CGROUP_STAT_CACHE/RSS and instead we pay special attention
> to memcg_stat_show() while showing root memcg numbers:
> as we don't account root memcg stats anymore, the root_mem_cgroup->stat
> numbers are actually 0. So we fake these numbers by using stats of global
> state and all other memcg. That is for root memcg:
> 
> 	nr(MEM_CGROUP_STAT_CACHE) = global_page_state(NR_FILE_PAGES) -
>                               sum_of_all_memcg(MEM_CGROUP_STAT_CACHE);
> 
> Rss pages accounting are in the similar way.
> 

Well,

The problem is that statistics is not the only cause for overhead. We
will still incur in in the whole charging operation, and the same for
uncharge. There is memory overhead from page_cgroup, etc.

So my view is that this patch is far from complete.
