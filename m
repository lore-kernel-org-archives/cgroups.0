From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch v2] mm, memcg: do not retry precharge charges
Date: Sun, 15 Jan 2017 10:19:14 -0500
Message-ID: <20170115151914.GA28947@cmpxchg.org>
References: <alpine.DEB.2.10.1701112031250.94269@chino.kir.corp.google.com>
 <alpine.DEB.2.10.1701121446130.12738@chino.kir.corp.google.com>
 <20170113084014.GB25212@dhcp22.suse.cz>
 <alpine.DEB.2.10.1701130208510.69402@chino.kir.corp.google.com>
 <20170114162238.GD26139@cmpxchg.org>
 <alpine.DEB.2.10.1701142137020.8668@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hJD7XaYNFRyHk92ZYofbb8nbVKmMZEDLq5lqmzu3Nng=; b=L1iSw4To/Requi0Aph4044Gz/a
	arag/8oZHk7MJSw0/1ulX8OkPqXpMMM4K5UZT4TKt37oqwOjYVNoakcgGDSR6CdxMqbaKwll4K5a7
	SPlbi1HF+FL555BtExwRngLUt5r/IRMvcD3e3bKTewx4S4xmdwzvVa5BAjiAPL0g9rdA=;
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1701142137020.8668@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Sat, Jan 14, 2017 at 09:42:48PM -0800, David Rientjes wrote:
> On Sat, 14 Jan 2017, Johannes Weiner wrote:
> 
> > The OOM killer livelock was the motivation for this patch. With that
> > ruled out, what's the point of this patch? Try a bit less hard to move
> > charges during task migration?
> > 
> 
> Most important part is to fail ->can_attach() instead of oom killing 
> processes when attaching a process to a memcg hierarchy.

Ah, that makes sense.

Could you please update the changelog to reflect this? Thanks!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
