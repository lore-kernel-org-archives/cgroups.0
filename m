From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: Re: [PATCH 2/3] mm: memcontrol: implement lruvec stat functions on
 top of each other
Date: Tue, 7 Nov 2017 12:18:44 +0300
Message-ID: <20171107091844.qiz5lvmdykbinwqx@esperanza>
References: <20171103153336.24044-1-hannes@cmpxchg.org>
 <20171103153336.24044-2-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vyvn90tVpgTFaHJgB4NOGWPnb52TOITuUJgWd4Vho2k=;
        b=eWrTihQqka4A60tx5HfhQKAAb4n9gEetSAXKCPg9H6YLpNoMHbPiQszedNr5XgiySO
         wlHvp4nesELxzUl7Iz09Ghko4wSM4SGCm8QEoo9gR1GVvpCBIWirjlICmz/X/GXtHIsk
         g/9PpJMxOAzw6z8yYZkHMJEguKH/dQpPIZPx6T9O6VobUJkdvSPBNzRH8QNPbKdi33F4
         T7yHUQpRxzMiIB1DFfq61P2sD/8NLJBnYnBrbB4jxcxnK2jf6SILISzp/qtJM2uR1cOM
         KgnnLE9rSSzW1NRAscUgQcdkso/S7iWzwtelff6HcHiotIA+how6MbgIWIs3oB6Ed+Yy
         QEzA==
Content-Disposition: inline
In-Reply-To: <20171103153336.24044-2-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com

On Fri, Nov 03, 2017 at 11:33:35AM -0400, Johannes Weiner wrote:
> The implementation of the lruvec stat functions and their variants for
> accounting through a page, or accounting from a preemptible context,
> are mostly identical and needlessly repetitive.
> 
> Implement the lruvec_page functions by looking up the page's lruvec
> and then using the lruvec function.
> 
> Implement the functions for preemptible contexts by disabling
> preemption before calling the atomic context functions.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  include/linux/memcontrol.h | 44 ++++++++++++++++++++++----------------------
>  1 file changed, 22 insertions(+), 22 deletions(-)

Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
