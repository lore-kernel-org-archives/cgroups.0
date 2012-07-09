From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [patch 01/11] mm: memcg: fix compaction/migration failing due
 to memcg limits
Date: Mon, 09 Jul 2012 11:27:53 +0900
Message-ID: <4FFA41A9.2030806@jp.fujitsu.com>
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org> <1341449103-1986-2-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1341449103-1986-2-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

(2012/07/05 9:44), Johannes Weiner wrote:
> Compaction (and page migration in general) can currently be hindered
> through pages being owned by memory cgroups that are at their limits
> and unreclaimable.
> 
> The reason is that the replacement page is being charged against the
> limit while the page being replaced is also still charged.  But this
> seems unnecessary, given that only one of the two pages will still be
> in use after migration finishes.
> 
> This patch changes the memcg migration sequence so that the
> replacement page is not charged.  Whatever page is still in use after
> successful or failed migration gets to keep the charge of the page
> that was going to be replaced.
> 
> Reported-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
