From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v3 05/28] memcg: Reclaim when more than one page
 needed.
Date: Tue, 29 May 2012 09:19:02 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1205290917230.4666@router.home>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-6-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1338301146; bh=ieyAKC1Ibzo9Y683Xt08SqcxpVUlMR8GfDabyqxnw2k=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=MGWRqV19863LG7hlSBXI/EBvIai/858ZB2lO/e3Zl9yWHVx4PdEYgI1tYtWJixPIb5sQs4k2t9+9rsMxCiN4gshhOfAtQoneo6jIYwf9HMP1vH45f0Oku70OMAzpHAfeZ92LlU+DaLmsKv9az8dNr9zsG2OFLGxkGeI0K4Mkwzk=
In-Reply-To: <1337951028-3427-6-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>, Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org, David Rientjes <rientjes@google.com>

On Fri, 25 May 2012, Glauber Costa wrote:

> From: Suleiman Souhlal <ssouhlal@FreeBSD.org>
>
> mem_cgroup_do_charge() was written before slab accounting, and expects
> three cases: being called for 1 page, being called for a stock of 32 pages,
> or being called for a hugepage.  If we call for 2 pages (and several slabs
> used in process creation are such, at least with the debug options I had),
> it assumed it's being called for stock and just retried without reclaiming.

Slab pages are allocated up to order 3 (PAGE_ALLOC_COSTLY_ORDER). That is
8 pages.

>  	 * unlikely to succeed so close to the limit, and we fall back
>  	 * to regular pages anyway in case of failure.
>  	 */
> -	if (nr_pages == 1 && ret)
> +	if (nr_pages <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER) && ret) {
> +		cond_resched();
>  		return CHARGE_RETRY;
> +	}
>
>  	/*
>  	 * At task move, charge accounts can be doubly counted. So, it's

Ok. That looks correct.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
