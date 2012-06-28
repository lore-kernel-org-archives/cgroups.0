From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Fork bomb limitation in memcg WAS: Re: [PATCH 00/11] kmem
 controller for memcg: stripped down version
Date: Thu, 28 Jun 2012 15:25:40 -0700
Message-ID: <20120628152540.cc13a735.akpm@linux-foundation.org>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com>
	<20120625162745.eabe4f03.akpm@linux-foundation.org>
	<4FE9621D.2050002@parallels.com>
	<20120626145539.eeeab909.akpm@linux-foundation.org>
	<4FEAD260.4000603@parallels.com>
	<alpine.DEB.2.00.1206271233080.22162@chino.kir.corp.google.com>
	<4FEC1D63.6000903@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <4FEC1D63.6000903@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer@parallels.com>
Cc: David Rientjes <rientjes@google.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>, Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>, Rik van Riel <riel@redhat.com>, Daniel Lezcano <daniel.lezcano@linaro.org>, Kay Sievers <kay.sievers@vrfy.org>, Lennart Poettering <lennart@poettering.net>, "Kirill A. Shutemov" <kirill@shutemov.name>, Kir Kolyshkin <kir@parallels.com>

On Thu, 28 Jun 2012 13:01:23 +0400
Glauber Costa <glommer@parallels.com> wrote:

>
> ...
>

OK, that all sounds convincing ;) Please summarise and capture this
discussion in the [patch 0/n] changelog so we (or others) don't have to
go through this all again.  And let's remember this in the next
patchset!

> Last, but not least, note that it is totally within my interests to
> merge the slab tracking as fast as we can. it'll be a matter of going
> back to it, and agreeing in the final form.

Yes, I'd very much like to have the whole slab implementation in a
reasonably mature state before proceeding too far with this base
patchset.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
