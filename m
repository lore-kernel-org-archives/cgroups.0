From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH mmotm] mm, oom: reduce dependency on tasklist_lock: fix
Date: Mon, 16 Jul 2012 02:01:55 -0700 (PDT)
Message-ID: <alpine.LSU.2.00.1207160200200.4056@eggly.anvils>
References: <alpine.DEB.2.00.1206251846020.24838@chino.kir.corp.google.com> <alpine.DEB.2.00.1206291404530.6040@chino.kir.corp.google.com> <alpine.DEB.2.00.1206291406110.6040@chino.kir.corp.google.com> <20120713143206.GA4511@tiehlicka.suse.cz>
 <alpine.LSU.2.00.1207160039120.3936@eggly.anvils> <20120716080603.GA14664@tiehlicka.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=3s2SMz+EBBi69BzbTCBxAf8Jxa57g/49irmah0ITstk=;
        b=aANZ0KLGJMWKvepR2YF2f05L5FCH3QMMdE7gev7W1cdw1Cpk+koN4AmGogqHZTOGHK
         cSsQt3eHfS5RSyJ5R7idT9ncn41CNPA54TAAXt82Sxa22u1y/7q6LITsWHGWXXcTLe8e
         U3lWZsXL+GPRhRnhWpHVfhiJulp8MCV5+ILE2lk/+Xs4T2tIx40bvauL+VNYDwDDw18Y
         EPSdkLM5/twYVYkAP1LNLn7YeojGzrXaIzKYyjm4hEsgIX7i7fblB4MY/iXfErM9vBzh
         kIjy9YzLbTqmzbYG0Kfb9HlnG9A/uzAj1T47bRdZiE1y9/99Rm6as2jgO+Q8wn8kLNQb
         TRdQ==
In-Reply-To: <20120716080603.GA14664@tiehlicka.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Minchan Kim <minchan@kernel.org>, Oleg Nesterov <oleg@redhat.com>, linux-mm@kvack.org, cgroups@vger.kernel.org

On Mon, 16 Jul 2012, Michal Hocko wrote:
> On Mon 16-07-12 00:42:37, Hugh Dickins wrote:
> > Slab poisoning gave me a General Protection Fault on the
> > 	atomic_dec(&__task_cred(p)->user->processes);
> > line of release_task() called from wait_task_zombie(),
> > every time my dd to USB testing generated a memcg OOM.
> 
> Just curious, was it with the wait-on-pagereclaim patch?

Yes, that's what I was trying to test.

Hugh

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
