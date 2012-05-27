From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V6 03/14] hugetlbfs: Add an inline helper for finding
 hstate index
Date: Mon, 28 May 2012 01:37:57 +0530
Message-ID: <20120527200757.GA7631@skywalker.linux.vnet.ibm.com>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1334573091-18602-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1205241420410.24113@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205241420410.24113@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Thu, May 24, 2012 at 02:22:27PM -0700, David Rientjes wrote:
> On Mon, 16 Apr 2012, Aneesh Kumar K.V wrote:
> 
> > From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> > 
> > Add an inline helper and use it in the code.
> > 
> > Acked-by: Michal Hocko <mhocko@suse.cz>
> > Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> I like the helper function, but you missed using it in 
> hugetlb_init().
> 

Will do this as an add on patc on top

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4b90dd5..58eead5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1891,7 +1891,7 @@ static int __init hugetlb_init(void)
 		if (!size_to_hstate(default_hstate_size))
 			hugetlb_add_hstate(HUGETLB_PAGE_ORDER);
 	}
-	default_hstate_idx = size_to_hstate(default_hstate_size) - hstates;
+	default_hstate_idx = hstate_index(size_to_hstate(default_hstate_size));
 	if (default_hstate_max_huge_pages)
 		default_hstate.max_huge_pages = default_hstate_max_huge_pages;
 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
