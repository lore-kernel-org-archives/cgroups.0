From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 0/3] mm/memcg: some cleanup for mem_cgroup_iter()
Date: Fri, 25 Feb 2022 09:13:46 +0100
Message-ID: <YhiPuokZpIk1MYaB@dhcp22.suse.cz>
References: <20220225003437.12620-1-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1645776827; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a9XUtHgFIXz3Y7VU5CfuvkiImWSSj6M2SSPgIuQZxWw=;
        b=P51WeZJwQaSXAs3kehFkP5GgGwrp0kmlZJytxgvWQc9SXsNbzmcUW37g2LTuqRdG6+JVHX
        x49lzoHoYwtXjQ9ason8Vzr7s9hOBPm1En8NXOGujqR4T2RM+XUx4MdLOeKZL0Q7hYIfIQ
        AiUg+xtD4wBqtK75jF2ZvixJTvQ968A=
Content-Disposition: inline
In-Reply-To: <20220225003437.12620-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri 25-02-22 00:34:34, Wei Yang wrote:
> No functional change, try to make it more readable.
> 
> Wei Yang (3):
>   mm/memcg: set memcg after css verified and got reference
>   mm/memcg: set pos to prev unconditionally
>   mm/memcg: move generation assignment and comparison together
> 
>  mm/memcontrol.c | 27 ++++++++++++---------------
>  1 file changed, 12 insertions(+), 15 deletions(-)

I am sorry but I do not really see these changes to be simplifying 
the iterator code enough to be worth touching the code. The iterator
code is really subtle and we have experienced some subtle bugs there.
I would be really reluctant to touch it unless the result is a clear
simplification or a bug fix. Please keep in mind that the review
overhead is far from negligible here.

Unless Johannes sees that as a clear improvement then I would suggest
dropping these patches from the akpm's tree.
-- 
Michal Hocko
SUSE Labs
