From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH v2 08/17] cgroup: Move debug cgroup to its own file
Date: Fri, 19 May 2017 16:28:09 -0400
Message-ID: <20170519202809.GB15279@wtj.duckdns.org>
References: <1494855256-12558-1-git-send-email-longman@redhat.com>
 <1494855256-12558-9-git-send-email-longman@redhat.com>
 <20170517213603.GE942@htj.duckdns.org>
 <ee36d4f8-9e9d-a5c7-2174-56c21aaf75af@redhat.com>
 <20170519192146.GA9741@wtj.duckdns.org>
 <8d942ee6-ebf4-5ba5-5484-60762808f544@redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mJdpy9hWdn/ERg/4O7hKOo1ZGGOzhiqXlwnAjlDwiJM=;
        b=jXdI3warR/Z2yHEpsoKnlIeNA95PIpOlAdkmEsFLoGP//i9SXwAGjEsdTOt4bghvXJ
         gZb3UmqUfu+x+ybEhqxWZ7O9JjyaldFsnH9BoNf9yCwrjEge4kwapC0wOXw+wLrZUKMo
         4FgqphFnCcGou9FMM1q8luVJLRQj/t3bVF01gWghy7tpHmXfVH3V+cW6hI3c3uaqtcmQ
         gRjlwGBqfwVK/dSehwbMMgGfFbfmOJv5jGfw4Eo/OL/TwhnZ2dWg4EXN5DrtbFCLQduh
         90IsCe0c3Cbhy0IkVf5gi0hX8P1Hi/7Cl4fvt/SswFRWAXmGe3GJ0yx168VlwF2h9QXQ
         pAmA==
Content-Disposition: inline
In-Reply-To: <8d942ee6-ebf4-5ba5-5484-60762808f544@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de

Hello,

On Fri, May 19, 2017 at 03:33:14PM -0400, Waiman Long wrote:
> On 05/19/2017 03:21 PM, Tejun Heo wrote:
> > Yeah but it also shows up as an integral part of stable interface
> > rather than e.g. /sys/kernel/debug.  This isn't of any interest to
> > people who aren't developing cgroup core code.  There is no reason to
> > risk growing dependencies on it.
> 
> The debug controller is used to show information relevant to the cgroup
> its css'es are attached to. So it will be very hard to use if we
> relocate to /sys/kernel/debug, for example. Currently, nothing in the
> debug controller other than debug_cgrp_subsys are exported. I don't see
> any risk of having dependency on that controller from other parts of the
> kernel.

Oh, sure, I wasn't suggesting moving it under /sys/kernel/debug but
that we'd want to take extra precautions as we can't.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
