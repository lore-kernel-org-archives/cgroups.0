From: David Rientjes <rientjes@google.com>
Subject: Re: [V5 PATCH 08/26] memcontrol: use N_MEMORY instead
 N_HIGH_MEMORY
Date: Mon, 29 Oct 2012 13:40:39 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1210291340100.18552@chino.kir.corp.google.com>
References: <1351523301-20048-1-git-send-email-laijs@cn.fujitsu.com> <1351524078-20363-7-git-send-email-laijs@cn.fujitsu.com> <20121029162212.GE20757@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=h8IdUH/RCkxb5q/PbPm1abBgD9RIEAM79iSQv/NaqaE=;
        b=MnaVZk+coSXHDe96woD1vJ46hYdgGZXJy2wZt7co60ssyKhDbPtiEtwlzSImGvUEws
         6r5uLIG51o4riVze54qVberFap75GlnUSQ3mRsvQg/uLxPWAY5LdYsSGhSXtn9s9hYM2
         RXhbrv+VT+N3w7JwlnIm+sjORvR9Ymq288yscHSdcUmI+Nc+4COJsM66pSN8SzZ2DLvQ
         gZObYbCc8y5/NggvTDVNZ8TLYNR6af3UIjsHa+6iNWXSI1se9PkQqzyBdrONYuXA/zZh
         D+RPc5mJJlYOwbM3d3BeQINJj0+nlwvoympudP2nPihUEAFNkVkiL1rlJDLtfOD3cisk
         xv6g==
In-Reply-To: <20121029162212.GE20757@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>, LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>, Jiang Liu <jiang.liu@huawei.com>, Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yinghai@kernel.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Balbir Singh <bsingharora@gmail.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, containers@lists.linux-foundation.org

On Mon, 29 Oct 2012, Michal Hocko wrote:

> > N_HIGH_MEMORY stands for the nodes that has normal or high memory.
> > N_MEMORY stands for the nodes that has any memory.
> 
> What is the difference of those two?
> 

Patch 5 in the series introduces it to be equal to N_HIGH_MEMORY, so 
accepting this patch would be an implicit ack of the direction taken 
there.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
