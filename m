From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: Fix uninitialized variable warning
Date: Wed, 23 Dec 2015 16:35:19 -0500
Message-ID: <20151223213519.GM5003@mtj.duckdns.org>
References: <1450906240-21821-1-git-send-email-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=FTMfo3PTq6zAHrr7fgwsidnb+nLSlTkBipX4WFgto2Y=;
        b=ItFZLU/MDS00yoFPB6en5GjDFXQrUrlbMqL/3robycSDw9LoNPkTJYIDlrR7smsTq7
         zCXPhUTlL3JeWYxp1h8bKaVWrsaUlT3pXs8A3bspTETE7pMW3KD+G9FmRGrLEbBGDUYf
         xjJxhyzfmUl5t6kwkFJa55FJ36Vegs0cFTzSUMS3X8ov79RSr9mrkdyIY2TIVp5mcAll
         cFwv51Q8Fn7vdJn5N7mbm1aJstPvWwqvBI57vkYWxh/qtrAiKhynP8McYVvujXrKXoQn
         ucNqJkMYVRWhDpwyGd7ezqHVMIS4EObhIxbk3FzH48fmw+aI6rlacbq3UqjPzc1LEAjD
         jHjg==
Content-Disposition: inline
In-Reply-To: <1450906240-21821-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Li Zefan <lizefan@huawei.com>, Daniel Wagner <daniel.wagner@bmw-carit.de>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>, kernel-team@fb.com, Aleksa Sarai <cyphar@cyphar.com>, Michal Hocko <mhocko@kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Neil Horman <nhorman@tuxdriver.com>

Hello, Ross.

On Wed, Dec 23, 2015 at 02:30:40PM -0700, Ross Zwisler wrote:
>  static int mem_cgroup_can_attach(struct cgroup_taskset *tset)
>  {
>  	struct cgroup_subsys_state *css;
> -	struct mem_cgroup *memcg;
> +	struct mem_cgroup *memcg = NULL;

It's one thing to add spurious init to shut up gcc

> @@ -4805,7 +4805,7 @@ static int mem_cgroup_can_attach(struct cgroup_taskset *tset)
>  		p = leader;
>  		memcg = mem_cgroup_from_css(css);
>  	}
> -	if (!p)
> +	if (!p || !memcg)

and to another to add an additional processing on it.

Please note which gcc version you were using in the commit description
and mark the init with a comment.

Thanks.

-- 
tejun
