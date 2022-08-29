From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cgroups v2 cpuset partition bug
Date: Mon, 29 Aug 2022 11:24:46 -0400
Message-ID: <ef183fe9-8458-8a7f-2b8e-1c38666b6399@redhat.com>
References: <C98773C9-F5ED-4664-BED1-5C03351130D4@gmail.com>
 <YwT/BNqIdCEyUpFR@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661786689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r8Pa70Jwmk85yjbhdC2p9Q8zUFSafHf+XccH6FABnLg=;
        b=RBVijxX1E1rOp8BcIYuE8ozNhmHEIHAA0Jdr3TSqeVuxR2fXLnevE4//m36hLMKgqzw1fD
        CRC8xc9u9kfAw+yH5iejHc9zJtIdMlgjFhKtSQxFTbIg6jH7WkLPE7wpHvh78RoZQ3YRe9
        Fgnln2LFVAUKKmMl+jUqmU4B1i6UeCw=
Content-Language: en-US
In-Reply-To: <YwT/BNqIdCEyUpFR-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?B?TWF4aW0g4oCcTUFYUEFJTuKAnSBNYWth?= =?UTF-8?Q?rov?= <maxpain177-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 8/23/22 12:23, Tejun Heo wrote:
> (cc'ing Waiman for visibilty)
>
> On Tue, Aug 23, 2022 at 03:13:30PM +0300, Maxim “MAXPAIN” Makarov wrote:
>> Hello. I have no idea where I can ask questions about cgroups v2. I have a problem with cpuset partitions.
>> Could you please, check this question?
>> https://unix.stackexchange.com/questions/714454/cgroups-v2-cpuset-doesnt-take-an-effect-without-process-restart

When a partition is created, the cpuset code will update the cpu 
affinity of the tasks in the parent cpuset using update_tasks_cpumask(). 
This function will set the new cpu affinity for those tasks and move it 
over to the new cpus. However, if the tasks aren't running at the time, 
the move may be delayed until those tasks are waken up. The fact the 
task affinity is correct means that the cpuset code has done the right 
thing.

I am not sure what tool do you use to check the task's cpus. I believe 
the tool may show what cpu the task is previously running on. It does 
not means the the task will run on that cpu when it is waken up. It is 
only a bug if the task is running and it is on the wrong cpu.

Cheers,
Longman

