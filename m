Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4214A47B432
	for <cgroups@vger.kernel.org>; Fri,  5 Jun 2026 07:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780644926; cv=none; b=ldGcUpBYeAXNZRf2cqyos4G9ObHU3xm+dFYXqEfFwiFfEGoQwjHRmX3ZIUr1kva5C8GubL/ju/wm+/Ls7aSDhf106umBdB6CK2pJy8RDrNuWVmN9iZCUKj3qlOskvgSO1oC/Vk9CvOykYuH0iaP3MhWDlG6TUgG/3EZEMTBkikc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780644926; c=relaxed/simple;
	bh=YrTuSOVKhy+0zjIegpHr49FpMVaxvAWEkXD+5SPJea8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PtQaR0XFUCBvkISN1Q1p1DpSlOFKH7OMDSF9z46B2UCW3ZA21gq0BciGAhOLcBdwJQFelRoAoppmkw+VQ8l9fZ6HyKpFvGNb/54LyDRwdnoz+9hX57ZSBnz/JF8+0DKTtNmKY1fkocc82oY3o+vQAYXmAn96HLmxyjoJV8Ha00g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GhO6YyKO; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GhO6YyKO"
Message-ID: <d708fb7a-d12f-40da-95ca-fbc6d0552f07@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780644912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V/38TPRJSdaRiKmREGJMFYleBrRqrj4e5ZZcuBKWtdU=;
	b=GhO6YyKOZevwWrJCbmMTJVPXvT2bA3Eav/vhGW3N+R7zSw7ra1PUcaT/ow1XGmk/dJGviU
	2aqHO5CFFh5iubtoH0haZykLo2BiOLNVEUfhcGVhYinZ399bFRNV0/GWwNug3ImS6Aai2Y
	+B9I2NHXfW0P7vPYnHPCjREZ7ZYOSM0=
Date: Fri, 5 Jun 2026 15:35:01 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] cgroup/cpuset: Support multiple source/destination
 cpusets using pids pattern
To: Waiman Long <longman@redhat.com>
Cc: cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org
References: <20260602023203.248077-7-longman@redhat.com>
 <20260603102604.177503-1-ridong.chen@linux.dev>
 <07bfe9cc-b8ab-4c4c-bfe0-b974abd3ff08@redhat.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <07bfe9cc-b8ab-4c4c-bfe0-b974abd3ff08@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



On 6/4/2026 2:47 AM, Waiman Long wrote:
> On 6/3/26 6:26 AM, Ridong Chen wrote:
>> The current cpuset_can_attach() and cpuset_attach() functions assume task
>> migration is from one source cpuset to one destination cpuset. This
>> can be
>> wrong in several scenarios:
>>   - Moving a multi-threaded process with threads in different cpusets
>>   - Disabling the cpuset controller (many children to one parent)
>>   - Enabling the cpuset controller (one parent to many children)
>>
>> Fix this by adopting the pids subsystem's per-task accounting pattern.
>> In cpuset_can_attach(), use task_cs(task) to get the correct source
>> cpuset
>> for each task (like pids_can_attach uses task_css), adjust
>> nr_deadline_tasks
>> and reserve DL bandwidth per-task, and increment attach_in_progress
>> per-task
>> on the destination cpuset. In cpuset_attach(), handle destination cpuset
>> changes within the task iteration loop.
>>
>> A shared helper cpuset_undo_attach() reverses the per-task operations for
>> both partial rollback in cpuset_can_attach() and full reversal in
>> cpuset_cancel_attach().
>>
>> When multiple source cpusets are detected in can_attach(), set
>> attach_many_sources so that cpuset_attach() forces cpus_updated and
>> mems_updated to true, ensuring all tasks get properly updated regardless
>> of which source cpuset cpuset_attach_old_cs points to.
>>
>> This eliminates the need for nr_migrate_dl_tasks, sum_migrate_dl_bw, and
>> dl_bw_cpu fields in struct cpuset.
>>
>> Fixes: 4ec22e9c5a90 ("cpuset: Enable cpuset controller in default
>> hierarchy")
>> Signed-off-by: Ridong Chen <ridong.chen@linux.dev>
> 
> It is not a problem doing per-task DL BW allocation and eliminating the
> *dl_bw* fields. However, updating nr_deadline_tasks before it is
> committed can be problematic.
> 

Good to hear that.

> nr_deadline_tasks is used in dl_rebuild_rd_accounting() which is called
> by partition_sched_domains_locked(). After the release of cpuset_mutex
> at the end of cpuset_can_attach() and before cpuset_attach() or
> cpuset_cancel_attach() is called, it is possible
> that partition_sched_domains_locked() can be called
> and dl_rebuild_rd_accounting() is not getting the right DL BW accounting
> information. So unless there is a way to confirm that this situation
> cannot happen, we can't change nr_deadline_tasks before the attach is
> commited.
> 

We can keep the nr_migrate_dl_tasks field and update nr_deadline_tasks
once migration is complete. I think this will be much simpler than
fixing the issue using lists.

-- 
Best regards,
Ridong

