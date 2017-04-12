From: "Hillf Danton" <hillf.zj@alibaba-inc.com>
Subject: Re: [RFC 5/6] mm, cpuset: always use seqlock when changing task's nodemask
Date: Wed, 12 Apr 2017 16:10:53 +0800
Message-ID: <0c2d01d2b364$4eaba920$ec02fb60$@alibaba-inc.com>
References: <20170411140609.3787-1-vbabka@suse.cz> <20170411140609.3787-6-vbabka@suse.cz>
Reply-To: "Hillf Danton" <hillf.zj@alibaba-inc.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=alibaba-inc.com; s=default;
	t=1491984658; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=GrA0ELf9uSB2Fok/UNceMROQrqk22bmUij9tKZ/YEsk=;
	b=gX8H2lZoQQHRFNGfHo9gKv6qWVmQBmIhcXmtQrV7BKDBtXjjuUQMopVxESEs5UCbNppx4AJmY51o0JPBClJ1SrABIqEM370U2fd0HtRCJkwk9063+lROhWsChVMIMBxksO3Gv4PMNKM8M/sb215P9x9bqAYXZOy3ACEJWXMTBuU=
In-Reply-To: <20170411140609.3787-6-vbabka@suse.cz>
Content-Language: zh-cn
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 'Vlastimil Babka' <vbabka@suse.cz>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 'Li Zefan' <lizefan@huawei.com>, 'Michal Hocko' <mhocko@kernel.org>, 'Mel Gorman' <mgorman@techsingularity.net>, 'David Rientjes' <rientjes@google.com>, 'Christoph Lameter' <cl@linux.com>, 'Hugh Dickins' <hughd@google.com>, 'Andrea Arcangeli' <aarcange@redhat.com>, 'Anshuman Khandual' <khandual@linux.vnet.ibm.com>, "'Kirill A. Shutemov'" <kirill.shutemov@linux.intel.com>

On April 11, 2017 10:06 PM Vlastimil Babka wrote: 
> 
>  static void cpuset_change_task_nodemask(struct task_struct *tsk,
>  					nodemask_t *newmems)
>  {
> -	bool need_loop;
> -
>  	task_lock(tsk);
> -	/*
> -	 * Determine if a loop is necessary if another thread is doing
> -	 * read_mems_allowed_begin().  If at least one node remains unchanged and
> -	 * tsk does not have a mempolicy, then an empty nodemask will not be
> -	 * possible when mems_allowed is larger than a word.
> -	 */
> -	need_loop = task_has_mempolicy(tsk) ||
> -			!nodes_intersects(*newmems, tsk->mems_allowed);
> 
> -	if (need_loop) {
> -		local_irq_disable();
> -		write_seqcount_begin(&tsk->mems_allowed_seq);
> -	}
> +	local_irq_disable();
> +	write_seqcount_begin(&tsk->mems_allowed_seq);
> 
> -	nodes_or(tsk->mems_allowed, tsk->mems_allowed, *newmems);
>  	mpol_rebind_task(tsk, newmems);
>  	tsk->mems_allowed = *newmems;
> 
> -	if (need_loop) {
> -		write_seqcount_end(&tsk->mems_allowed_seq);
> -		local_irq_enable();
> -	}
> +	write_seqcount_end(&tsk->mems_allowed_seq);
> 
Doubt if we'd listen irq again.

>  	task_unlock(tsk);
>  }
> --
> 2.12.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
