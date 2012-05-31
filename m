From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V7 01/14] hugetlb: rename max_hstate to
 hugetlb_max_hstate
Date: Thu, 31 May 2012 11:17:03 +0530
Message-ID: <20120531054703.GF24855@skywalker.linux.vnet.ibm.com>
References: <1338388739-22919-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1338388739-22919-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20120531004838.GC401@localhost.localdomain>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20120531004838.GC401@localhost.localdomain>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com, rientjes@google.com, mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>

On Wed, May 30, 2012 at 08:48:40PM -0400, Konrad Rzeszutek Wilk wrote:
> On Wed, May 30, 2012 at 08:08:46PM +0530, Aneesh Kumar K.V wrote:
> > From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> > 
> > Rename max_hstate to hugetlb_max_hstate.  We will be using this from other
> > subsystems like hugetlb controller in later patches.
> > 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Acked-by: Hillf Danton <dhillf@gmail.com>
> > Acked-by: Michal Hocko <mhocko@suse.cz>
> > Cc: Andrea Arcangeli <aarcange@redhat.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> 
> Your SOB needs to be the last thing.

I started with patches in -next, because Andrew had few fixup on top of last
patch series. So I ended up with this format. I have fixed them locally now

-aneesh

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
