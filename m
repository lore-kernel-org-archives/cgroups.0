From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] cgroup/cpuset: Change references of cpuset_mutex to
 cpuset_rwsem
Date: Mon, 13 Sep 2021 08:06:36 -1000
Message-ID: <YT+TLDAsFulWiW/F@slm.duckdns.org>
References: <20210910024256.7615-1-longman@redhat.com>
 <20210910024256.7615-2-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UezHGcxNyfBcoSgxd4hGReV1amoCkpndioXZIVK6Ldk=;
        b=KnpzewmoKWskYVWA28O7T+PmEpz94a6k3t+RifGRk8GmiE6GyfN07hPDF1H/3jnfHA
         uSg5d+JeF15qhOlapCy6kaOketRAkxSRxPmlBoQhLe7pv6DUOKmm3YdetTKj1+Kkju87
         ZlE+Hag61BB4Qn4FUpUngBdaNi3R+JKfwKHaBKqjrIXkamkWQ6Wpv2ikw/W+yRRXpiEp
         ixd3L7wlaMfsk1CwYJ/4Tr/IeHDToKuoYJQ7YPmuxsiZAddJqILGyCevhOK+8dGcaStq
         IY8gWfjqYhdut96tvYAbXuobY8GU+tDcK2lAzD8wPigSfOyjN+1CMuD8JGr40BwcPi21
         pwVQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210910024256.7615-2-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Juri Lelli <juri.lelli@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Sep 09, 2021 at 10:42:56PM -0400, Waiman Long wrote:
> Since commit 1243dc518c9d ("cgroup/cpuset: Convert cpuset_mutex to
> percpu_rwsem"), cpuset_mutex has been replaced by cpuset_rwsem which is
> a percpu rwsem. However, the comments in kernel/cgroup/cpuset.c still
> reference cpuset_mutex which are now incorrect.
> 
> Change all the references of cpuset_mutex to cpuset_rwsem.
> 
> Fixes: 1243dc518c9d ("cgroup/cpuset: Convert cpuset_mutex to percpu_rwsem")
> Signed-off-by: Waiman Long <longman@redhat.com>

Applied to cgroup/for-5.15-fixes.

Thanks.

-- 
tejun
