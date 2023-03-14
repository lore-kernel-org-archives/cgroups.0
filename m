From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] io_uring/io-wq: stop setting PF_NO_SETAFFINITY on io-wq
 workers
Date: Tue, 14 Mar 2023 10:48:24 -0600
Message-ID: <bd6e61c2-dd84-d2b1-9f8c-45965e4e9b9d@kernel.dk>
References: <0f0e791b-8eb8-fbb2-ea94-837645037fae@kernel.dk>
 <CA+wXwBRGzfZB9tjKy5C2_pW1Z4yH2gNGxx79Fk-p3UsOWKGdqA@mail.gmail.com>
 <20230314162559.pnyxdllzgw7jozgx@blackpad>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <io-uring-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678812505; x=1681404505;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KRCCNgT6mDknip32bvmWUWGEG4KETFKEmttZaBdi8MM=;
        b=LOz7NxUwKuACzrD2UXTSI8Mzf5QqdSfHNMdwwSLOSzlC9IA9PtDjKjeu2jKfd78rot
         o/H6ZLTH0Nln2ah+mphMnNsNavYccAvh99KvwoTXg1+cWVtvasdDvngXIfZ4TX8j4PX2
         P+NDwSDsssRMsUFynbewyf8U4JSaGXUO+AiJwGQEP1+gFtszFc6vYaWtjknUAwW3mcPC
         qXtReGZl5/0TbuPsG1QBlgC1qJrWSN9nsaWWYBqLsxVdMGNCkCAhKA5n7kkNGfj3crFt
         AA1jA+qfy8kZEbgGDWgBOyt+8+F4P/trUuSxbKD7QqJL9pPiax0M1/9URLM5OGFguFhQ
         C9sg==
Content-Language: en-US
In-Reply-To: <20230314162559.pnyxdllzgw7jozgx@blackpad>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Daniel Dao <dqminh@cloudflare.com>
Cc: io-uring <io-uring@vger.kernel.org>, Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org

On 3/14/23 10:25 AM, Michal Koutný wrote:
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
> 
> I think cpuset should top IO worker's affinity (like sched_setaffinity(2)).
> Thus:
> - modifying cpuset.cpus	                update task's affinity, for sure
> - implicit migration (enabling cpuset)  update task's affinity, effective nop
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
>                 set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
>         else
>                 set_cpus_allowed_ptr(current, cpu_online_mask);
> -       current->flags |= PF_NO_SETAFFINITY;
> 
>         mutex_lock(&sqd->lock);
>         while (1) {

Ah yes, let's get that done as well in the same release. Do you want
to send a patch for this?

-- 
Jens Axboe


