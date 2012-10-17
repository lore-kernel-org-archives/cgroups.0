From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 07/14] mm: Allocate kernel pages to the right memcg
Date: Wed, 17 Oct 2012 15:43:23 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1210171542510.20712@chino.kir.corp.google.com>
References: <1350382611-20579-1-git-send-email-glommer@parallels.com> <1350382611-20579-8-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=njZH5HtqtXz8XAEsrQc0t7T2HKnWj3+eEZGZPf9Y+qc=;
        b=JbJnqoH/Ey3Jfu8m4Oo+Xlg2eA+eg0UXifVlzZLiNcj4qdq+UaEJqLD0RhOg9ILnzS
         zciT8ojBL2DHmcpxorFxs7GoY8EDXRgv1Vw1egi3sGd4x/31JsR3Gic57lesBBxtDWSX
         9FR8tw7S7sQFzanBSRw0bGT1NgVpcOkvNxY8Ur72vbTiuRv8eB8lqMTYQSBME4XBBUEG
         OJ41V1OW/RFGhTC+SXZvQKzKVT8vLMnCe0ytZg3lWi1QUBLeYJ36KiIISIjlgLggafLQ
         hbxedAayVxFanKwls946nXE+cueoXcVrYRujZpm9Ns6ICRopQNUwf1i9f27q0dmLWlxa
         BPjA==
In-Reply-To: <1350382611-20579-8-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Tue, 16 Oct 2012, Glauber Costa wrote:

> When a process tries to allocate a page with the __GFP_KMEMCG flag, the
> page allocator will call the corresponding memcg functions to validate
> the allocation. Tasks in the root memcg can always proceed.
> 
> To avoid adding markers to the page - and a kmem flag that would
> necessarily follow, as much as doing page_cgroup lookups for no reason,
> whoever is marking its allocations with __GFP_KMEMCG flag is responsible
> for telling the page allocator that this is such an allocation at
> free_pages() time. This is done by the invocation of
> __free_accounted_pages() and free_accounted_pages().
> 
> [ v2: inverted test order to avoid a memcg_get leak,
>   free_accounted_pages simplification ]
> [ v4: test for TIF_MEMDIE at newpage_charge ]
> 
> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Acked-by: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
> Acked-by: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> CC: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
> CC: Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>
> CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> CC: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> CC: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
