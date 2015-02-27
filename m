From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC 0/2] add nproc cgroup subsystem
Date: Fri, 27 Feb 2015 06:49:40 -0500
Message-ID: <20150227114940.GB3964@htj.duckdns.org>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=+R/kasZOe2NxlwCcE4f1zhju2KX+phuZqYo1+DegRPM=;
        b=Zp8gauS3Z5gb59oMiti8apwLKR7pqsJZ0ef7ujyeH90XdL39iM1ZEsv1xaxzmFO9Th
         tPrdFwdI+mddQXXxFv6gQ+saoHOMxBWAm4aSSv2qzsoMhx0J2PyWo7u7AiC6P7Lh47Yx
         DDWRUDKyaUa6IsPcuJllmGZw8sLH30XZwx2QzKahYxC7uDUVPrUqiGEZ1hSerFpr7Js3
         zpCrdJZ1SUxhgz7S764TfdLFmw9a/6eYmIncyet6xIUDUsb+FuDlWLZIQA6H95T/32vV
         oLcjyTRRvUKpFKkSJ3Vwh/nIiP5crAAfqbDWO1XY6AzUIOGMnFpIyB7gADxqmg1kYTZX
         2ojw==
Content-Disposition: inline
In-Reply-To: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org, richard@nod.at, fweisbec@gmail.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Hello,

On Mon, Feb 23, 2015 at 02:08:09PM +1100, Aleksa Sarai wrote:
> The current state of resource limitation for the number of open
> processes (as well as the number of open file descriptors) requires you
> to use setrlimit(2), which means that you are limited to resource
> limiting process trees rather than resource limiting cgroups (which is
> the point of cgroups).
> 
> There was a patch to implement this in 2011[1], but that was rejected
> because it implemented a general-purpose rlimit subsystem -- which meant
> that you couldn't control distinct resource limits in different
> heirarchies. This patch implements a resource controller *specifically*
> for the number of processes in a cgroup, overcoming this issue.
> 
> There has been a similar attempt to implement a resource controller for
> the number of open file descriptors[2], which has not been merged
> becasue the reasons were dubious. Merely from a "sane interface"
> perspective, it should be possible to utilise cgroups to do such
> rudimentary resource management (which currently only exists for process
> trees).

This isn't a proper resource to control.  kmemcg just grew proper
reclaim support and will be useable to control kernel side of memory
consumption.

Thanks.

-- 
tejun
