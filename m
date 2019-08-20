From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 01/14] mm/lru: move pgdat lru_lock into lruvec
Date: Tue, 20 Aug 2019 06:40:32 -0700
Message-ID: <20190820134032.GA24642@bombadil.infradead.org>
References: <1566294517-86418-1-git-send-email-alex.shi@linux.alibaba.com>
 <1566294517-86418-2-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=B8LOvtinbA79S6NGUvPmiLsFutes9sDZnF3rriD/5Mw=; b=LqgG+2Wdt6591p4WO0+ZJbqG6
        JVwTerajJO10FChITzDm05wP2VLtJnRRALEsBN7lsG55BOjyn6LJqArhyPi3bXAVRiBtxrTIhVrGR
        dmyT7Q0/4ozU+NDkCoQ/0z2ri/SOjl8JXuwudo7C/gjOUeWgoXYQh6VKjtldhzkcQ1usxbl+YUCJ8
        eYICpPUrQ3PQaIjpM7+lIJBtpr13OYextxKSxKz6NELTmP6n+QIOUH/DRp5wUH9Y4G1TJWigSzkWx
        uLj+hzSg/dfvmLL9uPbxkKLxvFoeoFGigZRqWKfM95/1lnk9qu4wSzinaCZd34957WhaXkdSxjpeI
Content-Disposition: inline
In-Reply-To: <1566294517-86418-2-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, Dan Williams <dan.j.williams@intel.com>, Oscar Salvador <osalvador@suse.de>, Wei Yang <richard.weiyang@gmail.com>, Pavel Tatashin <pasha.tatashin@oracle.com>, Arun KS <arunks@codeaurora.org>, Qian Cai <cai@lca.pw>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Hugh Dickins <hughd@google.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Andrea Arcangeli <aarc>

On Tue, Aug 20, 2019 at 05:48:24PM +0800, Alex Shi wrote:
> +++ b/include/linux/mmzone.h
> @@ -295,6 +295,9 @@ struct zone_reclaim_stat {
>  
>  struct lruvec {
>  	struct list_head		lists[NR_LRU_LISTS];
> +	/* move lru_lock to per lruvec for memcg */
> +	spinlock_t			lru_lock;

This comment makes no sense outside the context of this patch.
