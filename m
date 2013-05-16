From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch v3 -mm 2/3] memcg: Get rid of soft-limit tree
 infrastructure
Date: Thu, 16 May 2013 15:16:58 -0700
Message-ID: <20130516221658.GH7171@mtj.dyndns.org>
References: <1368431172-6844-1-git-send-email-mhocko@suse.cz>
 <1368431172-6844-3-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=D+vaeiIIH8eS3QhCPcpl6B2IyTRVpM8iZGpCkV20cGo=;
        b=enAvgfAmJK1y51f6yNYLYbJvAdRmJnGA4JBWrzHvpEBXg4VSbnwDke7bKWpLpIVlT5
         dxzUM87rm8bAWKtExbXEgt5WfENDLSySZJkwyIFLPIyaqOJcMC7aSSMKayLEZ5Yep6i/
         ODGHXMbQ++L20+LpvCaB2+J8inyuVxYG+J8Hxqr7hrsMcibQGNoJ7+eSMerBBW2I4TEc
         N9I9AZpw2WZv/1mNZo8KNNKn5/n927TEmeUwle5MeFPk6G0LEzmZj0lOoMdpXqczU3kS
         7xN8pCmxHQCTARqxBSJWaEDC/2I/H9iivxF0GtkHQC2VlsI8l/gQjMb7gVwCCGWXTbIK
         cAhw==
Content-Disposition: inline
In-Reply-To: <1368431172-6844-3-git-send-email-mhocko@suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>, Glauber Costa <glommer@parallels.com>, Michel Lespinasse <walken@google.com>, Greg Thelen <gthelen@google.com>, Balbir Singh <bsingharora@gmail.com>

On Mon, May 13, 2013 at 09:46:11AM +0200, Michal Hocko wrote:
> Now that the soft limit is integrated to the reclaim directly the whole
> soft-limit tree infrastructure is not needed anymore. Rip it out.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Reviewed-by: Tejun Heo <tj@kernel.org>

Nice cleanup, thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
