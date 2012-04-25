From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 17/23] kmem controller charge/uncharge infrastructure
Date: Wed, 25 Apr 2012 11:44:22 -0300
Message-ID: <4F980DC6.9020000@parallels.com>
References: <1334959051-18203-1-git-send-email-glommer@parallels.com> <1335138820-26590-6-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1204231522320.13535@chino.kir.corp.google.com> <20120424142232.GC8626@somewhere> <4F9759C0.1070805@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <4F9759C0.1070805@jp.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, David Rientjes <rientjes@google.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, devel@openvz.org, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>, Suleiman Souhlal <suleiman@google.com>, Christoph
 Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>


>
> About kmem, if we count task_struct, page tables, etc...which can be freed by
> OOM-Killer i.e. it's allocated for 'process', should be aware of OOM problem.
> Using mm->owner makes sense to me until someone finds a great idea to handle
> OOM situation rather than task killing.
>

noted, will update.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
