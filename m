From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch v2] mm, memcg: periodically schedule when emptying page
 list
Date: Mon, 2 Jun 2014 21:15:10 -0400
Message-ID: <20140603011510.GO2878@cmpxchg.org>
References: <alpine.DEB.2.02.1406021612550.6487@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1406021749590.13910@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=Vb8vTXd1mIawy+HXC9BFVgAFq1F81KMPINSbel3Dw/4=;
	b=ZNpLajAVp8z9oEFpypqbI6hbwOUj0P9ZlQ6Hzc4oGhYGCHpcNFrGOtWcyuhx/sFJGh7LoNWJIFdlMA2d9KCfJ2jQZbWX7Z+2JRo0mXel8ITU4iI7BaqCTVi0fzRPFMG45Hvx6ftUkCqAM8mFNY/6j26nJNWsTWVPyE9jzncWGJw=;
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1406021749590.13910@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Mon, Jun 02, 2014 at 05:51:25PM -0700, David Rientjes wrote:
> From: Hugh Dickins <hughd@google.com>
> 
> mem_cgroup_force_empty_list() can iterate a large number of pages on an lru and 
> mem_cgroup_move_parent() doesn't return an errno unless certain criteria, none 
> of which indicate that the iteration may be taking too long, is met.
> 
> We have encountered the following stack trace many times indicating
> "need_resched set for > 51000020 ns (51 ticks) without schedule", for example:
> 
> 	scheduler_tick()
> 	<timer irq>
> 	mem_cgroup_move_account+0x4d/0x1d5
> 	mem_cgroup_move_parent+0x8d/0x109
> 	mem_cgroup_reparent_charges+0x149/0x2ba
> 	mem_cgroup_css_offline+0xeb/0x11b
> 	cgroup_offline_fn+0x68/0x16b
> 	process_one_work+0x129/0x350
> 
> If this iteration is taking too long, we still need to do cond_resched() even 
> when an individual page is not busy.
> 
> [rientjes@google.com: changelog]
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
