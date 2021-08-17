From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: fix occasional OOMs due to proportional
 memory.low reclaim
Date: Tue, 17 Aug 2021 12:10:16 -0700
Message-ID: <CALvZod7097PHnXoOUZzPpmkASKpL3rV+2UJ+zp-NCdkpVoFTWg@mail.gmail.com>
References: <20210817180506.220056-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Iykb3zVshE4eA6E5ehs/j8Ti0hcMXuAQMSGt4bHNST4=;
        b=P6s2laW+/ySM+LSMlI6J0A+C6LGd7jgwKCV5z/iMsS7y6l+jLs8+qjEGr/Z8ax6QAh
         Wix/NJ09rEJYwkRlnEQ+HCSlhqX/1kNgInBda0vwE049aVDpPX/8tEaleWsaQKdJ8KbA
         VSQeo28B0Ab1hdE0RFxEDc8eOLFlglPnYgmTK8leE5Hd5NFyDmA9erUHNxlRsL58gOze
         KlDAzXxaeRvelYps59sacVX3uaz5Ads0lKSaa6TG79Bmf8j3Wv+b+idvwDEnBKpGvuPA
         8H4XQBuneBsrBm16zIePSYHCISi3yewlxpltvPc6d/1ywkkYxH6EmN63h5wt8BE5LRAr
         gi8g==
In-Reply-To: <20210817180506.220056-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Leon Yang <lnyng-b10kYP2dOMg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

On Tue, Aug 17, 2021 at 11:03 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> We've noticed occasional OOM killing when memory.low settings are in
> effect for cgroups. This is unexpected and undesirable as memory.low
> is supposed to express non-OOMing memory priorities between cgroups.
>
> The reason for this is proportional memory.low reclaim. When cgroups
> are below their memory.low threshold, reclaim passes them over in the
> first round, and then retries if it couldn't find pages anywhere else.
> But when cgroups are slighly above their memory.low setting, page scan

*slightly

> force is scaled down and diminished in proportion to the overage, to
> the point where it can cause reclaim to fail as well - only in that
> case we currently don't retry, and instead trigger OOM.
>
> To fix this, hook proportional reclaim into the same retry logic we
> have in place for when cgroups are skipped entirely. This way if
> reclaim fails and some cgroups were scanned with dimished pressure,

*diminished

> we'll try another full-force cycle before giving up and OOMing.
>
> Reported-by: Leon Yang <lnyng-b10kYP2dOMg@public.gmane.org>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Should this be considered for stable?

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

[...]
>
>  static inline void mem_cgroup_calculate_protection(struct mem_cgroup *root,
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 4620df62f0ff..701106e1829c 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -100,9 +100,12 @@ struct scan_control {
>         unsigned int may_swap:1;
>
>         /*
> -        * Cgroups are not reclaimed below their configured memory.low,
> -        * unless we threaten to OOM. If any cgroups are skipped due to
> -        * memory.low and nothing was reclaimed, go back for memory.low.
> +        * Cgroup memory below memory.low is protected as long as we
> +        * don't threaten to OOM. If any cgroup is reclaimed at
> +        * reduced force or passed over entirely due to its memory.low
> +        * setting (memcg_low_skipped), and nothing is reclaimed as a
> +        * result, then go back back for one more cycle that reclaims

*back
