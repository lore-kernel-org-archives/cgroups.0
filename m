From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v5 04/14] kmem accounting basic infrastructure
Date: Thu, 18 Oct 2012 12:47:27 -0700
Message-ID: <20121018194727.GB13370@google.com>
References: <1350382611-20579-1-git-send-email-glommer@parallels.com>
 <1350382611-20579-5-git-send-email-glommer@parallels.com>
 <alpine.DEB.2.00.1210171455010.20712@chino.kir.corp.google.com>
 <508035E3.4080508@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=8juk3OCF47JbBIRsXz9uZ/s3yc/N/sp4lLm0Mnk7NH0=;
        b=wDfKrAU8nLoG5/8CYV8MafKWcvNS/aS9Xxa3Chjlnc4WppI8PKvkdkhqq3SqqIM5Xd
         4wFf7PSwSfBS/wuK/4yql6PRZU6N0QHDcOLzyyWGfb07wwum+c2nqkifNNF8LR4Hc1d9
         2t2qs0uHiERAWEWG0VYU60jwHD5R6teefjAyaXr6nH8DGJgw5xC6sWY/hw0BaZIa/ny5
         q5xFTXuzhOyeE5v6PNQRpIsch6OyYtnR0oJoLAYp88+9e6KW7uKoaz9k5q4ptcc7R80C
         eSuU7dT2MVqPimWMWJLv+XkLI0TAxbjn4jOGIQnqifLSZhVI+3ePgpWHnYVB7oTtoCSG
         shqQ==
Content-Disposition: inline
In-Reply-To: <508035E3.4080508@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, kamezawa.hiroyu@jp.fujitsu.com, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, devel@openvz.org, linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>

Hey, Glauber.

On Thu, Oct 18, 2012 at 09:01:23PM +0400, Glauber Costa wrote:
> That is the offensive part. But it is also how things are done in memcg
> right now, and there is nothing fundamentally different in this one.
> Whatever lands in the remaining offenders, can land in here.

I think the problem here is that we don't have "you're committing to
creation of a new cgroup" callback and thus subsystem can't
synchronize locally against cgroup creation.  For task migration
->attach() does that but cgroup creation may fail after ->create()
succeeded so that doesn't work.

We'll probably need to add ->post_create() which is invoked after
creation is complete.  Li?

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
