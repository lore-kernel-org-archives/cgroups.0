From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v2 04/29] slub: always get the cache from its page in
 kfree
Date: Fri, 11 May 2012 12:53:31 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1205111251420.31049@router.home>
References: <1336758272-24284-1-git-send-email-glommer@parallels.com> <1336758272-24284-5-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1336758815; bh=EMcn3hk66tV5F2ACON8aE7ulDfUmJ1oJGMVLiUl4Ulo=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=1WSXNmhc1CTY+Zzjqsag/PdmUo7jIBjDK6MSpcL+Z7S2J0WJ+ziJ8mSt+6jEO34pHNb3hvLAqE1WsswzUdo6T/7zZFF/dDpwjLdA42cdOztV8FCjfWg/sRd4ocZ2SxG+y/+JD7e/K5uWfo6fKtvrrbctFI8jdQK+fF36/LMsm9U=
In-Reply-To: <1336758272-24284-5-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>, Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org, Pekka Enberg <penberg@cs.helsinki.fi>

On Fri, 11 May 2012, Glauber Costa wrote:

> struct page already have this information. If we start chaining
> caches, this information will always be more trustworthy than
> whatever is passed into the function

Other allocators may not have that information and this patch may
cause bugs to go unnoticed if the caller specifies the wrong slab cache.

Adding a VM_BUG_ON may be useful to make sure that kmem_cache_free is
always passed the correct slab cache.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
