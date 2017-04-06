From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: Re: [PATCH 4/4] mm: memcontrol: use node page state naming scheme
 for memcg
Date: Thu, 6 Apr 2017 12:01:34 +0300
Message-ID: <20170406090134.GD2268@esperanza>
References: <20170404220148.28338-1-hannes@cmpxchg.org>
 <20170404220148.28338-4-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZMzPcO41k7QADlQHjpvls/Ew4Gc6CAMkcHMlXYloXH4=;
        b=cmJYUbw9lnNijrUWha5URuKW1M1ZqASb+5jcPBoYQMWGVfmtYXNyeiI6gPe72/1TSX
         guxL6zoyjdknseaYXmgilqIsFUVB36YB7I66lf6DYgf697ATox0XQZtxTHkW89VwIzCn
         bky9uT/vurLqTgJH2ze3v2d8alpgpOiS5DDZwDxdMBeS0NoeG4wgx6tUowmbC67BKqXc
         XIGkomptyf7UfRx/Y1HcEH7H/je9tY0i3r1f3s22H0bNkpui7a7Yzv5Gw9FkHmF2jT78
         csgBZW8Z2GYrVs41769ZiT6jliIUruetmXSPeFhgQmS+pl3crDFKiHOZlqOjBAF3DRF5
         zFPA==
Content-Disposition: inline
In-Reply-To: <20170404220148.28338-4-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Apr 04, 2017 at 06:01:48PM -0400, Johannes Weiner wrote:
> The memory controllers stat function names are awkwardly long and
> arbitrarily different from the zone and node stat functions.
> 
> The current interface is named:
> 
>   mem_cgroup_read_stat()
>   mem_cgroup_update_stat()
>   mem_cgroup_inc_stat()
>   mem_cgroup_dec_stat()
>   mem_cgroup_update_page_stat()
>   mem_cgroup_inc_page_stat()
>   mem_cgroup_dec_page_stat()
> 
> This patch renames it to match the corresponding node stat functions:
> 
>   memcg_page_state()		[node_page_state()]
>   mod_memcg_state()		[mod_node_state()]
>   inc_memcg_state()		[inc_node_state()]
>   dec_memcg_state()		[dec_node_state()]
>   mod_memcg_page_state()	[mod_node_page_state()]
>   inc_memcg_page_state()	[inc_node_page_state()]
>   dec_memcg_page_state()	[dec_node_page_state()]
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Looks neat.

Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
