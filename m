From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -mm 00/14] Per memcg slab shrinkers
Date: Sun, 21 Sep 2014 12:00:12 -0400
Message-ID: <20140921160012.GA996@mtj.dyndns.org>
References: <cover.1411301245.git.vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=SqIrJzrlC6GLdhu/+oFztMnVZKgAScFUPW7ePAYGxSs=;
        b=YcZLIsxh+ScLFMjLq6k+QEZ+OMJxxT87NTiTX8UPvdf5Z0yQMrZY2+7m/1msnPOumL
         +HQJ7kL9zzlxpdo4Yzq3pZpoOLAoO88ycrPnT3IqxUVom7Fd+E17x+al5p7F2kc9PJYp
         Il2d2/qczEh1wuUjpMn0WY5bgSgbFNh+PTo20zDbjeR7pq4R7ZpOL69xDMUcVtdrVONe
         qut4MybF/bNVcCS/nnf4C/6Jc/ivs3JBjlmshlY9mDwPiBBrbhq4KD82ROBrN5UwHVF4
         IJAY1ILL+undFqchT3ldY5J51Hy0vGoNHnhJpAn8InukNUyAOBYpFanOjlf8mvF400vy
         LWZQ==
Content-Disposition: inline
In-Reply-To: <cover.1411301245.git.vdavydov@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>, Dave Chinner <david@fromorbit.com>, Glauber Costa <glommer@gmail.com>, Suleiman Souhlal <suleiman@google.com>, Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

Hello,

On Sun, Sep 21, 2014 at 07:14:32PM +0400, Vladimir Davydov wrote:
...
> list. This is really important, because this allows us to release
> memcg_cache_id used for indexing in per-memcg arrays. If we don't do
> this, the arrays will grow uncontrollably, which is really bad. Note, in
> comparison to user memory reparenting, which Johannes is going to get

I don't know the code well and haven't read the patches and could
easilya be completely off the mark, but, if the size of slab array is
the only issue, wouldn't it be easier to separate that part out?  The
indexing is only necessary for allocating new items, right?  Can't
that part be shutdown and the index freed on offline and the rest stay
till release?  Things like reparenting tends to add fair amount of
complexity and hot path overheads which aren't necessary otherwise.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
