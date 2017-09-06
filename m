From: Prateek Sood <prsood@codeaurora.org>
Subject: Re: [PATCH] Workqueue lockup: Circular dependency in threads
Date: Wed, 6 Sep 2017 16:47:25 +0530
Message-ID: <6de44880-c641-5e89-ff07-68ba206b692c@codeaurora.org>
References: <1504101538-20075-1-git-send-email-prsood@codeaurora.org>
 <bc1016ee-792e-87f8-5158-777b7f9405b8@codeaurora.org>
 <20170905132242.GA1774378@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1504696651;
        bh=XhzY4cUx5LGUo8QQ4Pct9a8bC9sRP5blxDaOIiyy/LQ=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=HgSlXAe85k1qvZlovBbbHcN0O3Wtwo63At92Zbl0lrAtkaFD/vh6MNECZ6UPIUqi4
         NJt2xf4SckOZCZVSs1ZX1T8yMzpTFuPeYRIL4TXq/LITvrrOI+q3dPpdZdJCYNE0Nn
         eRFzJBXmlPq+Zs2F1GDLjKznWLjjRr40mBuTOHGA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1504696650;
        bh=XhzY4cUx5LGUo8QQ4Pct9a8bC9sRP5blxDaOIiyy/LQ=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=EWHQ9H7nz7D6O59h05BlKCid+wegj8Po4k+YaweDdeg2wsK9uXoBS4vZdbr9HxMXH
         W9G6RLGYl3PQENg7Kmi9EVw5/PjC0jSSvYXOETWT9EeZV1tqqSDZFVqvfCsF8fpUZO
         h8QoCSIbK/yilaU6tZkWYP83iAjgNWo6+I9M3q8s=
In-Reply-To: <20170905132242.GA1774378@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, sramana@codeaurora.org, mingo@kernel.org, longman@redhat.com, apkm@linux-foundation.org

On 09/05/2017 06:52 PM, Tejun Heo wrote:
> Hello,
> 
> On Thu, Aug 31, 2017 at 06:43:56PM +0530, Prateek Sood wrote:
>>> 6) cpuset_mutex is acquired by task init:1 and is waiting for cpuhotplug lock.
> 
> Yeah, this is the problematic one.
> 
>>> We can reorder the sequence of locks as in the below diff to avoid this
>>> deadlock. But I am looking for inputs/better solution to fix this deadlock.
>>>
>>> ---
>>> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
>>>  /**
>>>   * update_tasks_cpumask - Update the cpumasks of tasks in the cpuset.
>>>   * @cs: the cpuset in which each task's cpus_allowed mask needs to be changed
>>> @@ -930,7 +946,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
>>>  	rcu_read_unlock();
>>>  
>>>  	if (need_rebuild_sched_domains)
>>> -		rebuild_sched_domains_locked();
>>> +		rebuild_sched_domains_unlocked()(without taking cpuhotplug.lock)
>>>  }
>>>  
>>>  /**
>>> @@ -1719,6 +1735,7 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
>>> +	get_online_cpus();
>>>  	mutex_lock(&cpuset_mutex);
>>>  	if (!is_cpuset_online(cs))
>>>  		goto out_unlock;
>>> @@ -1744,6 +1761,7 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
>>>  	mutex_unlock(&cpuset_mutex);
>>> +	put_online_cpus();
>>>  	kernfs_unbreak_active_protection(of->kn);
>>>  	css_put(&cs->css);
>>>  	flush_workqueue(cpuset_migrate_mm_wq);
>>>
> 
> And the patch looks good to me.  Can you please format the patch with
> proper description and sob?
> 
> Thanks.
> 

Thanks for review Tejun

I will send updated patch.

-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation
Center, Inc., is a member of Code Aurora Forum, a Linux Foundation
Collaborative Project
