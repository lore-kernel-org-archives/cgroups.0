From: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Subject: Re: [RFC PATCH 0/8] memcg: Enable fine-grained per process memory
 control
Date: Tue, 18 Aug 2020 11:14:53 +0200
Message-ID: <20200818091453.GL2674@hirez.programming.kicks-ass.net>
References: <20200817140831.30260-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UBwdQabxborBnUE/RMGD20d7Ru/Oheb0wmXWjUiC0/E=; b=YbqYH54dJpbZukfJbcHBX5gIe6
        4fGR1JnoO2J5ou9rqay98pZf09b2sJvtXYzco+ShIGTbQCUJanYELbMUIKzdUJp8m6gqGDh2Vy5dz
        Z85kRmbOcs2R9yO6b+qiXnRvxaiEOIVu1SfG+AZ1aEeGjWd8zXPOHQnLG0G/xaBKWZcnjPHK5THwY
        NUFDfGvip/hUyZNwCTe8rH2KlZoyzIbkjSr4WisborRSryZSeC0mSG/mHjMtr6YgsnrQ7qlP834T9
        2AXdgEs4etYbr2acZv2wBRyLfyez9vj90z97qq/VvNlLitUCukARb3errqkqzDH0jEAYtn4LMlLjg
        uY4c2NiA==;
Content-Disposition: inline
In-Reply-To: <20200817140831.30260-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon, Aug 17, 2020 at 10:08:23AM -0400, Waiman Long wrote:
> Memory controller can be used to control and limit the amount of
> physical memory used by a task. When a limit is set in "memory.high" in
> a v2 non-root memory cgroup, the memory controller will try to reclaim
> memory if the limit has been exceeded. Normally, that will be enough
> to keep the physical memory consumption of tasks in the memory cgroup
> to be around or below the "memory.high" limit.
> 
> Sometimes, memory reclaim may not be able to recover memory in a rate
> that can catch up to the physical memory allocation rate. In this case,
> the physical memory consumption will keep on increasing. 

Then slow down the allocator? That's what we do for dirty pages too, we
slow down the dirtier when we run against the limits.

