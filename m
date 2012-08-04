From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [RFC PATCH 04/23 V2] oom: use N_MEMORY instead N_HIGH_MEMORY
Date: Sat, 4 Aug 2012 21:54:57 +0800
Message-ID: <CAJd=RBCuXo_rFNGcSu7U9O6cSRNxZi0pWtB1GSUxCBD=uT-GJg@mail.gmail.com>
References: <1343875991-7533-1-git-send-email-laijs@cn.fujitsu.com>
	<1343875991-7533-5-git-send-email-laijs@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=toK21rJ5W61tlR9FUOK8qpGptMnssd1FvYxiO6ZBEAk=;
        b=ZC7Zm/1B8kFLYOgm2A+jFE8IsLM26nP81MhXDZL6c7gyk+NgaGydI2xuI54xcY74vE
         scQYiIbRfh2mj/EFLo+OkQPSRWZIkm+k397+YxmzCALE0LvIco9OQ/Lpy5CaOnAvBoZ8
         ny+AQmfwAMhvTjX1VCz8sclIvK5tyt0p6s3fQrqNQZOm8F51YMEjb0oVGvRWkjE9iokO
         OyNczmAeMbIpT7Dhu1tK6gndjPNrvIWoECb8xjvSU9bm5fLqxBDUiQGMONOLRs6HrfSe
         MQ9dyj3dk/+xhLBu/4sLfphOa+cxptymgA8hdzfi+b5cb8AEXOTuGX7ZbBhHZeo3t+Kh
         y8eg==
In-Reply-To: <1343875991-7533-5-git-send-email-laijs@cn.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Paul Menage <paul@paulmenage.org>, Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Christoph Lameter <cl@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matt Fleming <matt.fleming@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yinghai@kernel.org>, David Rientjes <rientjes@google.com>, Bjorn Helgaas <bhelgaas@google.com>, Wanlong Gao <gaowanlong@cn.fujitsu.com>, Petr

On Thu, Aug 2, 2012 at 10:52 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> N_HIGH_MEMORY stands for the nodes that has normal or high memory.
> N_MEMORY stands for the nodes that has any memory.
>
> The code here need to handle with the nodes which have memory, we should
> use N_MEMORY instead.
>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---

Acked-by: Hillf Danton <dhillf@gmail.com>

>  mm/oom_kill.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index ac300c9..1e58f12 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -257,7 +257,7 @@ static enum oom_constraint constrained_alloc(struct zonelist *zonelist,
>          * the page allocator means a mempolicy is in effect.  Cpuset policy
>          * is enforced in get_page_from_freelist().
>          */
> -       if (nodemask && !nodes_subset(node_states[N_HIGH_MEMORY], *nodemask)) {
> +       if (nodemask && !nodes_subset(node_states[N_MEMORY], *nodemask)) {
>                 *totalpages = total_swap_pages;
>                 for_each_node_mask(nid, *nodemask)
>                         *totalpages += node_spanned_pages(nid);
> --
> 1.7.1
>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
