From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: vmpressure: fix scan window after SWAP_CLUSTER_MAX
 increase
Date: Wed, 21 Oct 2015 15:38:52 -0400
Message-ID: <20151021193852.GA13511@cmpxchg.org>
References: <1445278381-21033-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1445278381-21033-1-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Oct 19, 2015 at 02:13:01PM -0400, Johannes Weiner wrote:
> mm-increase-swap_cluster_max-to-batch-tlb-flushes.patch changed
> SWAP_CLUSTER_MAX from 32 pages to 256 pages, inadvertantly switching
> the scan window for vmpressure detection from 2MB to 16MB. Revert.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> ---
>  mm/vmpressure.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmpressure.c b/mm/vmpressure.c
> index c5afd57..74f206b 100644
> --- a/mm/vmpressure.c
> +++ b/mm/vmpressure.c
> @@ -38,7 +38,7 @@
>   * TODO: Make the window size depend on machine size, as we do for vmstat
>   * thresholds. Currently we set it to 512 pages (2MB for 4KB pages).
>   */
> -static const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
> +static const unsigned long vmpressure_win = SWAP_CLUSTER_MAX;

Argh, Mel's patch sets SWAP_CLUSTER_MAX to 256, so this should be
SWAP_CLUSTER_MAX * 2 to retain the 512 pages scan window.

Andrew could you please update this fix in-place? Otherwise I'll
resend a corrected version.

Thanks, and sorry about that.
