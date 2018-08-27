From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v12 9/9] cpuset: Support forced turning off of partition
 flag
Date: Mon, 27 Aug 2018 09:40:04 -0700
Message-ID: <20180827164004.GE3978217@devbig004.ftw2.facebook.com>
References: <1535380884-31308-1-git-send-email-longman@redhat.com>
 <1535380884-31308-10-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UvrArh45BLr7dWBLMCweGOwgpp4+m2LYlxRRHm51Jzo=;
        b=phuNN0F4ps2C5485v2LFVyv4QPgAcc44HNZUyH4veVibq87+zzQadCt9vn8UKN6j/A
         OeyOWgOQpiXbHIW7L2BZKgWoJAyJk5rRk8LkWO+19ZcIVTM42n8b4if3hTHaDwN91/qD
         zDFuyAeTJGV/SyfGym+mWhE//yaBjxFU+ochk6dWNwgWljA65lgKcfQ61FMCsVxTbHnc
         YmxnxfyautknIUs+TKlNOA8CDByHcgR0FBfAeHD9yt5Yw8Adr9pAg36pFAg0RlstopCK
         q/TzU5Kw+QwRLyahiKaE8dlz0kM3NPXbwqtEIWGqWzSBhpaTo5haNublN9L0L7/bls5A
         7J9g==
Content-Disposition: inline
In-Reply-To: <1535380884-31308-10-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

Hello, Waiman.

On Mon, Aug 27, 2018 at 10:41:24AM -0400, Waiman Long wrote:
> Cpuset allows arbitrary modification of cpu list in "cpuset.cpus"
> even if the requested CPUs won't be granted in "cpuset.cpus.effective"
> as restricted by its parent. However, the validate_change() function
> will inhibit removal of CPUs that have been used in child cpusets.
> 
> Being a partition root, however, limits the kind of cpu list
> modification that is allowed. Adding CPUs is not allowed if the new
> CPUs are not in the parent's effective cpu list that can be put into
> "cpuset.cpus.reserved". In addition, a child partition cannot exhaust
> all the parent's effective CPUs.
> 
> Because of the implicit cpu exclusive nature of the partition root,
> cpu changes that break that cpu exclusivity will not be allowed. Other
> changes that break the conditions of being a partition root is generally
> allowed. However, the partition flag of the cpuset as well those of
> the descendant partitions will be forcefully turned off.

First of all, thanks a lot for your persistence.  I'm not necessarily
against the flag being forced off but wonder whether the same
config/effective approach can be used as in .cpus and .mems.  Can you
elaborate a bit on the choice here?

Thank you.

-- 
tejun
