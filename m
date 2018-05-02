From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2] mm: introduce memory.min
Date: Wed, 2 May 2018 08:30:40 -0400
Message-ID: <20180502123040.GA16060@cmpxchg.org>
References: <20180423123610.27988-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=t5D4EE9bo1btKKFdlC7eTsub/lkdqCm0TbELsGcGuYc=; b=mqp2OXs0tCDYv0UMGEkzkRQhA0
        iP+LdAnKBGNJOmIvbUY3YKoePcTaVh2EWumLHIHArlkX9y2PsWpuZMul7uhDfNwGYtRs0T1CzDQ0d
        /Tnmm0QFzIVP4fyEivFkm57pA7W2YQXp8nsRxrL1wGLPgjPmrEIgl7pjPZJY6yUbe8LM=;
Content-Disposition: inline
In-Reply-To: <20180423123610.27988-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Michal Hocko <mhocko@suse.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tejun Heo <tj@kernel.org>

On Mon, Apr 23, 2018 at 01:36:10PM +0100, Roman Gushchin wrote:
> @@ -59,6 +59,12 @@ enum memcg_memory_event {
>  	MEMCG_NR_MEMORY_EVENTS,
>  };
>  
> +enum mem_cgroup_protection {
> +	MEMCG_PROT_NONE,
> +	MEMCG_PROT_LOW,
> +	MEMCG_PROT_HIGH,

Ha, HIGH doesn't make much sense, but I went back and it's indeed what
I suggested. Must have been a brainfart. This should be

MEMCG_PROT_NONE,
MEMCG_PROT_LOW,
MEMCG_PROT_MIN

right? To indicate which type of protection is applying.

The rest of the patch looks good:

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
