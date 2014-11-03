From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [patch 1/3] mm: embed the memcg pointer directly into struct page
Date: Mon, 3 Nov 2014 23:06:07 +0200
Message-ID: <20141103210607.GA24091@node.dhcp.inet.fi>
References: <1414898156-4741-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=shutemov.name;
	s=default; t=1415048768;
	bh=oU4zWXNv+8Ub1DdnTj6wf9l7BP/W0aT1LKX7dY6FGaw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V8HR/CaIaBBFK+xn1fWw1sX5T7Durz3WmI2bZhnUZWVUcxTqgRRRC2rUGlXC6kp5n
	 zgHCaov+9gX/NjJ3OhLBohIzHN6TM+zHFGXGnlpfMl9qnFUoMnMDv4qcAzQbe36U2e
	 pJqWpU9mCQ7w1wrmcIDGp6qv3TctmvqAWtu1JWb4=
Content-Disposition: inline
In-Reply-To: <1414898156-4741-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>, Tejun Heo <tj@kernel.org>, David Miller <davem@davemloft.net>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, Nov 01, 2014 at 11:15:54PM -0400, Johannes Weiner wrote:
> Memory cgroups used to have 5 per-page pointers.  To allow users to
> disable that amount of overhead during runtime, those pointers were
> allocated in a separate array, with a translation layer between them
> and struct page.
> 
> There is now only one page pointer remaining: the memcg pointer, that
> indicates which cgroup the page is associated with when charged.  The
> complexity of runtime allocation and the runtime translation overhead
> is no longer justified to save that *potential* 0.19% of memory.

How much do you win by the change?

-- 
 Kirill A. Shutemov

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
