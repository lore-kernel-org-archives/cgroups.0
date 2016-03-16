From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: Re: [PATCH] mm: memcontrol: reclaim and OOM kill when shrinking
 memory.max below usage
Date: Wed, 16 Mar 2016 18:15:09 +0300
Message-ID: <20160316151509.GC18142@esperanza>
References: <1457643015-8828-2-git-send-email-hannes@cmpxchg.org>
 <20160311081825.GC27701@dhcp22.suse.cz>
 <20160311091931.GK1946@esperanza>
 <20160316051848.GA11006@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:To:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=VQMzcjBazCWHSFlwlrWsZdNEkUuPbdZXyuQhshjxcGg=;
 b=TDDzqMDJJBy/uHZbwEW/moYAkHuV9jqQRnFHJRRXVAxPDGDmgpVr2i+jGMvAkbU82GDeQU9N23chWD7rD46tShNa5Noi/IdoJifewbcxb5QdOLbtOmTJdq7HDFYAJmnUQxR9gbYASCmtZtlOeaVj4EAOYJrLLt7qF6ZcvrxyFXw=
Content-Disposition: inline
In-Reply-To: <20160316051848.GA11006@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Mar 15, 2016 at 10:18:48PM -0700, Johannes Weiner wrote:
> On Fri, Mar 11, 2016 at 12:19:31PM +0300, Vladimir Davydov wrote:
...
> > Come to think of it, shouldn't we restore the old limit and return EBUSY
> > if we failed to reclaim enough memory?
> 
> I suspect it's very rare that it would fail. But even in that case
> it's probably better to at least not allow new charges past what the
> user requested, even if we can't push the level back far enough.

It's of course good to set the limit before trying to reclaim memory,
but isn't it strange that even if the cgroup's memory can't be reclaimed
to meet the new limit (tmpfs files or tasks protected from oom), the
write will still succeed? It's a rare use case, but still.

I've one more concern regarding this patch. It's about calling OOM while
reclaiming cgroup memory. AFAIU OOM killer can be quite disruptive for a
workload, so is it really good to call it when normal reclaim fails?

W/o OOM killer you can optimistically try to adjust memory.max and if it
fails you can manually kill some processes in the container or restart
it or cancel the limit update. With your patch adjusting memory.max
never fails, but OOM might kill vital processes rendering the whole
container useless. Wouldn't it be better to let the user decide if
processes should be killed or not rather than calling OOM forcefully?

Thanks,
Vladimir

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
