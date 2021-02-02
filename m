From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 1/7] mm: memcontrol: fix cpuhotplug statistics flushing
Date: Tue, 2 Feb 2021 15:07:47 -0800
Message-ID: <20210202230747.GA1812008@carbon.dhcp.thefacebook.com>
References: <20210202184746.119084-1-hannes@cmpxchg.org>
 <20210202184746.119084-2-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=TrlPo0eFafeFIQd4fPweXXFigvYNrR/l1TowLCAzMco=;
 b=DCJffGsgDmJguBrses2VkFJP1x3+0ff7pDl3GvpLHXHRh4ESGWIFWoezd3RTJKU+gCrJ
 VQyA4aBF4jaXZo3gZWr7EQ4/tCZLtyLFcpLtPXmGu0bj8s2HQ9StpqqTq5EOy60s2Myr
 TN69Br7pimgxM9K30SLxqmAX3CxpjbwwP/4= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TrlPo0eFafeFIQd4fPweXXFigvYNrR/l1TowLCAzMco=;
 b=kfvVAkpqqWcXbgwcr5uWlOcq1BZbqKTfKLuqWcZv0irSCmXiqqXDpkDOpNVtAhpiCnb40eBAGW00lS6nE/HtXGrrU6G24mE5Eclh8PAiCiCfe/qgh46z1psOWFJXvlcduPXzoZDahtmnb8YHttHVt44upFUxRyMtcz3/DNkuDK0=
Content-Disposition: inline
In-Reply-To: <20210202184746.119084-2-hannes@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Feb 02, 2021 at 01:47:40PM -0500, Johannes Weiner wrote:
> The memcg hotunplug callback erroneously flushes counts on the local
> CPU, not the counts of the CPU going away; those counts will be lost.
> 
> Flush the CPU that is actually going away.
> 
> Also simplify the code a bit by using mod_memcg_state() and
> count_memcg_events() instead of open-coding the upward flush - this is
> comparable to how vmstat.c handles hotunplug flushing.

To the whole series: it's really nice to have an accurate stats at
non-leaf levels. Just as an illustration: if there are 32 CPUs and
1000 sub-cgroups (which is an absolutely realistic number, because
often there are many dying generations of each cgroup), the error
margin is 3.9GB. It makes all numbers pretty much random and all
possible tests extremely flaky.

> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

To this patch:

Reviewed-by: Roman Gushchin <guro@fb.com>

Thanks!
