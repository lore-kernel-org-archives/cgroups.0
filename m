From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [patch 6/6] mm: memcg: print statistics from live counters
Date: Wed, 16 May 2012 16:01:31 -0700
Message-ID: <20120516160131.fecb5ddf.akpm@linux-foundation.org>
References: <1337018451-27359-1-git-send-email-hannes@cmpxchg.org>
	<1337018451-27359-7-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337018451-27359-7-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 14 May 2012 20:00:51 +0200
Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:

> Directly print statistics and event counters instead of going through
> an intermediate accumulation stage into a separate array, which used
> to require defining statistic items in more than one place.
> 
> ...
>
> -static const char *memcg_stat_strings[NR_MCS_STAT] = {
> -	"cache",
> -	"rss",
> -	"mapped_file",

Bah humbug, who went and called this mapped_file?

This stat is derived from MEM_CGROUP_STAT_FILE_MAPPED.  But if we
rename MEM_CGROUP_STAT_FILE_MAPPED to MEM_CGROUP_STAT_MAPPED_FILE then
we also need to rename the non-memcg NR_FILE_MAPPED.  And we can't
change the text to "file_mapped" because it's ABI.

> -	"mlock",
> -	"swap",

And "swap" is derived from MEM_CGROUP_STAT_SWAPOUT.  We could rename
that to MEM_CGROUP_STAT_SWAP without trouble.

But both are poor names.  There are two concepts here: a) swapout
events (ie: swap writeout initiation) and b) swapspace usage.  Type a)
only ever counts up, whereas type b) counts up and down.

MEM_CGROUP_STAT_SWAPOUT is actually of type b), but "swapout" is a
misleading term, because it refers to type a) events.

And the human-displayed "swap" is useless because it can refer to
either type a) or type b) events.  These should be called "swapped" and
MEM_CGROUP_STAT_SWAPPED.  But we can't change the userspace interface.

argh, I hate you all!
