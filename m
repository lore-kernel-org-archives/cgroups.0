From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v2 05/29] slab: rename gfpflags to allocflags
Date: Tue, 15 May 2012 14:57:05 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1205151456410.18595@chino.kir.corp.google.com>
References: <1336758272-24284-1-git-send-email-glommer@parallels.com> <1336758272-24284-6-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=i/qw9nvNvN4qd+IOL0az/YSQEL8fT8iwo6xLgm/v3TQ=;
        b=aqglPgmqdnc51YP4S9VYm3vLCj8nCdqKsTdh+h0TLzUGy4v0QWS89iyJPM377bP6be
         JiiQ41+GEYyLUurDHEXis9LjX9bKMvPngMjSRkJ6LCgqmwMT9K4Ei/NOUIxAJmy28vLO
         KaN4GM78kfr/+KhSpopvcPUr4Gw/pN9BtLx3j+XDaWLPikJDuyGbQ0ePSkL0swGMGOSb
         B3AU5Vab22YqAkV2JTby8uIdcyP/BdyV2kH8GpLhHFoK+NIPxrRmFYwUPDmW20Mp1YHm
         LwEBGnK9MxkecQDNHznroQcSLrgpVUHNp9UEhzJSdBHcW7Vnqh6HRZQh3TW4NX8+rlUS
         sXzg==
In-Reply-To: <1336758272-24284-6-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>, Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>, Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org, Christoph Lameter <cl@linux.com>

On Fri, 11 May 2012, Glauber Costa wrote:

> A consistent name with slub saves us an acessor function.
> In both caches, this field represents the same thing. We would
> like to use it from the mem_cgroup code.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>

Acked-by: David Rientjes <rientjes@google.com>

Same, can be merged now with no dependency on the rest of this patchset.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
