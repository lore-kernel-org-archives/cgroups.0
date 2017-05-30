From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/6] mm: vmscan: delete unused pgdat_reclaimable_pages()
Date: Tue, 30 May 2017 14:50:29 -0700
Message-ID: <20170530145029.59cef9048c3c254c9357eff1@linux-foundation.org>
References: <20170530181724.27197-1-hannes@cmpxchg.org>
	<20170530181724.27197-2-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170530181724.27197-2-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>, Michal Hocko <mhocko@suse.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Rik van Riel <riel@redhat.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, 30 May 2017 14:17:19 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> -extern unsigned long pgdat_reclaimable_pages(struct pglist_data *pgdat);

Josef's "mm: make kswapd try harder to keep active pages in cache"
added a new callsite.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
