From: "T.J. Mercier" <tjmercier@google.com>
Subject: Re: [RFC v5 00/17] DRM cgroup controller with
 scheduling control and memory stats
Date: Wed, 19 Jul 2023 13:31:54 -0700
Message-ID: <CABdmKX1PUF+X897ZMOr0RNiYdoiL_2NkcSt+Eh55BfW-05LopQ@mail.gmail.com>
References: <20230712114605.519432-1-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=google.com; s=20221208; t=1689798726; x=1692390726;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:from:to:cc:subject:date
 :message-id:reply-to;
 bh=hVa5fBSVAdHHhZFj/pRkL4ALpTE995mDIMsnkkRTm0Q=;
 b=Lde5n1cKOA1T4bKffkRp7OCLFw3kIzNszFORWjdILVZqUjkjtj/r9hJnWetWPtfHma
 ljuFtQpXVY4jecYQAp9auj6671m4eJtWAWASvcxJ0vh6TBOL3L3JPhny0qmlkfIO9s+W
 8B9dU1kPuZnzPVLrgJf4wHRzdb2yDbMwGZLSaAOSX8ifu+zNVAZ4k00aAjhvtL71UYFE
 zBzIW5qzWajLb4R1YlKHx0jzIA1FhXb9NOCMhsidexUSwl+9zzaHMeWSsIwt4d/UKdn3
 ou8P9mOiEJewUTZVMKvwVKWKgZcn3ZknSYuePQSkjSIgj6WoH4BvzHG+o4ET6ZkJEN1+
 idEw==
In-Reply-To: <20230712114605.519432-1-tvrtko.ursulin@linux.intel.com>
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
Content-Type: text/plain; charset="windows-1252"
To: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Rob Clark <robdclark@chromium.org>, Kenny.Ho@amd.com, Dave Airlie <airlied@redhat.com>, =?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu@chromium.org>, Daniel Vetter <daniel.vetter@ffwll.ch>, Intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, Eero Tamminen <eero.t.tamminen@intel.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>

On Wed, Jul 12, 2023 at 4:47=E2=80=AFAM Tvrtko Ursulin
<tvrtko.ursulin@linux.intel.com> wrote:
>
>   drm.memory.stat
>         A nested file containing cumulative memory statistics for the who=
le
>         sub-hierarchy, broken down into separate GPUs and separate memory
>         regions supported by the latter.
>
>         For example::
>
>           $ cat drm.memory.stat
>           card0 region=3Dsystem total=3D12898304 shared=3D0 active=3D0 re=
sident=3D12111872 purgeable=3D167936
>           card0 region=3Dstolen-system total=3D0 shared=3D0 active=3D0 re=
sident=3D0 purgeable=3D0
>
>         Card designation corresponds to the DRM device names and multiple=
 line
>         entries can be present per card.
>
>         Memory region names should be expected to be driver specific with=
 the
>         exception of 'system' which is standardised and applicable for GP=
Us
>         which can operate on system memory buffers.
>
>         Sub-keys 'resident' and 'purgeable' are optional.
>
>         Per category region usage is reported in bytes.
>
>  * Feedback from people interested in drm.active_us and drm.memory.stat i=
s
>    required to understand the use cases and their usefulness (of the fiel=
ds).
>
>    Memory stats are something which was easy to add to my series, since I=
 was
>    already working on the fdinfo memory stats patches, but the question i=
s how
>    useful it is.
>
Hi Tvrtko,

I think this style of driver-defined categories for reporting of
memory could potentially allow us to eliminate the GPU memory tracking
tracepoint used on Android (gpu_mem_total). This would involve reading
drm.memory.stat at the root cgroup (I see it's currently disabled on
the root), which means traversing the whole cgroup tree under the
cgroup lock to generate the values on-demand. This would be done
rarely, but I still wonder what the cost of that would turn out to be.
The drm_memory_stats categories in the output don't seem like a big
value-add for this use-case, but no real objection to them being
there. I know it's called the DRM cgroup controller, but it'd be nice
if there were a way to make the mem tracking part work for any driver
that wishes to participate as many of our devices don't use a DRM
driver. But making that work doesn't look like it would fit very
cleanly into this controller, so I'll just shut up now.

Thanks!
-T.J.
