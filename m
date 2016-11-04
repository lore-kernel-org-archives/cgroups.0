From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: memory.force_empty is deprecated
Date: Fri, 4 Nov 2016 11:21:03 -0400
Message-ID: <20161104152103.GC8825@cmpxchg.org>
References: <OF57AEC2D2.FA566D70-ON48258061.002C144F-48258061.002E2E50@notes.na.collabserv.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mqagHtR6n5za83isJ0VEYUcxv78y1TdUC8MnsJSjvHk=; b=G2NUXECfwCHPrdbkYe3L0BUlVN
	AX2bXVodVmNuCPaN+88+9JyrQfFyUXgLIYmVyghi4WlaivESgfwH56ylSV4NbxWR3MceQ2nPiHp6y
	1ItXVUITAi8aXnXGQLBApIpfSf3ybrYxVizXL35YtezNfvYTVO0+BGK9YPAamrbtniKg=;
Content-Disposition: inline
In-Reply-To: <OF57AEC2D2.FA566D70-ON48258061.002C144F-48258061.002E2E50@notes.na.collabserv.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhao Hui Ding <dingzhh@cn.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org

Hi,

On Fri, Nov 04, 2016 at 04:24:25PM +0800, Zhao Hui Ding wrote:
> Hello,
> 
> I'm Zhaohui from IBM Spectrum LSF development team. I got below message 
> when running LSF on SUSE11.4, so I would like to share our use scenario 
> and ask for the suggestions without using memory.force_empty.
> 
> memory.force_empty is deprecated and will be removed. Let us know if it is 
> needed in your usecase at linux-mm@kvack.org
> 
> LSF is a batch workload scheduler, it uses cgroup to do batch jobs 
> resource enforcement and accounting. For each job, LSF creates a cgroup 
> directory and put job's PIDs to the cgroup.
> 
> When we implement LSF cgroup integration, we found creating a new cgroup 
> is much slower than renaming an existing cgroup, it's about hundreds of 
> milliseconds vs less than 10 milliseconds.

Cgroup creation/deletion is not expected to be an ultra-hot path, but
I'm surprised it takes longer than actually reclaiming leftover pages.

By the time the jobs conclude, how much is usually left in the group?

That said, is it even necessary to pro-actively remove the leftover
cache from the group before starting the next job? Why not leave it
for the next job to reclaim it lazily should memory pressure arise?
It's easy to reclaim page cache, and the first to go as it's behind
the next job's memory on the LRU list.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
