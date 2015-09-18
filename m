From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/5] cgroup, memcg, cpuset: implement
 cgroup_taskset_for_each_leader()
Date: Fri, 18 Sep 2015 12:04:17 -0400
Message-ID: <20150918160417.GD4065@mtj.duckdns.org>
References: <1441998022-12953-1-git-send-email-tj@kernel.org>
 <1441998022-12953-3-git-send-email-tj@kernel.org>
 <20150914204907.GI25369@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=hidz/mFRRjxwZ1bJm4hTwtKon4Zdlz/MBWZ0Md0tUb0=;
        b=gD8ixgANq2G/XnpnJsQ6MSvD+rOfyuy7O6X1tfayabMZwu0uaSRUig89LsC84LAy1U
         xK1HihWKSBA/REAeeMv9Pv/Ps3kF1lZV5NiYbMMecWkS7YfUKXZppvXI0Utuc5angXJR
         oYXvlGvRVX6YkwGC7iyEN2GX5SZKkYwL9PmJE0Gby/5HqDyP8G1B0iK8br47VLF0Dud5
         FJMh653Lb7DkMfj3rtPlfZmz7jl9Bzm2xGAfCaPYsdQzp3NJYgUnkZFtFJRV22n7FCa5
         FCdFsIjT95WNjFFQ1MWjM9Ihz6gRGDpG2Dho7COKNaS5/pSgJkpLTf2C3o9BjL4WL7X9
         fv5w==
Content-Disposition: inline
In-Reply-To: <20150914204907.GI25369@htj.duckdns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, hannes@cmpxchg.org, mhocko@suse.cz, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Mon, Sep 14, 2015 at 04:49:07PM -0400, Tejun Heo wrote:
> Michal, if you're okay with this patch, I'll apply the patchset in
> cgroup/for-4.4.

Michal?

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
