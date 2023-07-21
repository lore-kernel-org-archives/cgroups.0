From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 08/17] drm/cgroup: Track DRM clients per
 cgroup
Date: Fri, 21 Jul 2023 12:14:49 -1000
Message-ID: <ZLsDWcwTL9aE0-5h@slm.duckdns.org>
References: <20230712114605.519432-1-tvrtko.ursulin@linux.intel.com>
 <20230712114605.519432-9-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=gmail.com; s=20221208; t=1689977692; x=1690582492;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
 :reply-to; bh=dXrwI0f7BDKHLGwATVJjnhmJ48tgd3+2nr9dmXSF18o=;
 b=r3cG7lOFcoYQwf+fNGpD139Z1Covyp+2lo5zJD5XnTAf8/K2pT9/dUBD2deat8FKKY
 npfSKBeTWt4RQmlwADclDm3Xd4QSNgj7U/QuvE7Vkq1WJcsnq0VH2IZGR/0WuWD7+4su
 kiKtRxjosdCNcaRgSFvEgYafPhLPyLWkrbkuBDotW3bpA9q1EiSVmA2iZ4tTSqwy+x1V
 KiHpqELnKXUa/gYZKJKU3S/5o+DJixx9URsj4dgQ1EG8f6aW6uYrKfS/sYl7EHM94Nbo
 9uTZv8JxLxGV3Og6f1YzX10gR7qDoVLgNvBQMuU3LzHEcL3qr43+/kFZWh+cmYCbyOpe
 7O6Q==
Content-Disposition: inline
In-Reply-To: <20230712114605.519432-9-tvrtko.ursulin@linux.intel.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Rob Clark <robdclark@chromium.org>, Kenny.Ho@amd.com, Dave Airlie <airlied@redhat.com>, =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu@chromium.org>, Daniel Vetter <daniel.vetter@ffwll.ch>, Intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, "T . J . Mercier" <tjmercier@google.com>

Hello,

On Wed, Jul 12, 2023 at 12:45:56PM +0100, Tvrtko Ursulin wrote:
> +void drmcgroup_client_migrate(struct drm_file *file_priv)
> +{
> +	struct drm_cgroup_state *src, *dst;
> +	struct cgroup_subsys_state *old;
> +
> +	mutex_lock(&drmcg_mutex);
> +
> +	old = file_priv->__css;
> +	src = css_to_drmcs(old);
> +	dst = css_to_drmcs(task_get_css(current, drm_cgrp_id));
> +
> +	if (src != dst) {
> +		file_priv->__css = &dst->css; /* Keeps the reference. */
> +		list_move_tail(&file_priv->clink, &dst->clients);
> +	}
> +
> +	mutex_unlock(&drmcg_mutex);
> +
> +	css_put(old);
> +}
> +EXPORT_SYMBOL_GPL(drmcgroup_client_migrate);

So, you're implicitly migrating the fd to the latest ioctl user on the first
access. While this may work for state-less control like usage time. This
likely will cause problem if you later want to add stateful control for
memory consumption. e.g. What happens if the new destination doesn't have
enough budget to accommodate the fd's usage? Let's say we allow over-commit
with follow-up reclaim or oom kill actions, if so, can we guarantee that all
memory ownership for can always be updated? If not, what happens after
failure?

If DRM needs to transfer fd ownership with resources attached to it, it
likely would be a good idea to make that an explicit operation so that the
attempt can be verified and failed if necessary.

Thanks.

-- 
tejun
