From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 0/5] cgroup/cpuset: A new "isolcpus" paritition
Date: Wed, 12 Apr 2023 09:28:21 -1000
Message-ID: <ZDcGVebCpyktxyWh@slm.duckdns.org>
References: <20230412153758.3088111-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681327704; x=1683919704;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jJVB5ogjuRowz8vHiNaLNk0GIwsg2OONaPDtjebqjws=;
        b=lAE5KsnpHoUKow1r77yCi76DUHd9pEoglCRTUBFdO6kclN46JOwYWgeFSeLaig/aQv
         LSqZ7eMHXv7Aaioh2DpTRDexp3oWvfvUKmfBVUTfeRsT7WwhXv/di6nmxlfgzynasx8t
         ljUY1wChjepyBpaZAd4fRNLfmDnCS4WdWHps+WBgbF0xJfv00s5E1ROS1ENNMQKAakip
         UidVBcKd7vxusojPtQNG3Zkrr7YLPNRKQFFkzxPWli+aiAf3LCamusK2AUyPtEnfSsmK
         MI1tm3QwOQWPHQtk4iWARikXSj/hv0tZl8kwKtj0+3Gy/KqX41CVQxIQyDOavkD6JeFd
         fBJA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230412153758.3088111-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>

Hello, Waiman.

On Wed, Apr 12, 2023 at 11:37:53AM -0400, Waiman Long wrote:
> This patch series introduces a new "isolcpus" partition type to the
> existing list of {member, root, isolated} types. The primary reason
> of adding this new "isolcpus" partition is to facilitate the
> distribution of isolated CPUs down the cgroup v2 hierarchy.
> 
> The other non-member partition types have the limitation that their
> parents have to be valid partitions too. It will be hard to create a
> partition a few layers down the hierarchy.
> 
> It is relatively rare to have applications that require creation of
> a separate scheduling domain (root). However, it is more common to
> have applications that require the use of isolated CPUs (isolated),
> e.g. DPDK. One can use the "isolcpus" or "nohz_full" boot command options
> to get that statically. Of course, the "isolated" partition is another
> way to achieve that dynamically.
> 
> Modern container orchestration tools like Kubernetes use the cgroup
> hierarchy to manage different containers. If a container needs to use
> isolated CPUs, it is hard to get those with existing set of cpuset
> partition types. With this patch series, a new "isolcpus" partition
> can be created to hold a set of isolated CPUs that can be pull into
> other "isolated" partitions.
> 
> The "isolcpus" partition is special that there can have at most one
> instance of this in a system. It serves as a pool for isolated CPUs
> and cannot hold tasks or sub-cpusets underneath it. It is also not
> cpu-exclusive so that the isolated CPUs can be distributed down the
> sibling hierarchies, though those isolated CPUs will not be useable
> until the partition type becomes "isolated".
> 
> Once isolated CPUs are needed in a cgroup, the administrator can write
> a list of isolated CPUs into its "cpuset.cpus" and change its partition
> type to "isolated" to pull in those isolated CPUs from the "isolcpus"
> partition and use them in that cgroup. That will make the distribution
> of isolated CPUs to cgroups that need them much easier.

I'm not sure about this. It feels really hacky in that it side-steps the
distribution hierarchy completely. I can imagine a non-isolated cpuset
wanting to allow isolated cpusets downstream but that should be done
hierarchically - e.g. by allowing a cgroup to express what isolated cpus are
allowed in the subtree. Also, can you give more details on the targeted use
cases?

Thanks.

-- 
tejun
