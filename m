From: =?UTF-8?Q?Thomas_Hellstr=c3=b6m?= <thomas.hellstrom@linux.intel.com>
Subject: Re: [Intel-xe] [RFC PATCH 3/4] drm/ttm: Handle -EAGAIN
 in ttm_resource_alloc as -ENOSPC.
Date: Wed, 3 May 2023 11:11:32 +0200
Message-ID: <888841c4-7bd4-8174-7786-033715c995c6@linux.intel.com>
References: <20230503083500.645848-1-maarten.lankhorst@linux.intel.com>
 <20230503083500.645848-4-maarten.lankhorst@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1683105101; x=1714641101;
 h=message-id:date:mime-version:subject:to:cc:references:
 from:in-reply-to:content-transfer-encoding;
 bh=yZdDxF7eM2/0DaJdrpLaz+vSoS07hfHOMx2AFF1OeTM=;
 b=ZlxfqmhP0GtMqNps8JIe86VXSChnecBASJBRT3GqdYvqhyt3l9UZIEaT
 7CeKI7BYZn8r3xQpZuQaJEJuvN7Myj2J96SjWcXjinpwBz5uqeDHgvOpP
 wxV9Up3o9bH3sxZnpQpVoi4hQqQ+vlCU5PJ+pT0Mc+VxbnkSlj5o4l6GX
 cBhNDdHc7ROhG5eoeMs99EIZKXV4VuWgQxYg7wBBX9FpQH4m88roiPFdv
 HDDElvg3hIKx7XofGIgotHHnJiDsjkJiiE/2jHhq++wQY7kUAetfj55D/
 UlcTcEWTFrYzOz7NJgd8pQEz72A5+TZAJ3n5QwYbuXkqpKRflSHz4F4Yr Q==;
Content-Language: en-US
In-Reply-To: <20230503083500.645848-4-maarten.lankhorst@linux.intel.com>
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
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, dri-devel@lists.freedesktop.org, cgroups@vger.kernel.org, intel-xe@lists.freedesktop.org
Cc: Daniel Vetter <daniel@ffwll.ch>, Zefan Li <lizefan.x@bytedance.com>, intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org, Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, David Airlie <airlied@gmail.com>

Hi, Maarten

On 5/3/23 10:34, Maarten Lankhorst wrote:
> This allows the drm cgroup controller to return no space is available..
>
> XXX: This is a hopeless simplification that changes behavior, and
> returns -ENOSPC even if we could evict ourselves from the current
> cgroup.
>
> Ideally, the eviction code becomes cgroup aware, and will force eviction
> from the current cgroup or its parents.
>
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>

Thinking of the shrinker analogy, do non-cgroup aware shrinkers just 
shrink blindly or do they reject shrinking like this patch when a cgroup 
limit is reached?

/Thomas


> ---
>   drivers/gpu/drm/ttm/ttm_bo.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
> index bd5dae4d1624..e057d5d8f09a 100644
> --- a/drivers/gpu/drm/ttm/ttm_bo.c
> +++ b/drivers/gpu/drm/ttm/ttm_bo.c
> @@ -731,6 +731,8 @@ static int ttm_bo_mem_force_space(struct ttm_buffer_object *bo,
>   		ret = ttm_resource_alloc(bo, place, mem);
>   		if (likely(!ret))
>   			break;
> +		if (ret == -EAGAIN)
> +			return -ENOSPC;
>   		if (unlikely(ret != -ENOSPC))
>   			return ret;
>   		ret = ttm_mem_evict_first(bdev, man, place, ctx,
> @@ -783,7 +785,7 @@ int ttm_bo_mem_space(struct ttm_buffer_object *bo,
>   
>   		type_found = true;
>   		ret = ttm_resource_alloc(bo, place, mem);
> -		if (ret == -ENOSPC)
> +		if (ret == -ENOSPC || ret == -EAGAIN)
>   			continue;
>   		if (unlikely(ret))
>   			goto error;
