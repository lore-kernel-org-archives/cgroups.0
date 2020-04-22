From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 10/18] mm: memcontrol: switch to native NR_ANON_MAPPED
 counter
Date: Wed, 22 Apr 2020 08:28:18 -0400
Message-ID: <20200422122818.GB358439@cmpxchg.org>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
 <20200420221126.341272-11-hannes@cmpxchg.org>
 <20200422065151.GJ6780@js1304-desktop>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f0jbQ8lqR59CMuevuoKxB5R1TbGTdEWUgK8b7QwWaig=;
        b=Y9jYQrTD+KBkq/Ivls3qIPwJpmM6ww7CJ2CqQanRl1MnnhVRBjIC8FJ9elhRHjgaAi
         WtmVdh8KfHvs79NF9myzgKF3YDZQa+Kv8hbQ1f0XynyfQj818YgCxZe6+8zI0tDFDBNA
         roHEPrdPPArwYVRbpIyKS14DdWpNtXoIySwVZMyzDaghAT7+l+UFo8jBdGkcVPgJmNK1
         Ax88OWfXdaPqDS8yCuOPxz5U+/l5yJQY7Kk5uHPF34cinwO+6pSMWgPjLxzO6Hy1mSN2
         GGyZFtH27zc+d6gpMknc6PTpEE65vwc0nQSxz8MYH4htOoqzKxDJB+0noiDXVVFZw7Q+
         CcIA==
Content-Disposition: inline
In-Reply-To: <20200422065151.GJ6780@js1304-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joonsoo Kim <js1304@gmail.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>, Shakeel Butt <shakeelb@google.com>, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Hello Joonsoo,

On Wed, Apr 22, 2020 at 03:51:52PM +0900, Joonsoo Kim wrote:
> On Mon, Apr 20, 2020 at 06:11:18PM -0400, Johannes Weiner wrote:
> > @@ -3768,7 +3761,7 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
> >  
> >  static const unsigned int memcg1_stats[] = {
> >  	NR_FILE_PAGES,
> > -	MEMCG_RSS,
> > +	NR_ANON_MAPPED,
> >  	MEMCG_RSS_HUGE,
> >  	NR_SHMEM,
> >  	NR_FILE_MAPPED,
> > @@ -5395,7 +5388,12 @@ static int mem_cgroup_move_account(struct page *page,
> >  
> >  	lock_page_memcg(page);
> >  
> > -	if (!PageAnon(page)) {
> > +	if (PageAnon(page)) {
> > +		if (page_mapped(page)) {
> 
> This page_mapped() check is newly inserted. Could you elaborate more
> on why mem_cgroup_charge_statistics() doesn't need this check?

MEMCG_RSS extended from when the page was charged until it was
uncharged, but NR_ANON_MAPPED is only counted while the page is really
mapped into page tables. That starts shortly after we charge and ends
shortly before we uncharge, so pages could move between cgroups before
or after they are mapped, while they aren't counted in NR_ANON_MAPPED.

So to know that the page is counted, charge_statistics() only needed
to know that the page is charged and Anon; move_account() also needs
to know that the page is mapped.

> > @@ -1181,7 +1187,7 @@ void page_add_new_anon_rmap(struct page *page,
> >  		/* increment count (starts at -1) */
> >  		atomic_set(&page->_mapcount, 0);
> >  	}
> > -	__mod_node_page_state(page_pgdat(page), NR_ANON_MAPPED, nr);
> > +	__mod_lruvec_page_state(page, NR_ANON_MAPPED, nr);
> >  	__page_set_anon_rmap(page, vma, address, 1);
> >  }
> 
> memcg isn't setup yet and accounting isn't applied to proper memcg.
> Maybe, it would be applied to root memcg. With this change, we don't
> need the mapping to commit the charge so switching the order of
> page_add_new_anon_rmap() and mem_cgroup_commit_charge() will solve the
> issue.

Good catch, it's that dreaded circular dependency. It's fixed two
patches down when I charge anon pages earlier as well. But I'll change
the rmap<->commit order in this patch to avoid the temporary bug.

Thanks for your thorough review!
