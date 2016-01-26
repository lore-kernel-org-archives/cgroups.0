From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: drop superfluous entry in the per-memcg
 stats array
Date: Tue, 26 Jan 2016 13:30:24 -0800
Message-ID: <20160126133024.07f372dbf8935e03a3035269@linux-foundation.org>
References: <1453841729-29072-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453841729-29072-1-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, 26 Jan 2016 15:55:29 -0500 Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:

> MEM_CGROUP_STAT_NSTATS is just a delimiter for cgroup1 statistics, not
> an actual array entry. Reuse it for the first cgroup2 stat entry, like
> in the event array.
> 
> ...
>
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -51,7 +51,7 @@ enum mem_cgroup_stat_index {
>  	MEM_CGROUP_STAT_SWAP,		/* # of pages, swapped out */
>  	MEM_CGROUP_STAT_NSTATS,
>  	/* default hierarchy stats */
> -	MEMCG_SOCK,
> +	MEMCG_SOCK = MEM_CGROUP_STAT_NSTATS,
>  	MEMCG_NR_STAT,
>  };

The code looks a bit odd.  How come mem_cgroup_stat_names[] ends with
"swap"?  Should MEMCG_SOCK be in there at all?

And the naming is a bit sad.  "MEM_CGROUP_STAT_FILE_MAPPED" maps to
"mapped_file", not "file_mapped".
