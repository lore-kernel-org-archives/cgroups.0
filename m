From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] mm: memcg: yield cpu when we fail to charge pages
Date: Tue, 8 Sep 2020 12:21:59 -0700
Message-ID: <20200908192159.GB567128@carbon.DHCP.thefacebook.com>
References: <20200908185051.62420-1-jpitti@cisco.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=7QX1xtipYv2lrQoBAp4Kh3zUfH1Nj+wYaDl8hnBei/A=;
 b=QmuXPmdHgFxlLIP29OexIvi79JSmTw4nJJENBSgQbTMbjKGPT5R2sReSr+Txim1h6BVd
 2gwLmPK/yTFHBk+V4J9QMME2jEmuVn3OXrsQUpNd/mXMnWymSPZpEDIHEBhzD13UPfc0
 nZ99+egAtvXUC/AxLyME5qvK5RXF4w7P1Rg= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7QX1xtipYv2lrQoBAp4Kh3zUfH1Nj+wYaDl8hnBei/A=;
 b=T6yomLM4mbZJxH0RZEkpenNWeu7il9BxRS/FnHMz/OAfbI1pEt7popifR+Yb0GxxGsvG2whBNppxNDv1FnVJwSI1Rm+cpiUHHfdgQISA9D8hHL24aCyd2rU6T1CXTBKg2651/xwOeuDGnAaoS8xhVJx5oaQHt+hUV9+7sBR5y90=
Content-Disposition: inline
In-Reply-To: <20200908185051.62420-1-jpitti@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Julius Hemanth Pitti <jpitti@cisco.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, xe-linux-external@cisco.com

On Tue, Sep 08, 2020 at 11:50:51AM -0700, Julius Hemanth Pitti wrote:
> For non root CG, in try_charge(), we keep trying
> to charge until we succeed. On non-preemptive
> kernel, when we are OOM, this results in holding
> CPU forever.
> 
> On SMP systems, this doesn't create a big problem
> because oom_reaper get a change to kill victim
> and make some free pages. However on a single-core
> CPU (or cases where oom_reaper pinned to same CPU
> where try_charge is executing), oom_reaper shall
> never get scheduled and we stay in try_charge forever.
> 
> Steps to repo this on non-smp:
> 1. mount -t tmpfs none /sys/fs/cgroup
> 2. mkdir /sys/fs/cgroup/memory
> 3. mount -t cgroup none /sys/fs/cgroup/memory -o memory
> 4. mkdir /sys/fs/cgroup/memory/0
> 5. echo 40M > /sys/fs/cgroup/memory/0/memory.limit_in_bytes
> 6. echo $$ > /sys/fs/cgroup/memory/0/tasks
> 7. stress -m 5 --vm-bytes 10M --vm-hang 0
> 
> Signed-off-by: Julius Hemanth Pitti <jpitti@cisco.com>
> ---
>  mm/memcontrol.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 0d6f3ea86738..4620d70267cb 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2652,6 +2652,8 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (fatal_signal_pending(current))
>  		goto force;
>  
> +	cond_resched();
> +

Can you, please, add a short comment here?
Something like "give oom_reaper a chance on a non-SMP system"?

>  	/*
>  	 * keep retrying as long as the memcg oom killer is able to make
>  	 * a forward progress or bypass the charge if the oom killer
> -- 
> 2.17.1
>

The patch makes total sense to me. Please, feel free to add
Acked-by: Roman Gushchin <guro@fb.com> after adding a comment.

Thank you!
