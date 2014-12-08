From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol.c:  Cleaning up function that are not
 used anywhere
Date: Mon, 8 Dec 2014 11:02:40 -0500
Message-ID: <20141208160240.GA21664@phnom.home.cmpxchg.org>
References: <1417884356-3086-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1417884356-3086-1-git-send-email-rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Dec 06, 2014 at 05:45:56PM +0100, Rickard Strandqvist wrote:
> Remove function mem_cgroup_lru_names_not_uptodate() that is not used anywhere.
> And move BUILD_BUG_ON() to the beginning of memcg_stat_show() instead.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>

Looks good, thanks for following up.

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
