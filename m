From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] cgroup/cpuset: Enable memory migration for cpuset v2
Date: Thu, 12 Aug 2021 11:41:15 -1000
Message-ID: <YRWVe5j8G2LLvTt4@slm.duckdns.org>
References: <20210811195707.30851-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TAC7usbSxJAj4Uf52V6UWSOyNZ0nwEBnpPn4ZOBy98U=;
        b=N19jAu7ypTXt6WK7cfJ0LMDOqywRj+Jwavt99QhQohJWtN4D3MU5t9zGcqaItP0Gt6
         Z8wkY6LhQhZ61HOWBUtfY8d6PLtkaMY7xGmmmvr8Q9vgQXi2lDBhCXzPedrMqMgy44OX
         BkCZfXCvjlGo8duK1PJTdKuhu5tQcgvVwNQBFvscXnfMVEdjPgs8BfJ7v3ApWfkBzeYZ
         Qur5/Wv9akKhyJn+x3QOE1D2tDZdUkTO9cnK+qC4Wx6QdnHDzbAkoCgDQD5PIYXDJ8V/
         NoZnEZ2VEhJWtk8/WwgZ6qImb4PDaCBvAiornHAvrL+UcURc6q3EwSf2JVxrxaN9q47j
         FyYQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210811195707.30851-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org

On Wed, Aug 11, 2021 at 03:57:07PM -0400, Waiman Long wrote:
> When a user changes cpuset.cpus, each task in a v2 cpuset will be moved
> to one of the new cpus if it is not there already. For memory, however,
> they won't be migrated to the new nodes when cpuset.mems changes. This is
> an inconsistency in behavior.
> 
> In cpuset v1, there is a memory_migrate control file to enable such
> behavior by setting the CS_MEMORY_MIGRATE flag. Make it the default
> for cpuset v2 so that we have a consistent set of behavior for both
> cpus and memory.
> 
> There is certainly a cost to make memory migration the default, but it
> is a one time cost that shouldn't really matter as long as cpuset.mems
> isn't changed frequenty.  Update the cgroup-v2.rst file to document the
> new behavior and recommend against changing cpuset.mems frequently.
> 
> Since there won't be any concurrent access to the newly allocated cpuset
> structure in cpuset_css_alloc(), we can use the cheaper non-atomic
> __set_bit() instead of the more expensive atomic set_bit().
> 
> Signed-off-by: Waiman Long <longman@redhat.com>

Applied to cgroup/for-5.15.

Thanks.

-- 
tejun
