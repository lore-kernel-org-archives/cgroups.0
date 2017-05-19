From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH v2 12/17] cgroup: Remove cgroup v2 no internal
 process constraint
Date: Fri, 19 May 2017 16:38:24 -0400
Message-ID: <20170519203824.GC15279@wtj.duckdns.org>
References: <1494855256-12558-1-git-send-email-longman@redhat.com>
 <1494855256-12558-13-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DJ3HUnYgDcd52eP/o6/U+fu9o3By+7Kd8MrFqmR8HYs=;
        b=ZCvGr1tI5K23wP9WJE1UG4k8YyJ0xZf3QJjsDSL3QsQYfAN9idjbcBqLAA3Xk/15Mu
         8Hc8E+hhX/ZB13CnMyFFxo28G7LkuFbq0fmJr9Urp0wbC+YZmoLJVYq6OOXcyWeLhcOr
         7q/4PV8CxpGKbXzSvomfY1jwvPP6EWGT0m9tddshCprQ5MnysTneG+oZHMqRp2xhF9M/
         0+EzegUWIhP4Gb/ldPVvuvhlmY6GBjm98L1YNImDivZY7luhVe4HEE/XKeAVbsFEiyQh
         z1tkkCwEm2U6KkDJetspUaNc9DlVNp4WS8pwSm6dKonS+ibV2t0Dzbn3hlIaI6LNRUNN
         jJvw==
Content-Disposition: inline
In-Reply-To: <1494855256-12558-13-git-send-email-longman@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de

Hello, Waiman.

On Mon, May 15, 2017 at 09:34:11AM -0400, Waiman Long wrote:
> The rationale behind the cgroup v2 no internal process constraint is
> to avoid resouorce competition between internal processes and child
> cgroups. However, not all controllers have problem with internal
> process competiton. Enforcing this rule may lead to unnatural process
> hierarchy and unneeded levels for those controllers.

This isn't necessarily something we can determine by looking at the
current state of controllers.  It's true that some controllers - pid
and perf - inherently only care about membership of each task but at
the same time neither really suffers from the constraint either.  CPU
which is the problematic one here and currently only cares about tasks
actually distributes resources which have parts which are specific to
domain rather than threads and we don't want to declare that CPU isn't
domain aware resource because it inherently is.

> This patch removes the no internal process contraint by enabling those
> controllers that don't like internal process competition to have a
> separate set of control knobs just for internal processes in a cgroup.
> 
> A new control file "cgroup.resource_control" is added. Enabling a
> controller with a "+" prefix will create a separate set of control
> knobs for that controller in the special "cgroup.resource_domain"
> sub-directory for all the internal processes. The existing control
> knobs in the cgroup will then be used to manage resource distribution
> between internal processes as a group and other child cgroups.

We would need to declare all major resource controllers to be needing
that special sub-directory.  That'd work around the
no-internal-process constraint but I don't think it is solving any
real problems.  It's just the kernel doing something that userland can
do with ease and more context.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
