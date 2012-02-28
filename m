From: Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 07/10] memcg: Stop res_counter underflows.
Date: Tue, 28 Feb 2012 15:07:39 -0800
Message-ID: <CABCjUKCaJVGShRKRkvBMrz_XNVGNrcguQ1uTP8Am1fQ1Te6PWA@mail.gmail.com>
References: <1330383533-20711-1-git-send-email-ssouhlal@FreeBSD.org>
	<1330383533-20711-8-git-send-email-ssouhlal@FreeBSD.org>
	<4F4CD731.60908@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:x-system-of-record;
        bh=1AZ6CBGMnRgTj23wN6NLscj6UaxKvYv18LKkWJm5y8k=;
        b=Z9MquMX7iu+QBYB6ZTxysmgHwTpdzsAfDSVpu7LZ19t3NMEJghcoLTK9Hp43iZBH7Q
         tkeDMSgnk695m8X6HxWPU3N+ZxMzisjceI/i1rOjShbN5INZlnAJXzeWyrV9/SCiHEOi
         PlMGlKhNjyuitfD+kBq5qFTnBw0rJNEGTVgDM=
In-Reply-To: <4F4CD731.60908@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: Suleiman Souhlal <ssouhlal@freebsd.org>, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, penberg@kernel.org, yinghan@google.com, hughd@google.com, gthelen@google.com, linux-mm@kvack.org, devel@openvz.org

On Tue, Feb 28, 2012 at 5:31 AM, Glauber Costa <glommer@parallels.com> wrote:
> I don't fully understand this.
> To me, the whole purpose of having a cache tied to a memcg, is that we know
> all allocations from that particular cache should be billed to a specific
> memcg. So after a cache is created, and has an assigned memcg,
> what's the point in bypassing it to root?
>
> It smells like you're just using this to circumvent something...

In the vast majority of the cases, we will be able to account to the cgroup.
However, there are cases when __mem_cgroup_try_charge() is not able to
do so, like when the task is being killed.
When this happens, the allocation will not get accounted to the
cgroup, but the slab accounting code will still think the page belongs
to the memcg's kmem_cache.
So, when we go to free the page, we assume that the page belongs to
the memcg and uncharge it, even though it was never charged to us in
the first place.

This is the situation this patch is trying to address, by keeping a
counter of how much memory has been bypassed like this, and uncharging
from the root if we have any outstanding bypassed memory.

Does that make sense?

-- Suleiman

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
