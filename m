From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: rmap: fix huge file mmap accounting in the memcg
 stats
Date: Fri, 24 Mar 2017 09:46:07 -0400
Message-ID: <20170324134607.GA9994@cmpxchg.org>
References: <20170322005111.3156-1-hannes@cmpxchg.org>
 <20170324110755.evvbeetf44h72p43@node.shutemov.name>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Zm81PCmSmX4UGkZEUi9+sDSMH42jNwugxj8+mqdwEPc=; b=seYsxKHtuv8wNXrj9MZj7AiaJb
	072nSr95hUlLgwPcE+pZrwd8qvzZyf3WYp/7OflJxyZH6SP/Jl0xXECENRRccZhUPsJgUFU5YYawU
	aXSswB9ZV/UW7yICScPDl1AWqoQnEOmj68WLmanpTqGq5Ps1cpM5pzvLsr+9i8u3hwlg=;
Content-Disposition: inline
In-Reply-To: <20170324110755.evvbeetf44h72p43@node.shutemov.name>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Fri, Mar 24, 2017 at 02:07:55PM +0300, Kirill A. Shutemov wrote:
> On Tue, Mar 21, 2017 at 08:51:11PM -0400, Johannes Weiner wrote:
> > Huge pages are accounted as single units in the memcg's "file_mapped"
> > counter. Account the correct number of base pages, like we do in the
> > corresponding node counter.
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Sorry for missing that:
> 
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

Thanks!

> Do we want it into stable?
> 
> Cc: <stable@vger.kernel.org>	[4.8+]

Yep, that makes sense.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
