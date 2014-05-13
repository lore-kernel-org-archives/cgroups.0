From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH cgroup/for-3.16] cgroup: fix rcu_read_lock() leak in
 update_if_frozen()
Date: Tue, 13 May 2014 11:34:45 -0400
Message-ID: <20140513153445.GG23710@htj.dyndns.org>
References: <5369104d.Nn5Lpp7nwOehwnnC%fengguang.wu@intel.com>
 <20140510032941.GE22539@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=9luEPUR1nTF5jEW/1EfhDF0/dgVSnKpYTFw7uH3t1P8=;
        b=KfdbESV4lKoxsYAUrQmH9FLDnMQVnqkEnUj3DVxayx1vw3zkBOPSg7dZNSoeWAVPTd
         QDNReJrHYbNtPUkVJm2k+gkf5c/3NzTpYJPZU2bQiyWl1yP5qjv5ap4plJKbJws4srTs
         spGgdk/MWpr7HyIWSNL3940fUSy5Ru6ouNQN9IW/6fHVE8a1LU4feRQhhbuskIKfPtKD
         SkZJoL67u2WzbRWb05BkbfZYJlffEBNStKq87NCi1v2s8EAbESVwa+gafMLjgDpkbrvL
         /c2HxcKIKNnycWyoQBUEeigNZL/TLMFEUbHaLKy8a3leA9HunDk7mYqBAtylQN+VsoSz
         g7Ow==
Content-Disposition: inline
In-Reply-To: <20140510032941.GE22539@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: kbuild test robot <fengguang.wu@intel.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 11:29:41PM -0400, Tejun Heo wrote:
> While updating cgroup_freezer locking, 68fafb77d827 ("cgroup_freezer:
> replace freezer->lock with freezer_mutex") introduced a bug in
> update_if_frozen() where it returns with rcu_read_lock() held.  Fix it
> by adding rcu_read_unlock() before returning.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: kbuild test robot <fengguang.wu@intel.com>

Applied to cgroup/for-3.15-fixes.

Thanks.

-- 
tejun
