From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 15/18] mm/memcg: Add mem_cgroup_folio_lruvec()
Date: Wed, 30 Jun 2021 20:18:33 +0100
Message-ID: <YNzDiTFZpRgKY0CE@casper.infradead.org>
References: <20210630040034.1155892-1-willy@infradead.org>
 <20210630040034.1155892-16-willy@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MsrlUX4klm+FZH6y60kQ4JaEGGQ1KiVKPX9RLosVC/A=; b=oWqhqkrj/cGxMBXJ0t4A7GnsgF
        tzd1jjKb5Jh73NmQgh8pGHPiFZfe1ypWOP3t77n30a3B9TKgK2UvmUt2RSOAx1AHlzGe7nRmtyykH
        1mCpYJSItTlWNiXMPthvzGh4/cMCYhngz0QBrOp4JICQve+BsCJUJeBtGbV52/IbMT7LwvTcvaRaO
        LNguFtTihlOOpYTb0S8/CA9UlGW5FXWFFmna8CdF/4Kmh9+Nk6rDDqiIifK3TN7yCeETVTyFvDEER
        CcjWHjwdytU2FhuibAsB9XVx9yfygHaiby4NRz3EZzziZYsTi21MFe5X7JnvsLBmU+vxnSD6MiJ4J
        HwC/C3CQ==;
Content-Disposition: inline
In-Reply-To: <20210630040034.1155892-16-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Jun 30, 2021 at 05:00:31AM +0100, Matthew Wilcox (Oracle) wrote:
> This is the folio equivalent of mem_cgroup_page_lruvec().

I'm just going through and removing the wrappers.

Why is this function called this?  There's an odd mix of

lock_page_memcg()
page_memcg()
count_memcg_page_event()
split_page_memcg()

vs

mem_cgroup_charge()
mem_cgroup_swapin_charge_page()
mem_cgroup_lruvec()
mem_cgroup_from_task()

I'd really like to call this function folio_lruvec().  It happens to
behave differently if the folio is part of a memcg, but conceptually,
lruvecs aren't particularly tied to memcgs.


... are there any other functions you'd like to rename while I'm
changing pages to folios?
