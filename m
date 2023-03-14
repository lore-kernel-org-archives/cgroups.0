From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Subject: Re: [RFC 01/10] drm: Track clients by tgid and not tid
Date: Tue, 14 Mar 2023 16:33:03 +0100
Message-ID: <2d4c10c7-6406-7458-4f52-4260b415874e@amd.com>
References: <20230314141904.1210824-1-tvrtko.ursulin@linux.intel.com>
 <20230314141904.1210824-2-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1; 
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=td0zIlqL7ArQhsgOdbcIqzBidI++4ILPzBAytnV8TOc=;
 b=1z0i0oNUdcPVdbFO4PArgcVLHe/nF7S6UDpx/WPfuy/s5mkKqNSj7Yw0HuGXetXtBLS8ub6ashw1YY4bthpW17uipnSQ8lRBEqByk1fNuNRhrVJDhU3z+ISd4hLJ84TZlNgSSkLFSRyHkglh6DB36VSwhEdmeM3ExNEJUgjyPeo=
Content-Language: en-US
In-Reply-To: <20230314141904.1210824-2-tvrtko.ursulin@linux.intel.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>, Intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Cc: Rob Clark <robdclark@chromium.org>, Kenny.Ho@amd.com, Daniel Vetter <daniel.vetter@ffwll.ch>, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, =?UTF-8?Q?St=c3=a9phane_Marchesin?= <marcheu@chromium.org>, Alex Deucher <alexander.deucher@amd.com>, linux-graphics-maintainer@vmware.com, Zefan Li <lizefan.x@bytedance.com>, Dave Airlie <airlied@redhat.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, "T . J . Mercier" <tjmercier@google.com>, Zack Rusin <zackr@vmware.com>

Am 14.03.23 um 15:18 schrieb Tvrtko Ursulin:
> From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
>
> Thread group id (aka pid from userspace point of view) is a more
> interesting thing to show as an owner of a DRM fd, so track and show that
> instead of the thread id.
>
> In the next patch we will make the owner updated post file descriptor
> handover, which will also be tgid based to avoid ping-pong when multiple
> threads access the fd.
>
> Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: Zack Rusin <zackr@vmware.com>
> Cc: linux-graphics-maintainer@vmware.com
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: "Christian König" <christian.koenig@amd.com>
> Reviewed-by: Zack Rusin <zackr@vmware.com>

Reviewed-by: Christian König <christian.koenig@amd.com>

Should we push the already reviewed cleanups like this one to 
drm-misc-next? That makes sense even without the rest of the 
functionality and reduce the amount of patches re-send.

Christian.

> ---
>   drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c | 2 +-
>   drivers/gpu/drm/drm_debugfs.c           | 4 ++--
>   drivers/gpu/drm/drm_file.c              | 2 +-
>   drivers/gpu/drm/vmwgfx/vmwgfx_gem.c     | 2 +-
>   4 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
> index d8e683688daa..863cb668e000 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
> @@ -969,7 +969,7 @@ static int amdgpu_debugfs_gem_info_show(struct seq_file *m, void *unused)
>   		 * Therefore, we need to protect this ->comm access using RCU.
>   		 */
>   		rcu_read_lock();
> -		task = pid_task(file->pid, PIDTYPE_PID);
> +		task = pid_task(file->pid, PIDTYPE_TGID);
>   		seq_printf(m, "pid %8d command %s:\n", pid_nr(file->pid),
>   			   task ? task->comm : "<unknown>");
>   		rcu_read_unlock();
> diff --git a/drivers/gpu/drm/drm_debugfs.c b/drivers/gpu/drm/drm_debugfs.c
> index 4f643a490dc3..4855230ba2c6 100644
> --- a/drivers/gpu/drm/drm_debugfs.c
> +++ b/drivers/gpu/drm/drm_debugfs.c
> @@ -80,7 +80,7 @@ static int drm_clients_info(struct seq_file *m, void *data)
>   	seq_printf(m,
>   		   "%20s %5s %3s master a %5s %10s\n",
>   		   "command",
> -		   "pid",
> +		   "tgid",
>   		   "dev",
>   		   "uid",
>   		   "magic");
> @@ -94,7 +94,7 @@ static int drm_clients_info(struct seq_file *m, void *data)
>   		bool is_current_master = drm_is_current_master(priv);
>   
>   		rcu_read_lock(); /* locks pid_task()->comm */
> -		task = pid_task(priv->pid, PIDTYPE_PID);
> +		task = pid_task(priv->pid, PIDTYPE_TGID);
>   		uid = task ? __task_cred(task)->euid : GLOBAL_ROOT_UID;
>   		seq_printf(m, "%20s %5d %3d   %c    %c %5d %10u\n",
>   			   task ? task->comm : "<unknown>",
> diff --git a/drivers/gpu/drm/drm_file.c b/drivers/gpu/drm/drm_file.c
> index a51ff8cee049..c1018c470047 100644
> --- a/drivers/gpu/drm/drm_file.c
> +++ b/drivers/gpu/drm/drm_file.c
> @@ -156,7 +156,7 @@ struct drm_file *drm_file_alloc(struct drm_minor *minor)
>   	if (!file)
>   		return ERR_PTR(-ENOMEM);
>   
> -	file->pid = get_pid(task_pid(current));
> +	file->pid = get_pid(task_tgid(current));
>   	file->minor = minor;
>   
>   	/* for compatibility root is always authenticated */
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c b/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
> index d6baf73a6458..c0da89e16e6f 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
> @@ -241,7 +241,7 @@ static int vmw_debugfs_gem_info_show(struct seq_file *m, void *unused)
>   		 * Therefore, we need to protect this ->comm access using RCU.
>   		 */
>   		rcu_read_lock();
> -		task = pid_task(file->pid, PIDTYPE_PID);
> +		task = pid_task(file->pid, PIDTYPE_TGID);
>   		seq_printf(m, "pid %8d command %s:\n", pid_nr(file->pid),
>   			   task ? task->comm : "<unknown>");
>   		rcu_read_unlock();

