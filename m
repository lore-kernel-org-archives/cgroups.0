From: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 3/4] mm: hugetlb: change to return bool for
 isolate_hugetlb()
Date: Wed, 15 Feb 2023 11:22:11 -0800
Message-ID: <Y+0w45eacPb8mgvh@monkey>
References: <cover.1676424378.git.baolin.wang@linux.alibaba.com>
 <12a287c5bebc13df304387087bbecc6421510849.1676424378.git.baolin.wang@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=EEpLwX60/JUYsEED8iNKv+LKjcqjPsD3OLbefQgmUqQ=;
 b=GCIvsItmPcqX9+8heBxiM177RRqPa2Y7hMIm9ReIPES7dqKr96osoH1TtLNUwf1xMJqR
 yZ3kyLQ1o7hK7jhMj2UoQGcMTeEGyC6L/HJQvjqDrsGSVOXwEzv93TrpOzJzWKbqsucB
 qQAj6PzREcuajPCZaBEq/m6Wt0mF3IICVM0zQGuSLMkiAzk8ixHQT8HgRZgISy0XtUSP
 YVBb1ldQjymdtoXdNKQa6jAghxm1ldwQdG3a39xLD5+oijQzRRJkHh1m9rZIywxuKbGf
 G87mq/TJI4WK2GoWUNlgIXpThkaKJh7j15HdV4nEdMMwkES4POTdClWkZRsnrMZHjRL3 YQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EEpLwX60/JUYsEED8iNKv+LKjcqjPsD3OLbefQgmUqQ=;
 b=Y+5QyYDcgey345YioTE7ntLMs6AXlKn+myvQ43JNXEUBXAvJ0yuFCD+xAPJNAC8mWsUJLsDrN/EuN2R815sjVe4rmlRvR2MCPUtZYS8LIOekH10OV7yESDx3c+M+sbH/c2fzDCALTxthPyLvtnB8H+sFA8JV/rmzTUoIYv0ve4I=
Content-Disposition: inline
In-Reply-To: <12a287c5bebc13df304387087bbecc6421510849.1676424378.git.baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, sj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, naoya.horiguchi-YMj9X0ASwKA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, osalvador-l3A5Bk7waGM@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, damon-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 02/15/23 18:39, Baolin Wang wrote:
> Now the isolate_hugetlb() only returns 0 or -EBUSY, and most users did not
> care about the negative value, thus we can convert the isolate_hugetlb()
> to return a boolean value to make code more clear when checking the
> hugetlb isolation state. Moreover converts 2 users which will consider
> the negative value returned by isolate_hugetlb().
> 
> No functional changes intended.
> 
> Signed-off-by: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Acked-by: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  include/linux/hugetlb.h |  6 +++---
>  mm/hugetlb.c            | 13 ++++++++-----
>  mm/memory-failure.c     |  2 +-
>  mm/mempolicy.c          |  2 +-
>  mm/migrate.c            |  7 +++----
>  5 files changed, 16 insertions(+), 14 deletions(-)

Thanks,

Reviewed-by: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

-- 
Mike Kravetz
