From: Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH 3/5] cgroup: fix mount failure in a corner case
Date: Tue, 24 Jun 2014 09:15:01 +0800
Message-ID: <53A8D115.5060302@huawei.com>
References: <53994943.60703@huawei.com> <5399496D.6060003@huawei.com> <20140620191025.GA28324@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140620191025.GA28324@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On 2014/6/21 3:10, Tejun Heo wrote:
> On Thu, Jun 12, 2014 at 02:32:13PM +0800, Li Zefan wrote:
>> @@ -1677,6 +1679,22 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
>>  		goto out_unlock;
>>  	}
>>  
>> +	/*
>> +	 * If some subsystems have been bound to existing cgroup hierarchies,
>> +	 * but those hierachies are being destroyed, let's wait a little bit
>> +	 * and retry.
>> +	 */
>> +	for_each_subsys(ss, i) {
>> +		if (!(opts.subsys_mask & (1 << i)))
>> +			continue;
>> +		if (!percpu_ref_alive(&ss->root->cgrp.self.refcnt)) {
> 
> Can't we just do tryget_live() instead and then put before retrying?
> It's not exactly a hot path and the operations are dirt cheap anyway.
> 

No much difference, though would be a bit more code. I can do that.
