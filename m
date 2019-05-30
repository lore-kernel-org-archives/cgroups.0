From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH REBASED] mm, memcg: Make scan aggression always exclude
 protection
Date: Wed, 29 May 2019 23:44:53 -0700
Message-ID: <20190530064453.GA110128@chrisdown.name>
References: <20190228213050.GA28211@chrisdown.name>
 <20190322160307.GA3316@chrisdown.name>
 <20190530061221.GA6703@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OtJUoXoSDr8VsqZMlQCV4tuhz5lMclRWprZBC+48UZI=;
        b=XUEorjCrLN9OrKuTIaR8sqQcataBFWGo19e2lBEQq/O74XS3Rv/gHEewD1Xhxg87dF
         Li12khbvVst/JlwygCiwvAhusNa3tSQFd4Sci5NEM5LIDG4i1O/IuqU4NCA4JrjyTjI5
         Z8e+mv6BlLgw2Wij6fVvKbwpyso+4TBaM01wI=
Content-Disposition: inline
In-Reply-To: <20190530061221.GA6703@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

Michal Hocko writes:
>Maybe I am missing something so correct me if I am wrong but the new
>calculation actually means that we always allow to scan even min
>protected memcgs right?

We check if the memcg is min protected as a precondition for coming into this 
function at all, so this generally isn't possible. See the mem_cgroup_protected 
MEMCG_PROT_MIN check in shrink_node.

(Of course, it's possible we race with going within protection thresholds 
again, but this patch doesn't make that any better or worse than the previous 
situation.)
