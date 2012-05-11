From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v2 04/29] slub: always get the cache from its page in
 kfree
Date: Fri, 11 May 2012 13:06:36 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1205111305570.386@router.home>
References: <1336758272-24284-1-git-send-email-glommer@parallels.com> <1336758272-24284-5-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205111251420.31049@router.home> <4FAD531D.6030007@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1336759600; bh=gv6IROagpWvwVLKhY9c7/hbqqq0Wg/iTDzl8z3IwF3g=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=eV4TuJJwuQKqe6EYEbFOfD4OzO199QRG8Plxa6KNbD2xHkrIMTZBE6g/QdJjoRw0CdC6UV6rgtwE2SZc4GFRbwScw2vMSOxKMcSrd2sCEG7GoxEO6knE1jFHzxnGHNqyGLqXGQ+YzFayOLyT5GKrohS/psiVKHO3FyJOF0kDFnY=
In-Reply-To: <4FAD531D.6030007@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>, Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org, Pekka Enberg <penberg@cs.helsinki.fi>

On Fri, 11 May 2012, Glauber Costa wrote:

> > Adding a VM_BUG_ON may be useful to make sure that kmem_cache_free is
> > always passed the correct slab cache.
>
> Well, problem is , it isn't always passed the "correct" slab cache.
> At least not after this series, since we'll have child caches associated with
> the main cache.
>
> So we'll pass, for instance, kmem_cache_free(dentry_cache...), but will in
> fact free from the memcg copy of the dentry cache.

Urg. But then please only do this for the MEMCG case and add a fat big
warning in kmem_cache_free.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
