From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 2/6] mm: memcg: convert numa stat to read_seq_string
 interface
Date: Tue, 15 May 2012 16:43:05 +0200
Message-ID: <20120515144305.GG11346@tiehlicka.suse.cz>
References: <1337018451-27359-1-git-send-email-hannes@cmpxchg.org>
 <1337018451-27359-3-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1337018451-27359-3-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 14-05-12 20:00:47, Johannes Weiner wrote:
> Instead of using the raw seq_file file interface, switch over to the
> read_seq_string cftype callback and let cgroup core code set up the
> seq_file.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  mm/memcontrol.c |   23 +++--------------------
>  1 file changed, 3 insertions(+), 20 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index aef89c1..f0d248b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4345,12 +4345,12 @@ mem_cgroup_get_total_stat(struct mem_cgroup *memcg, struct mcs_total_stat *s)
>  }
>  
>  #ifdef CONFIG_NUMA
> -static int mem_control_numa_stat_show(struct seq_file *m, void *arg)
> +static int mem_control_numa_stat_show(struct cgroup *cont, struct cftype *cft,
> +				      struct seq_file *m)
>  {
>  	int nid;
>  	unsigned long total_nr, file_nr, anon_nr, unevictable_nr;
>  	unsigned long node_nr;
> -	struct cgroup *cont = m->private;
>  	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
>  
>  	total_nr = mem_cgroup_nr_lru_pages(memcg, LRU_ALL);
> @@ -4825,22 +4825,6 @@ static int mem_cgroup_oom_control_write(struct cgroup *cgrp,
>  	return 0;
>  }
>  
> -#ifdef CONFIG_NUMA
> -static const struct file_operations mem_control_numa_stat_file_operations = {
> -	.read = seq_read,
> -	.llseek = seq_lseek,
> -	.release = single_release,
> -};
> -
> -static int mem_control_numa_stat_open(struct inode *unused, struct file *file)
> -{
> -	struct cgroup *cont = file->f_dentry->d_parent->d_fsdata;
> -
> -	file->f_op = &mem_control_numa_stat_file_operations;
> -	return single_open(file, mem_control_numa_stat_show, cont);
> -}
> -#endif /* CONFIG_NUMA */
> -
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
>  static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
>  {
> @@ -4928,8 +4912,7 @@ static struct cftype mem_cgroup_files[] = {
>  #ifdef CONFIG_NUMA
>  	{
>  		.name = "numa_stat",
> -		.open = mem_control_numa_stat_open,
> -		.mode = S_IRUGO,
> +		.read_seq_string = mem_control_numa_stat_show,
>  	},
>  #endif
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
> -- 
> 1.7.10.1
> 

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
