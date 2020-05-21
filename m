From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: reclaim more aggressively before high
 allocator throttling
Date: Thu, 21 May 2020 13:24:38 +0100
Message-ID: <20200521122438.GC990580@chrisdown.name>
References: <20200520143712.GA749486@chrisdown.name>
 <20200520160756.GE6462@dhcp22.suse.cz>
 <20200520202650.GB558281@chrisdown.name>
 <20200521071929.GH6462@dhcp22.suse.cz>
 <20200521112711.GA990580@chrisdown.name>
 <20200521120455.GM6462@dhcp22.suse.cz>
 <20200521122327.GB990580@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i8JutcblGoAISDN3hurAlHLL13/lujc4PGXCcoNOdiE=;
        b=ZskJd2rQupY8tV+of+gT2pNGrghG1kvcp0tUt8lYVHWX2N2357xtDLydnxma2icUrj
         b0RUe9qLlaHWLEn5ePS8DecHifXObN+IFUNHUwWuvKcDjwbkP7AMXFLIg+NakaL4dG4H
         XE7j3wic9ZZzBWOrSIpnnr08PFqEOA4rd/aeM=
Content-Disposition: inline
In-Reply-To: <20200521122327.GB990580-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Chris Down writes:
>A cgroup is a unit and breaking it down into "reclaim fairness" for 
>individual tasks like this seems suspect to me. For example, if one 
>task in a cgroup is leaking unreclaimable memory like crazy, everyone 
>in that cgroup is going to be penalised by allocator throttling as a 
>result, even if they aren't "responsible" for that reclaim.

s/for that reclaim/for that overage/
