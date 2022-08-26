From: Mukesh Ojha <quic_mojha-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] cgroup: Use cgroup_attach_{lock,unlock}() from
 cgroup_attach_task_all()
Date: Fri, 26 Aug 2022 11:22:21 +0530
Message-ID: <eb00aa4f-3ddf-58bb-6861-216c53ace4ae@quicinc.com>
References: <5ea67858-cda6-bf8d-565e-d793b608e93c@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=x8RAlz8VkjWw+gib2D59wTgdxtCaBT02JCU19dyRvE0=;
 b=nK5qD9k/1yqqYvOU7U1HDFIlC3k3/FFA4Hy6APcWhO8Zpwf7pRuwcT5hWWpsyVqx9T+X
 5ZJ+s3cGWZ04TiTK1s6EEoAwf0peTowK/Jc3YExnFNEcS9NHckQ+FtYMSaEWw1Xc9rVR
 0bbVnZRCO4bXpdqbTabue9ckj3OFNhA3J/guxaibfQlGxmUHL1qZN2I+UvAeV/mu8+Ec
 /kR+k7nbwSv7f6Hkb+/zFZ/sojn448qJmIt11l9xsaeGGOSaAa9qbYjZyWuxZaUhmYzw
 3LVX3ASSE0HWmBqr1ay69pL5fJvZlsjs3i9rOiMzX1EYyGbzU/xO4MCR8XlQk7MCiqT2 VQ== 
Content-Language: en-US
In-Reply-To: <5ea67858-cda6-bf8d-565e-d793b608e93c-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

On 8/26/2022 8:18 AM, Tetsuo Handa wrote:
> No behavior changes; preparing for potential locking changes in future.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
> ---
>   kernel/cgroup/cgroup-internal.h | 2 ++
>   kernel/cgroup/cgroup-v1.c       | 6 ++----
>   kernel/cgroup/cgroup.c          | 4 ++--
>   3 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
> index 36b740cb3d59..2c7ecca226be 100644
> --- a/kernel/cgroup/cgroup-internal.h
> +++ b/kernel/cgroup/cgroup-internal.h
> @@ -250,6 +250,8 @@ int cgroup_migrate(struct task_struct *leader, bool threadgroup,
>   
>   int cgroup_attach_task(struct cgroup *dst_cgrp, struct task_struct *leader,
>   		       bool threadgroup);
> +void cgroup_attach_lock(bool lock_threadgroup);
> +void cgroup_attach_unlock(bool lock_threadgroup);
>   struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup,
>   					     bool *locked)
>   	__acquires(&cgroup_threadgroup_rwsem);
> diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
> index ff6a8099eb2a..52bb5a74a23b 100644
> --- a/kernel/cgroup/cgroup-v1.c
> +++ b/kernel/cgroup/cgroup-v1.c
> @@ -59,8 +59,7 @@ int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
>   	int retval = 0;
>   
>   	mutex_lock(&cgroup_mutex);
> -	cpus_read_lock();
> -	percpu_down_write(&cgroup_threadgroup_rwsem);
> +	cgroup_attach_lock(true);
>   	for_each_root(root) {
>   		struct cgroup *from_cgrp;
>   
> @@ -72,8 +71,7 @@ int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
>   		if (retval)
>   			break;
>   	}
> -	percpu_up_write(&cgroup_threadgroup_rwsem);
> -	cpus_read_unlock();
> +	cgroup_attach_unlock(true);
>   	mutex_unlock(&cgroup_mutex);
>   
>   	return retval;
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index e4bb5d57f4d1..5aee34bcf003 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -2393,7 +2393,7 @@ EXPORT_SYMBOL_GPL(task_cgroup_path);
>    * write-locking cgroup_threadgroup_rwsem. This allows ->attach() to assume that
>    * CPU hotplug is disabled on entry.
>    */
> -static void cgroup_attach_lock(bool lock_threadgroup)
> +void cgroup_attach_lock(bool lock_threadgroup)
>   {
>   	cpus_read_lock();
>   	if (lock_threadgroup)
> @@ -2404,7 +2404,7 @@ static void cgroup_attach_lock(bool lock_threadgroup)
>    * cgroup_attach_unlock - Undo cgroup_attach_lock()
>    * @lock_threadgroup: whether to up_write cgroup_threadgroup_rwsem
>    */
> -static void cgroup_attach_unlock(bool lock_threadgroup)
> +void cgroup_attach_unlock(bool lock_threadgroup)
>   {
>   	if (lock_threadgroup)
>   		percpu_up_write(&cgroup_threadgroup_rwsem);

LGTM.

Reviewed-by:Mukesh Ojha <quic_mojha-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>

-Mukesh
