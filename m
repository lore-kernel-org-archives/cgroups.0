From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH] io_uring/io-wq: stop setting PF_NO_SETAFFINITY on io-wq
 workers
Date: Tue, 14 Mar 2023 14:17:22 -0400
Message-ID: <05c48a47-cfb2-af73-6709-f622fd254f89@redhat.com>
References: <0f0e791b-8eb8-fbb2-ea94-837645037fae@kernel.dk>
 <CA+wXwBRGzfZB9tjKy5C2_pW1Z4yH2gNGxx79Fk-p3UsOWKGdqA@mail.gmail.com>
 <20230314162559.pnyxdllzgw7jozgx@blackpad>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <io-uring-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678817847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d/ZtBwgB7cTsUBrCI6syMahmMU7UxQQ3MRmKHMli2aQ=;
        b=VqWC+wAwSXOoHwA0u0Yf260o+QNdz9PNF9+/v1BxK9rI8kl58naPgxAFbuplc9bBpYdoMw
        m4Y84YVnp7a/DAIc22mfeLQOPVGYH9wnEb7a8m6EFF3IV0I1PlhlZ0mhN91lAnan4A5Arv
        73SC0dLUqsFvhCl/Cv9ElqW8ebxYovI=
Content-Language: en-US
In-Reply-To: <20230314162559.pnyxdllzgw7jozgx@blackpad>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Daniel Dao <dqminh@cloudflare.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>, cgroups@vger.kernel.org

On 3/14/23 12:25, Michal Koutný wrote:
> Hello.
>
> On Tue, Mar 14, 2023 at 10:07:40AM +0000, Daniel Dao <dqminh@cloudflare.com> wrote:
>> IMO this violated the principle of cpuset and can be confusing for end users.
>> I think I prefer Waiman's suggestion of allowing an implicit move to cpuset
>> when enabling cpuset with subtree_control but not explicit moves such as when
>> setting cpuset.cpus or writing the pids into cgroup.procs. It's easier to reason
>> about and make the failure mode more explicit.
>>
>> What do you think ?
> I think cpuset should top IO worker's affinity (like sched_setaffinity(2)).
> Thus:
> - modifying cpuset.cpus	                update task's affinity, for sure
> - implicit migration (enabling cpuset)  update task's affinity, effective nop
Note that since commit 7fd4da9c158 ("cgroup/cpuset: Optimize 
cpuset_attach() on v2") in v6.2, implicit migration (enabling cpuset) 
will not affect the cpu affinity of the process.
> - explicit migration (meh)              update task's affinity, ¯\_(ツ)_/¯
>
> My understanding of PF_NO_SETAFFINITY is that's for kernel threads that
> do work that's functionally needed on a given CPU and thus they cannot
> be migrated [1]. As said previously for io_uring workers, affinity is
> for performance only.
>
> Hence, I'd also suggest on top of 01e68ce08a30 ("io_uring/io-wq: stop
> setting PF_NO_SETAFFINITY on io-wq workers"):
>
> --- a/io_uring/sqpoll.c
> +++ b/io_uring/sqpoll.c
> @@ -233,7 +233,6 @@ static int io_sq_thread(void *data)
>                  set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
>          else
>                  set_cpus_allowed_ptr(current, cpu_online_mask);
> -       current->flags |= PF_NO_SETAFFINITY;
>
>          mutex_lock(&sqd->lock);
>          while (1) {
>
> Afterall, io_uring_setup(2) already mentions:
>> When cgroup setting cpuset.cpus changes (typically in container
>> environment), the bounded cpu set may be changed as well.

Using sched_setaffiinity(2) can be another alternative. Starting from 
v6.2, cpu affinity set by sched_affiinity(2) will be more or less 
maintained and constrained by the current cpuset even if the cpu list is 
being changed as long as there is overlap between the two. The 
intersection between cpu affinity set by sched_setaffinity(2) and the 
effective_cpus in cpuset will be the effective cpu affinity of the task.

Cheers,
Longman

