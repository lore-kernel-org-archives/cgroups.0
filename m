From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch 7/8] mm, memcg: allow processes handling oom
 notifications to access reserves
Date: Wed, 4 Dec 2013 21:50:26 -0500
Message-ID: <20131205025026.GA26777@htj.dyndns.org>
References: <20131119134007.GD20655@dhcp22.suse.cz>
 <alpine.DEB.2.02.1311192352070.20752@chino.kir.corp.google.com>
 <20131120152251.GA18809@dhcp22.suse.cz>
 <alpine.DEB.2.02.1311201917520.7167@chino.kir.corp.google.com>
 <20131128115458.GK2761@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312021504170.13465@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1312032116440.29733@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1312032118570.29733@chino.kir.corp.google.com>
 <20131204054533.GZ3556@cmpxchg.org>
 <alpine.DEB.2.02.1312041742560.20115@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=yxo7notXnVTJTjAkmY8JcJk+EfhPq762xenQIC+8lFM=;
        b=Ahz++RWaWMDqeHA4OmLQl1gsjQuIWJBQfiNjkFj/NTOuhuVTqS/DgID/T4yEKP/l7r
         e3dQlFgNlW1aJv07Nf2eRwpsKvPMhY8k7/wBNJJ3tuZ1R3x/3zVRd1o8yaF1LZcLgc6f
         BziiKDNZpCIqV/1YGHunF96jRjgb86jqP6s3cnUILuxnF+OXTbeSpEB4/MLAWEMcDWZ4
         yqGmWyl3SwvcKT8C6GkCl8FmL/qYr8USz6jL6r8LneMd6nnRn4e3uelWLGZHnY/XI9vq
         xq0Z1ilVmF36pgcycMBYK9xt+2yVArmM/9PB4sS1/8wdFqXeWWgeHH7M8KhGip9eIq3D
         UzLw==
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312041742560.20115@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux-foundation.org>, Li Zefan <lizefan@huawei.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

Hello,

On Wed, Dec 04, 2013 at 05:49:04PM -0800, David Rientjes wrote:
> That's not what this series is addressing, though, and in fact it's quite 
> the opposite.  It acknowledges that userspace oom handlers need to 
> allocate and that anything else would be too difficult to maintain 
> (thereby agreeing with the above), so we must set aside memory that they 
> are exclusively allowed to access.  For the vast majority of users who 
> will not use userspace oom handlers, they can just use the default value 
> of memory.oom_reserve_in_bytes == 0 and they incur absolutely no side-
> effects as a result of this series.

Umm.. without delving into details, aren't you basically creating a
memory cgroup inside a memory cgroup?  Doesn't sound like a
particularly well thought-out plan to me.

> For those who do use userspace oom handlers, like Google, this allows us 
> to set aside memory to allow the userspace oom handlers to kill a process, 
> dump the heap, send a signal, drop caches, etc. when waking up.

Seems kinda obvious.  Put it in a separate cgroup?  You're basically
saying it doesn't want to be under the same memory limit as the
processes that it's looking over.  That's like the definition of being
in a different cgroup.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
