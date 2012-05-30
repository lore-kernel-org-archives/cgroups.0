From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v3 16/28] memcg: kmem controller charge/uncharge
 infrastructure
Date: Wed, 30 May 2012 15:53:21 +0200
Message-ID: <20120530135319.GG25094@somewhere.redhat.com>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com>
 <1337951028-3427-17-git-send-email-glommer@parallels.com>
 <20120530130416.GD25094@somewhere.redhat.com>
 <4FC61B4E.2060206@parallels.com>
 <20120530133736.GF25094@somewhere.redhat.com>
 <4FC622B5.9080600@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=uW83YUccwcTDz850xIIaoiDoHGcUzbM4Q3Ld2i/545g=;
        b=mUgkPz1hXOpdBL9pSqmaNefnEX8M1EUlMAu3lRfuMaj7agvqprjIkF8NRgYfvt/7Rt
         NVoxmSeTE53GVCwasmPj62JOpAIJcnvlfm60dfAbggT1QTc2BONrCDuvdWL2g4YZI57Q
         2mQHIvjXnHtywqZvZ9Ql29lww+VFRF21OnRnFPJ+BT4wkkUf30p+r99e9LLnQGnyUlxx
         lrNC9X91lbCRF/eSqZWUNA78eWf/3amROmx5iwmukiIqmpH45AntIi2JE5Tjxr/pfxrm
         XGIpbwc/4ejiXPjjl8TvJekZaZ3LB8VaPvTIQAN4ZNQ9mna2Q/QB9bYnPFNAvulDiaZJ
         G5FQ==
Content-Disposition: inline
In-Reply-To: <4FC622B5.9080600@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>, Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>

On Wed, May 30, 2012 at 05:37:57PM +0400, Glauber Costa wrote:
> On 05/30/2012 05:37 PM, Frederic Weisbecker wrote:
> >Right. __mem_cgroup_get_kmem_cache() fetches the memcg of the owner
> >and calls memcg_create_cache_enqueue() which does css_tryget(&memcg->css).
> >After this tryget I think you're fine. And in-between you're safe against
> >css_set removal due to rcu_read_lock().
> >
> >I'm less clear with __mem_cgroup_new_kmem_page() though...
> 
> That one does not get memcg->css but it does call mem_cgroup_get(),
> that does prevent against the memcg structure being freed, which I
> believe to be good enough.

What if the owner calls cgroup_exit() between mem_cgroup_from_task()
and mem_cgroup_get()? The css_set which contains the memcg gets freed.
Also the reference on the memcg doesn't even prevent the css_set to
be removed, does it?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
