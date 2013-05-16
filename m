From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch v3 -mm 1/3] memcg: integrate soft reclaim tighter with
 zone shrinking code
Date: Thu, 16 May 2013 15:15:01 -0700
Message-ID: <20130516221501.GG7171@mtj.dyndns.org>
References: <1368431172-6844-1-git-send-email-mhocko@suse.cz>
 <1368431172-6844-2-git-send-email-mhocko@suse.cz>
 <20130516221200.GF7171@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=2gMa+u7liJLWk3yj3WLXt5MB5AUxjSEdb7E67Y1crt0=;
        b=nLEOtlah0FvnHc1+K0i8Z8es/84nT2FTL/Q9swlWUkcq7vDo3PTZZ6rchvDAXx5el/
         2W4dH09mW61DWsF/DWIuynhUoJpeeE2sLR6jI81kDzBPWrb1mVNdwtUdeuggmTdYElXw
         WutB4iewX7aCIx+2xUfXZgwpGPFEazNRbc58sfz8F1/DPfit796mxk0jIpWNeYSLQevZ
         1gWulFV1e6W3uPcY65doj7hZwSdOLuZtLqnke1HnXjrUhfKnrGlYAHtKZWAVEr5CTYdG
         wZGQoyCUhIel15K6iOT/t1ibj6/NGSRcfGGH/DcrxI0aLe3nEeUot4n3VtTqs1Vr/m2j
         Xx+w==
Content-Disposition: inline
In-Reply-To: <20130516221200.GF7171@mtj.dyndns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>, Glauber Costa <glommer@parallels.com>, Michel Lespinasse <walken@google.com>, Greg Thelen <gthelen@google.com>, Balbir Singh <bsingharora@gmail.com>

One more thing,

Given that this is a rather significant behavior change, it probably
is a good idea to include the the benchmark results from the head
message?

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
