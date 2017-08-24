From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cpuset: Allow cpuset controller in default hierarchy
Date: Thu, 24 Aug 2017 07:43:22 -0700
Message-ID: <20170824144322.GP491396@devbig577.frc2.facebook.com>
References: <1503585611-13496-1-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tR8mcJ6l06Cu0doJ2AlWeKzH6uRjGb04hVf3Jpw7DdI=;
        b=bu2s08PMZn7wfcaJurI0HMriwQhRcEBIRCnta0/+/RLjtfdU5Q/h+Qant+dMUwfoVS
         VebbgK3xiNrgMJrFVxh38HK7RfF+ABoGu1C/dTHlARXV0oRENB5e7DmVfOJTwO1aOgx9
         6qIqj3DOhEqhuBAe5z9SDARsBbzwPE1Unq7dm2pZob2508e6TDznEE51iS9mLmmR5j9V
         LA0jghOKWrJMegf2gN3geIDDAxgfkXM6zwwdSqj0A7u9rm1iVyjLgceyjVEAhGX1a1GV
         MMIbOqcQnlEuNjZwhw5qbG2a15yCksUFHUeRpV4l322TjyYsXjpGPoFsv7U9Ly+G7KP6
         H4Dw==
Content-Disposition: inline
In-Reply-To: <1503585611-13496-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello, Waiman.

On Thu, Aug 24, 2017 at 10:40:11AM -0400, Waiman Long wrote:
> Given the fact that thread mode is now queued for 4.14, it is now
> time to enable cpuset to be used in the default hierarchy (cgroup v2)
> as it is clearly threaded.

I'm not sure we want things like exclusive settings in v2 as it
directly violates basic hierarchy rules (a sibling shouldn't be able
to affect what another sibling can or can't do).  We need to think
more about what should be exposed in v2.

Thanks.

-- 
tejun
