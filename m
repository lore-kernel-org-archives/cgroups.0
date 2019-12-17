From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH] mm: memcontrol.c: move mem_cgroup_id_get_many under
 CONFIG_MMU
Date: Tue, 17 Dec 2019 15:32:13 +0000
Message-ID: <20191217153213.GC136178@chrisdown.name>
References: <20191217135440.GB58496@chrisdown.name>
 <392D7C59-5538-4A9B-8974-DB0B64880C2C@lca.pw>
 <20191217144652.GA7272@dhcp22.suse.cz>
 <20191217150921.GA136178@chrisdown.name>
 <20191217151931.GD7272@dhcp22.suse.cz>
 <20191217152814.GB136178@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Jr1dFn2z1P4MsCtmqPO29rPINYbqBsWbvl95K0lo3qY=;
        b=S8MaiI4Z66kRaGiMhNUN5izJT/aLZ2SBTEoB/9/RfJGT+OLbgVeTb6CrjMk2gwEaEM
         iApa7Msqy8sCczZO6v7wBKLtLk0o2ps7CXJQeGl93tTlLgTx8zPCahSxnVSmPwoBo6gP
         QBL1DbYqpLBffIsBuRFiZz/01B9trZgNwndZM=
Content-Disposition: inline
In-Reply-To: <20191217152814.GB136178@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Qian Cai <cai@lca.pw>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

Chris Down writes:
>Maybe Qian is right and we should just ignore such patches, but I 
>think that comes with its own risks that we will alienate perfectly 
>well intentioned new contributors to mm without them having any idea 
>why we did that.

s/Qian/Cai/ :-)
