From: Chintan Pandya <cpandya-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH] memcg: Provide knob for force OOM into the memcg
Date: Wed, 17 Dec 2014 17:41:29 +0530
Message-ID: <549172F1.5050303@codeaurora.org>
References: <1418736335-30915-1-git-send-email-cpandya@codeaurora.org> <20141216165922.GA30984@phnom.home.cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141216165922.GA30984-HTCKtW7iVlxqnrmGgq4/JMIURNUf+fel@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: mhocko-AlSwsSmVLrQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


> Why do you move tasks around during runtime?  Rather than scanning
> thousands or millions of page table entries to relocate a task and its
> private memory to another configuration domain, wouldn't it be easier to
> just keep the task in a dedicated cgroup and reconfigure that instead?

Your suggestion is good. But in specific cases, we may have no choice 
but to migrate.

Take a case of an Android system where a process/app will never gets 
killed until there is really no scope of holding it any longer in RAM. 
So, when that process was running as a foreground process, it has to 
belong to a group which has no memory limit and cannot be killed. Now, 
when the same process goes into background and sits idle, it can be 
compressed and cached into some space in RAM. These cached processes are 
ever growing list and can be capped with some limit. Naturally, these 
processes belongs to different category and hence different cgroup which 
just controls such cached processes.

>
> There doesn't seem to be a strong usecase for charge migration that
> couldn't be solved by doing things slightly differently from userspace.
> Certainly not something that justifies the complexity that it adds to
> memcg model and it's synchronization requirements from VM hotpaths.
> Hence, I'm inclined to not add charge moving to version 2 of memcg.

Do you say charge migration is discouraged at runtime ? Difficult to 
live with this limitation.

-- 
Chintan Pandya

QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
member of the Code Aurora Forum, hosted by The Linux Foundation
