From: Christoph Lameter <cl@linux.com>
Subject: Re: [patch 3/8] mm, mempolicy: remove per-process flag
Date: Wed, 4 Dec 2013 15:24:52 +0000
Message-ID: <00000142be3633ba-2a459537-58fb-444b-a99f-33ff5e5b2aed-000000@email.amazonses.com>
References: <20131119131400.GC20655@dhcp22.suse.cz> <20131119134007.GD20655@dhcp22.suse.cz> <alpine.DEB.2.02.1311192352070.20752@chino.kir.corp.google.com> <20131120152251.GA18809@dhcp22.suse.cz> <alpine.DEB.2.02.1311201917520.7167@chino.kir.corp.google.com>
 <20131128115458.GK2761@dhcp22.suse.cz> <alpine.DEB.2.02.1312021504170.13465@chino.kir.corp.google.com> <alpine.DEB.2.02.1312032116440.29733@chino.kir.corp.google.com> <alpine.DEB.2.02.1312032117490.29733@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.02.1312032117490.29733@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Tue, 3 Dec 2013, David Rientjes wrote:

> PF_MEMPOLICY is an unnecessary optimization for CONFIG_SLAB users.
> There's no significant performance degradation to checking
> current->mempolicy rather than current->flags & PF_MEMPOLICY in the
> allocation path, especially since this is considered unlikely().

The use of current->mempolicy increase the cache footprint since its in a
rarely used cacheline. This performance issue would occur when memory
policies are not used since that cacheline would then have to be touched
regardless of memory policies be in effect or not. PF_MEMPOLICY was used
to avoid touching the cacheline.


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
