From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [v10 2/6] mm: implement mem_cgroup_scan_tasks() for the root
 memory cgroup
Date: Wed, 4 Oct 2017 15:15:52 -0400
Message-ID: <20171004191552.GB1501@cmpxchg.org>
References: <20171004154638.710-1-guro@fb.com>
 <20171004154638.710-3-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=s/kkLfDpkcQOcsZvr/1p0l3sa3hEpZiR/yeyYNalz1w=; b=D4+Bykat5jJs6HJOSqYzwL9Gte
	6ZrJLqK4hDauAE+6kZAS3j0H4LHakS3BSBbpjDSDIw7k9HTd4oAZ8B+ajDDiDn2IGbUt3c+WP3Jjg
	9KKBuad5r8nQCwS/d+9ANEIy9xzH/zpG6rlbd2Qqmb5mFaelZJ4FlhHf4mKZNCD9P6Dg=;
Content-Disposition: inline
In-Reply-To: <20171004154638.710-3-guro@fb.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Oct 04, 2017 at 04:46:34PM +0100, Roman Gushchin wrote:
> Implement mem_cgroup_scan_tasks() functionality for the root
> memory cgroup to use this function for looking for a OOM victim
> task in the root memory cgroup by the cgroup-ware OOM killer.
> 
> The root memory cgroup is treated as a leaf cgroup, so only tasks
> which are directly belonging to the root cgroup are iterated over.
> 
> This patch doesn't introduce any functional change as
> mem_cgroup_scan_tasks() is never called for the root memcg.
> This is preparatory work for the cgroup-aware OOM killer,
> which will use this function to iterate over tasks belonging
> to the root memcg.
> 
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: kernel-team@fb.com
> Cc: cgroups@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
