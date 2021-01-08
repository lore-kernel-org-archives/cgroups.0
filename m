From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v2 3/3] mm: memcg: add swapcache stat for memcg v2
Date: Fri, 8 Jan 2021 11:27:23 -0800
Message-ID: <20210108192723.GA1388856@carbon.dhcp.thefacebook.com>
References: <20210108155813.2914586-1-shakeelb@google.com>
 <20210108155813.2914586-3-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=0GkABvoaXUS9nZ30gCzV+pqN8dB12iWOT9cT9ktb2bo=;
 b=pbI5xnU9ZUesl0pszt6XgjFTckzsnKTmHX1FbEB1w16WQAUcq2tqXvAYMKZl9XKgxp/r
 4NfSp2+y1POcDNx7zbyLgbqzOSGlBqs9O+F3joDoOkNnYh/4LXwS+U01WDNV68dfwLpl
 SjVjqhvTrarChGcswWCa6wuUMDtffp5Mdm8= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0GkABvoaXUS9nZ30gCzV+pqN8dB12iWOT9cT9ktb2bo=;
 b=Nw1jOlCdODDt/qzdEw0D9dKznoFlT5/X4EQe+Fv7v6WVrAkhIsxgJLUxuf09lmM44/878s8ci9/B/+Tj+7TqRUfwILKTxFqu/ZBknMg1VpUqlJ0Eh6n0DwCQxV+fVBEDaRPccw0gWhuj6QOoFTlrCPuLiVg87J1A8b77hFJM6EU=
Content-Disposition: inline
In-Reply-To: <20210108155813.2914586-3-shakeelb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Yang Shi <shy828301@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.com>

On Fri, Jan 08, 2021 at 07:58:13AM -0800, Shakeel Butt wrote:
> This patch adds swapcache stat for the cgroup v2. The swapcache
> represents the memory that is accounted against both the memory and the
> swap limit of the cgroup. The main motivation behind exposing the
> swapcache stat is for enabling users to gracefully migrate from cgroup
> v1's memsw counter to cgroup v2's memory and swap counters.
> 
> Cgroup v1's memsw limit allows users to limit the memory+swap usage of a
> workload but without control on the exact proportion of memory and swap.
> Cgroup v2 provides separate limits for memory and swap which enables
> more control on the exact usage of memory and swap individually for the
> workload.
> 
> With some little subtleties, the v1's memsw limit can be switched with
> the sum of the v2's memory and swap limits. However the alternative for
> memsw usage is not yet available in cgroup v2. Exposing per-cgroup
> swapcache stat enables that alternative. Adding the memory usage and
> swap usage and subtracting the swapcache will approximate the memsw
> usage. This will help in the transparent migration of the workloads
> depending on memsw usage and limit to v2' memory and swap counters.
> 
> The reasons these applications are still interested in this approximate
> memsw usage are: (1) these applications are not really interested in two
> separate memory and swap usage metrics. A single usage metric is more
> simple to use and reason about for them.
> 
> (2) The memsw usage metric hides the underlying system's swap setup from
> the applications. Applications with multiple instances running in a
> datacenter with heterogeneous systems (some have swap and some don't)
> will keep seeing a consistent view of their usage.
> 
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Acked-by: Michal Hocko <mhocko@suse.com>

Reviewed-by: Roman Gushchin <guro@fb.com>

Thanks!
