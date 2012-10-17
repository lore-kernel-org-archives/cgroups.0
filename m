From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v5 03/14] memcg: change defines to an enum
Date: Wed, 17 Oct 2012 14:50:17 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1210171450060.20712@chino.kir.corp.google.com>
References: <1350382611-20579-1-git-send-email-glommer@parallels.com> <1350382611-20579-4-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=dvvJ0Xz5PTLNxYtS++PG49/RkNUto1bG4x/CdEz3h3A=;
        b=PMAlwoT2p4toqECtzCC5gFC+3sTYPgMoYCydJZ/osOYoX1bZIV4BJPp2L5fMCDafZ8
         7UReRntcsdxcDXP3lvgHJtIYcqD7/IlKJvyzfUfGi3AdTlXSXs4s94NPrPLm7G7PYFqJ
         IeYhpiKkkn17C88YQyyIXWN3/TnjocSeLe7hSsTgUf/qrKZ+3YEpb04PhG/+y2Cx/igw
         hq6sk4zThZ67tmNrlF9PKljJNbXNlOWhUDjGKwkPgUsV3gm92T/57rqD3lTY8RVuxo1R
         PGeASzVz//5duF4Dh5zk+eVp/xH8hcB7zuIYQIdnEqzOCOZ8t6wuFLLF27bcqYKiDU1y
         pVOQ==
In-Reply-To: <1350382611-20579-4-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, kamezawa.hiroyu@jp.fujitsu.com, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, devel@openvz.org, linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012, Glauber Costa wrote:

> This is just a cleanup patch for clarity of expression.  In earlier
> submissions, people asked it to be in a separate patch, so here it is.
> 
> [ v2: use named enum as type throughout the file as well ]
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> Acked-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Acked-by: Michal Hocko <mhocko@suse.cz>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> CC: Tejun Heo <tj@kernel.org>

Acked-by: David Rientjes <rientjes@google.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
