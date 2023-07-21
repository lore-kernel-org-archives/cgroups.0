From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 12/17] cgroup/drm: Introduce weight based
 drm cgroup control
Date: Fri, 21 Jul 2023 12:17:53 -1000
Message-ID: <ZLsEEYDFlJZwrJiV@slm.duckdns.org>
References: <20230712114605.519432-1-tvrtko.ursulin@linux.intel.com>
 <20230712114605.519432-13-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=gmail.com; s=20221208; t=1689977875; x=1690582675;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
 :reply-to; bh=Cjm6i6VGWK46ksrSf/WO54+zzsF5ULR5YF0/kPA+stI=;
 b=sIusdMkhzyYYzt7HTZ12ouC1zo0sibV8H/PYeYkaLxSBDEhc0NmcBhK/VXQFLOMD8W
 yS7JEFFOviSYIfM0AUhzG9IhwX1q9peWhyLEwZo1fi1Ei5S7h1BqDE1g6Of2+nZ7PTpx
 Q+UOBogLu+QuJl125anoYUSX9LRIuAPBV+8p+ObtmgkGeVXFhpawz5krJvA98tTOB6Ra
 lnn6h/GpqJu3CRz4orpNv/dF77t7/T6j5np29gkpvd7deyLug5Qg9GNsgFdanYl8stF4
 TYc5U1LqMLuLF3QdZikaEvERFBL7v8REuiNxCz5F8AxJJI9Sl1vfdhCDfmupGEmdv0d9
 iQvQ==
Content-Disposition: inline
In-Reply-To: <20230712114605.519432-13-tvrtko.ursulin@linux.intel.com>
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
Cc: Rob Clark <robdclark@chromium.org>, Kenny.Ho@amd.com, Dave Airlie <airlied@redhat.com>, =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu@chromium.org>, Daniel Vetter <daniel.vetter@ffwll.ch>, Intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, "T . J . Mercier" <tjmercier@google.com>

On Wed, Jul 12, 2023 at 12:46:00PM +0100, Tvrtko Ursulin wrote:
> +DRM scheduling soft limits
> +~~~~~~~~~~~~~~~~~~~~~~~~~~

Please don't say soft limits for this. It means something different for
memcg, so it gets really confusing. Call it "weight based CPU time control"
and maybe call the triggering points as thresholds.

Thanks.

-- 
tejun
