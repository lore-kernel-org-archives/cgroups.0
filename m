From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: memcg swap doesn't work in mmotm-2014-07-09-17-08?
Date: Wed, 16 Jul 2014 16:43:46 -0400
Message-ID: <20140716204346.GE8524@nhori.redhat.com>
References: <20140716181007.GA8524@nhori.redhat.com>
 <20140716183727.GB29639@cmpxchg.org>
 <20140716193129.GB8524@nhori.redhat.com>
 <20140716195721.GC29639@cmpxchg.org>
 <20140716201147.GD8524@nhori.redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20140716201147.GD8524@nhori.redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, Naoya Horiguchi <nao.horiguchi@gmail.com>

On Wed, Jul 16, 2014 at 04:11:47PM -0400, Naoya Horiguchi wrote:
...
> > I was running on 3.16.0-rc5-mm1-00480-gab7ca1e1e407 (latest mmots).
> 
> I'll try this kernel.
> If that passes, this problem is fixed implicitly, so that's fine :)

Not reproduced in the latest mmots, so the problem is already fixed.

Thanks,
Naoya Horiguchi

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
