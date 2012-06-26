From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 01/11] memcg: Make it possible to use the stock for more
 than one page.
Date: Mon, 25 Jun 2012 21:01:54 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1206252101010.26640@chino.kir.corp.google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-2-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=nvp/ZYS4USMQnLA2jM9ZxqPPxQ7UxirfSo4/4MjsvZ0=;
        b=PAZQMoUjv5x/GQertgsiTU4YgxEf9xceBF7jqRMuuJ3pfB1s1ZV3cqLnsv0CQazdo3
         seL3Z3YS6NofFBSSEvjpiAx0nd917DK0HYY9omC+NmxmzfEbZCckB74PLaOYkGjqyzJp
         pJgNbClMICYv2mHb+7KoZP0zt6brB9zBJpl1P2JIbAfU2lAYaamECDbTHE0xPpZNn/Pq
         eaV+lByaMgpA7CHAIhr43bJ9Q5nvH3PYR8yu/aCtQNPc9aFJydIdZ3jstxIIRJH2nCJn
         M7SciWHyZSHh7URZwiqRtajCg0w0kGhmZ5H+A0vNUDXzBDzlYT79jgEJinOGatUtbJmg
         ++hQ==
In-Reply-To: <1340633728-12785-2-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>, Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>, Suleiman Souhlal <suleiman@google.com>

On Mon, 25 Jun 2012, Glauber Costa wrote:

> From: Suleiman Souhlal <ssouhlal@FreeBSD.org>
> 
> Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> Acked-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: David Rientjes <rientjes@google.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
