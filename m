From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v2] mm/memcontrol:rewrite mem_cgroup_page_lruvec()
Date: Mon, 9 Nov 2020 10:00:21 -0800
Message-ID: <20201109180021.GC2285866@carbon.dhcp.thefacebook.com>
References: <20201108143731.GA74138@rlk>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=X4D8oL7DS3umIxJWzscItQ/Iato6n+wr5sxRrOHo1to=;
 b=ZxmuIdRG1zD4j1Sw0Doq7wtkaZGtlVLbjDOAtkKnYMPytUiODNhThzkNgAhJ+Hm0KvpQ
 NXkTi2jgXQ5ZWCeLn9w7VNKSJ/6kNJdibNNDGQJot5Pf+dwE6LlPSRXoZ53UYcRosGdS
 swTx/T1amuMHlc7qgnAjURAACapDM5NibUw= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X4D8oL7DS3umIxJWzscItQ/Iato6n+wr5sxRrOHo1to=;
 b=AVyvgduDKdLh6u5MJhXK3UAzO5zUsmC8Uk1TXY1rpHjZwxcq7UZR0Mi0maqxm4sKHoQPuRSxwTsmY8TxEnhjcyrk5BXM8lLxctNQz2WW4HHgpm0wHcq3c3sKGMu92+k/PFFFC27IivKDgK+rQSUBk5T0DNWZ7IXcUTtcHcMix18=
Content-Disposition: inline
In-Reply-To: <20201108143731.GA74138@rlk>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hui Su <sh_def@163.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, shakeelb@google.com, laoar.shao@gmail.com, chris@chrisdown.name, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Sun, Nov 08, 2020 at 10:37:31PM +0800, Hui Su wrote:
> mem_cgroup_page_lruvec() in memcontrol.c and
> mem_cgroup_lruvec() in memcontrol.h is very similar
> except for the param(page and memcg) which also can be
> convert to each other.
> 
> So rewrite mem_cgroup_page_lruvec() with mem_cgroup_lruvec().
> 
> v1->v2:
> use page_memcg() instead of 'page->mem_cgroup'.
> 
> Acked-by: Michal Hocko <mhocko@suse.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Shakeel Butt <shakeelb@google.com>
> Signed-off-by: Hui Su <sh_def@163.com>

Acked-by: Roman Gushchin <guro@fb.com>

Thanks!
