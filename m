From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET v2] slab: make memcg slab destruction scalable
Date: Wed, 18 Jan 2017 13:01:15 -0800
Message-ID: <20170118210115.GE9171@mtj.duckdns.org>
References: <20170114184834.8658-1-tj@kernel.org>
 <20170117001256.GB25218@js1304-P5Q-DELUXE>
 <20170117164913.GB28948@mtj.duckdns.org>
 <20170118075448.GA1255@js1304-P5Q-DELUXE>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+pcT5a2S/7Phh+vYRRy12mkohIXJHFXe9G6jMGi+9Dg=;
        b=tNgMPMFbgF+Gombp5Tk/GAp+7/ykf1lQgamnHHiW2WtvzxxKpWg7QerTA+IRJ8CVQf
         1CHRHZF0EB4FaPPewGfm3juPbCsYMMjiwmjHaYG3PcGn/OaK7cUv+u85Tni4plLsU85e
         oWR/PZWCfPw8TaGKytHBorzdME+ZqliafkmRH6EmnKz0o7PG2kH2dNEYcqnD2VxtOJ6l
         vNJOF0MwIaXA8XZIbvcV/gsc+udmI6zxKQ+IIsHkWrbLY4ds2c92s6MEBQHdGrV+b6oH
         MShVyBhJ9mE7VGzRWiRZnyCDZvb3PK25+LEKS08edY+eo95rkF3m5MzReZB4E7nHbxpp
         fkaQ==
Content-Disposition: inline
In-Reply-To: <20170118075448.GA1255@js1304-P5Q-DELUXE>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: vdavydov.dev@gmail.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, akpm@linux-foundation.org, jsvana@fb.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, kernel-team@fb.com

Hello,

On Wed, Jan 18, 2017 at 04:54:48PM +0900, Joonsoo Kim wrote:
> That problem is caused by slow release path and then contention on the
> slab_mutex. With an ordered workqueue, kworker would not be created a
> lot but it can be possible that a lot of work items to create a new
> cache for memcg is pending for a long time due to slow release path.

How many work items are pending and how many workers are on them
shouldn't affect the actual completion time that much when most of
them are serialized by a mutex.  Anyways, this patchset moves all the
slow parts out of slab_mutex, so none of this is a problem anymore.

> Your patchset replaces optimization for release path so it's better to
> check that the work isn't pending for a long time in above workload.

Yeap, it seems to work fine.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
