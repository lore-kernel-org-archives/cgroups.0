From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH -mm -v7 2/9] mm, memcg: Support to charge/uncharge
 multiple swap entries
Date: Wed, 29 Mar 2017 12:57:22 -0400
Message-ID: <20170329165722.GB31821@cmpxchg.org>
References: <20170328053209.25876-1-ying.huang@intel.com>
 <20170328053209.25876-3-ying.huang@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OmFyFwrC1gVjLWTtvjPg55E4ggS7eLJRCXumQyEfWBc=; b=ok6xeSVUOrLdy2wtXvaA4i+74Q
        XNYjxNRWo+5i6jj+2YFHhGLQO0yTIMitwVcW3pdNcJ7aimkx3MaltZusL0R1G4BBpLGc86mFKUcax
        Csfhy7oJ6go7xC2InfBuB8rmVZk46wImN5/tkAXzq0SqKLsjuOT8DeELx0t8npy67L0g=;
Content-Disposition: inline
In-Reply-To: <20170328053209.25876-3-ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Mar 28, 2017 at 01:32:02PM +0800, Huang, Ying wrote:
> @@ -5908,16 +5907,19 @@ void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
>  		css_put(&memcg->css);
>  }
>  
> -/*
> - * mem_cgroup_try_charge_swap - try charging a swap entry
> +/**
> + * mem_cgroup_try_charge_swap - try charging a set of swap entries
>   * @page: page being added to swap
> - * @entry: swap entry to charge
> + * @entry: the first swap entry to charge
> + * @nr_entries: the number of swap entries to charge
>   *
> - * Try to charge @entry to the memcg that @page belongs to.
> + * Try to charge @nr_entries swap entries starting from @entry to the
> + * memcg that @page belongs to.
>   *
>   * Returns 0 on success, -ENOMEM on failure.
>   */
> -int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry)
> +int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry,
> +			       unsigned int nr_entries)

I've pointed this out before, but there doesn't seem to be a reason to
pass @nr_entries when we have the struct page. Why can't this function
just check PageTransHuge() by itself?
