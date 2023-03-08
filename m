From: Waiman Long <longman@redhat.com>
Subject: Re: Unexpected EINVAL when enabling cpuset in subtree_control when
 io_uring threads are running
Date: Wed, 8 Mar 2023 09:20:09 -0500
Message-ID: <c069bcff-8229-4284-b973-e427ccf20b64@redhat.com>
References: <CA+wXwBQwgxB3_UphSny-yAP5b26meeOu1W4TwYVcD_+5gOhvPw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <io-uring-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678285212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sops4x68iLJ61ANNFLgKRCF7RTvxeEpyHCZSHbGz/Ks=;
        b=VMqr8644yFH+kx5srnMvFXz+V3j1fHAt3fCEHsQLG1pDmNbufrLqxorhubfNbzkzBo7491
        UtubdnqlU/H0I/JwqEKSSp7XjEZ0PFm1xf/Vsi7DtfAtj8RGs9s516hlqIvPKKEQyTzhvI
        9cNqA8OPolFHXYxmuv8Z2GFmnzy0VQQ=
Content-Language: en-US
In-Reply-To: <CA+wXwBQwgxB3_UphSny-yAP5b26meeOu1W4TwYVcD_+5gOhvPw@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Daniel Dao <dqminh@cloudflare.com>, Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@cloudflare.com>

On 3/8/23 06:42, Daniel Dao wrote:
> Hi all,
>
> We encountered EINVAL when enabling cpuset in cgroupv2 when io_uring
> worker threads are running. Here are the steps to reproduce the failure
> on kernel 6.1.14:
>
> 1. Remove cpuset from subtree_control
>
>    > for d in $(find /sys/fs/cgroup/ -maxdepth 1 -type d); do echo
> '-cpuset' | sudo tee -a $d/cgroup.subtree_control; done
>    > cat /sys/fs/cgroup/cgroup.subtree_control
>    cpu io memory pids
>
> 2. Run any applications that utilize the uring worker thread pool. I used
>     https://github.com/cloudflare/cloudflare-blog/tree/master/2022-02-io_uring-worker-pool
>
>    > cargo run -- -a -w 2 -t 2
>
> 3. Enabling cpuset will return EINVAL
>
>    > echo '+cpuset' | sudo tee -a /sys/fs/cgroup/cgroup.subtree_control
>    +cpuset
>    tee: /sys/fs/cgroup/cgroup.subtree_control: Invalid argument
>
> We traced this down to task_can_attach that will return EINVAL when it
> encounters
> kthreads with PF_NO_SETAFFINITY, which io_uring worker threads have.
>
> This seems like an unexpected interaction when enabling cpuset for the subtrees
> that contain kthreads. We are currently considering a workaround to try to
> enable cpuset in root subtree_control before any io_uring applications
> can start,
> hence failure to enable cpuset is localized to only cgroup with
> io_uring kthreads.
> But this is cumbersome.
>
> Any suggestions would be very much appreciated.

Anytime you echo "+cpuset" to cgroup.subtree_control to enable cpuset, 
the tasks within the child cgroups will do an implicit move from the 
parent cpuset to the child cpusets. However, that move will fail if any 
task has the PF_NO_SETAFFINITY flag set due to task_can_attach() 
function which checks for this. One possible solution is for the cpuset 
to ignore tasks with PF_NO_SETAFFINITY set for implicit move. IOW, 
allowing the implicit move without touching it, but not explicit one 
using cgroup.procs.

Cheers,
Longman

