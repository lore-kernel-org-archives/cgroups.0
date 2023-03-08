From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: Unexpected EINVAL when enabling cpuset in subtree_control when
 io_uring threads are running
Date: Wed, 8 Mar 2023 07:26:46 -0700
Message-ID: <074823f4-993c-8caf-bd93-70589c4aae42@kernel.dk>
References: <CA+wXwBQwgxB3_UphSny-yAP5b26meeOu1W4TwYVcD_+5gOhvPw@mail.gmail.com>
 <c069bcff-8229-4284-b973-e427ccf20b64@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678285613;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6DzypvQ9Ir4BceedTjh7GQOOsJgVNAfYu10w2CD9pqk=;
        b=Pyf8V3e9hyJO+g4hHyoq1KA7bcPTty4SEJ3OnQ+9kxx1oE+MLTkxL8BS4TVXPGP+Jh
         eSssiNkJcdGMAvHAXux9Z87TAAvJPn7jBSktnB+ZFuoV3b6gmKwv7Fa9M4ijdTc1wSwP
         e3+dUriachwEZC5RKofoob0sqIqscgphpU/aOPwXpJWhfN4foCyLq37qQrxzPL9lyOEt
         i/YsqAyJ7GsQY0UlLHuusw6mVCQ+FDm6jmxapNjrckmdfc2J1KVe+D2IlDMMY9SI3ITL
         a4nwEHIphc6f0gK8rpsylMJpJrhaT4g0Ywy5J4KvLR+P5SRrQ8uz5royHE/q6pxnlbXJ
         nCHQ==
Content-Language: en-US
In-Reply-To: <c069bcff-8229-4284-b973-e427ccf20b64-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Dao <dqminh-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
Cc: io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>

On 3/8/23 7:20?AM, Waiman Long wrote:
> On 3/8/23 06:42, Daniel Dao wrote:
>> Hi all,
>>
>> We encountered EINVAL when enabling cpuset in cgroupv2 when io_uring
>> worker threads are running. Here are the steps to reproduce the failure
>> on kernel 6.1.14:
>>
>> 1. Remove cpuset from subtree_control
>>
>>    > for d in $(find /sys/fs/cgroup/ -maxdepth 1 -type d); do echo
>> '-cpuset' | sudo tee -a $d/cgroup.subtree_control; done
>>    > cat /sys/fs/cgroup/cgroup.subtree_control
>>    cpu io memory pids
>>
>> 2. Run any applications that utilize the uring worker thread pool. I used
>>     https://github.com/cloudflare/cloudflare-blog/tree/master/2022-02-io_uring-worker-pool
>>
>>    > cargo run -- -a -w 2 -t 2
>>
>> 3. Enabling cpuset will return EINVAL
>>
>>    > echo '+cpuset' | sudo tee -a /sys/fs/cgroup/cgroup.subtree_control
>>    +cpuset
>>    tee: /sys/fs/cgroup/cgroup.subtree_control: Invalid argument
>>
>> We traced this down to task_can_attach that will return EINVAL when it
>> encounters
>> kthreads with PF_NO_SETAFFINITY, which io_uring worker threads have.
>>
>> This seems like an unexpected interaction when enabling cpuset for the subtrees
>> that contain kthreads. We are currently considering a workaround to try to
>> enable cpuset in root subtree_control before any io_uring applications
>> can start,
>> hence failure to enable cpuset is localized to only cgroup with
>> io_uring kthreads.
>> But this is cumbersome.
>>
>> Any suggestions would be very much appreciated.
> 
> Anytime you echo "+cpuset" to cgroup.subtree_control to enable cpuset,
> the tasks within the child cgroups will do an implicit move from the
> parent cpuset to the child cpusets. However, that move will fail if
> any task has the PF_NO_SETAFFINITY flag set due to task_can_attach()
> function which checks for this. One possible solution is for the
> cpuset to ignore tasks with PF_NO_SETAFFINITY set for implicit move.
> IOW, allowing the implicit move without touching it, but not explicit
> one using cgroup.procs.

I was pondering this too as I was typing my reply, but at least for
io-wq, this report isn't the first to be puzzled or broken by the fact
that task threads might have PF_NO_SETAFFINITY set. So while it might be
worthwhile to for cpuset to ignore PF_NO_SETAFFINITY as a separate fix,
I think it's better to fix io-wq in general. Not sure we have other
cases where it's even possible to have PF_NO_SETAFFINITY set on
userspace threads?

-- 
Jens Axboe

