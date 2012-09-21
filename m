From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 00/16] slab accounting for memcg
Date: Fri, 21 Sep 2012 13:47:27 -0700
Message-ID: <20120921204727.GS7264@google.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
 <20120921204619.GR7264@google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=7OYJABnJWUJTsQXa+lYgiCV4tfVZLPqpsec/Ezc7tVA=;
        b=hzrwuHAqluuvOHI+IjcgqA46g6BAjH0VQyhW+Tz/ayF5Mv1hw8XIA5f4MyITydFEAV
         xKRQlmHaIYzEgfmho1WGK4nCSsHLFN6bZprtwYWoR/p2M8U2NeOKsQnTSACb0jrx500L
         7+VJkvpxQcScp4elIxkWAhOeeEZWVZp0z86qYPZB3PLpElQd52WlHaKuXZcaKAkXIDcl
         jkQWBmxD1n7xu0egnOI3SZp1Ge5zWwzraAKTeRhT7ggQrgXPCd4I4rA/5+kC+pTX1i1T
         pG/wde0Et6McBHqfHtnOiocpTrqrvzKRGzsTISzPcO96Vo9DnQENkPW4uuSFm7bMY+CJ
         uXCA==
Content-Disposition: inline
In-Reply-To: <20120921204619.GR7264@google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, linux-mm@kvack.org, Suleiman Souhlal <suleiman@google.com>, Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>

On Fri, Sep 21, 2012 at 01:46:19PM -0700, Tejun Heo wrote:
> In general, things look good to me.  I think the basic approach is
> manageable and does a decent job of avoiding introducing complications
> on the usual code paths.
> 
> Pekka seems generally happy with the approach too.  Christoph, what do
> you think?

Ooh, also, why aren't Andrew and Michal not cc'd?

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
