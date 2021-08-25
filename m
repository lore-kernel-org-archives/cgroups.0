From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Avoid memory migration when nodemasks
 match
Date: Wed, 25 Aug 2021 15:18:57 -0400
Message-ID: <b404f50a-6a35-92d5-1500-613296d0807f@redhat.com>
References: <20210825105415.1365360-1-nsaenzju@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629919141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SlFG0K25NAvNlMR4L6awyzjcPNxdeBB4rbGkjSKsifw=;
        b=IkvOdI95zMA25H8Y7fmPBMDDle1GIb2KbtvwZN75HyMqLhXg+Aa6LgnivteqGSGq6x2Ioz
        wI7apgFGLOe8vkIaDdnu2tK5o6Sy+XFsTauJvUe7hNo0Cbms2ll453Zd/3YcCZz0VooP95
        z4gVTVX+wst3BEG/mKPAxzBhQn2wGDE=
In-Reply-To: <20210825105415.1365360-1-nsaenzju-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Nicolas Saenz Julienne <nsaenzju-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On 8/25/21 6:54 AM, Nicolas Saenz Julienne wrote:
> With the introduction of ee9707e8593d ("cgroup/cpuset: Enable memory
> migration for cpuset v2") attaching a process to a different cgroup will
> trigger a memory migration regardless of whether it's really needed.
> Memory migration is an expensive operation, so bypass it if the
> nodemasks passed to cpuset_migrate_mm() are equal.
>
> Note that we're not only avoiding the migration work itself, but also a
> call to lru_cache_disable(), which triggers and flushes an LRU drain
> work on every online CPU.
>
> Signed-off-by: Nicolas Saenz Julienne <nsaenzju-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> ---
>
> NOTE: This also alleviates hangs I stumbled upon while testing
> linux-next on systems with nohz_full CPUs (running latency sensitive
> loads). ee9707e8593d's newly imposed memory migration never finishes, as
> the LRU drain is never scheduled on isolated CPUs.
>
> I tried to follow the user-space call trace, it's something like this:
>
>    Create new tmux pane, which triggers hostname operation, hangs...
>      -> systemd (pid 1) creates new hostnamed process (using clone())
>        -> hostnamed process attaches itself to:
>    	 "system.slice/systemd-hostnamed.service/cgroup.procs"
>          -> hangs... Waiting for LRU drain to finish on nohz_full CPUs.
>
> As far as CPU isolation is concerned, this calls for better
> understanding of the underlying issues. For example, should LRU be made
> CPU isolation aware or should we deal with it at cgroup/cpuset level? In
> the meantime, I figured this small optimization is worthwhile on its
> own.
>
>   kernel/cgroup/cpuset.c | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 44d234b0df5e..d497a65c4f04 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1634,6 +1634,11 @@ static void cpuset_migrate_mm(struct mm_struct *mm, const nodemask_t *from,
>   {
>   	struct cpuset_migrate_mm_work *mwork;
>   
> +	if (nodes_equal(*from, *to)) {
> +		mmput(mm);
> +		return;
> +	}
> +
>   	mwork = kzalloc(sizeof(*mwork), GFP_KERNEL);
>   	if (mwork) {
>   		mwork->mm = mm;

Thanks for the fix. So cpuset v1 with memory_migrate flag set will have 
the same problem then.

Acked-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Cheers,
Longman

