From: Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 02/11] memcg: Reclaim when more than one page needed.
Date: Mon, 25 Jun 2012 16:33:29 -0700
Message-ID: <CABCjUKD0h089StLF8BwVRU-St70Ai9PTw-cjis40_aLLG3MAQQ@mail.gmail.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com>
	<1340633728-12785-3-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:x-system-of-record;
        bh=BMDH8RmoZ6nMXiQq7FllA05j/J7FLJ7zROSYo2ODu2M=;
        b=EPG3mg0fSLvyYaK43fs3yt2uZbxh8U8AVGPA8sdg9RRHF9CgVkLCEnDLk4LvWtXI/3
         Eq3fSQqEjQy/QSFsxRquzXZJvrZMdZpKSeNQ7JIM3S5ayUDyqq59SUnSFGfF2Y+juTrA
         gtRMbrykRbRDmJKQWqcxG/Qv/UdPUcGByoHT7DKEeUOXNpxkhCbrmhXpnlSGZdi+jTt3
         T7zgWGLue1Q/QPgmPABvodcKVCnhPBROICEBSp8Pu9Kqr/nlKZEf13y/YazGJyc6FLX6
         Uf1+xCp7oIWh90+xaD0Zl++3wZWwguEo+eHOGRa9gsKoOyzWpTyV/4CZeSf+LOrqYB08
         LJ+A==
In-Reply-To: <1340633728-12785-3-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>

On Mon, Jun 25, 2012 at 7:15 AM, Glauber Costa <glommer@parallels.com> wrote:
> From: Suleiman Souhlal <ssouhlal@FreeBSD.org>
>
> mem_cgroup_do_charge() was written before slab accounting, and expects
> three cases: being called for 1 page, being called for a stock of 32 pages,
> or being called for a hugepage.  If we call for 2 or 3 pages (and several
> slabs used in process creation are such, at least with the debug options I
> had), it assumed it's being called for stock and just retried without reclaiming.
>
> Fix that by passing down a minsize argument in addition to the csize.
>
> And what to do about that (csize == PAGE_SIZE && ret) retry?  If it's
> needed at all (and presumably is since it's there, perhaps to handle
> races), then it should be extended to more than PAGE_SIZE, yet how far?
> And should there be a retry count limit, of what?  For now retry up to
> COSTLY_ORDER (as page_alloc.c does), stay safe with a cond_resched(),
> and make sure not to do it if __GFP_NORETRY.

The commit description mentions COSTLY_ORDER, but it's not actually
used in the patch.

-- Suleiman

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
