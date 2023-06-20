From: Emil Velikov <emil.l.velikov@gmail.com>
Subject: Re: [RFC 02/10] drm: Update file owner during use
Date: Tue, 20 Jun 2023 15:48:42 +0100
Message-ID: <CACvgo51DmeM7Tbboozxu3Yn-Pe-eALVTkiq4vZBJJHKfqP_HeA@mail.gmail.com>
References: <20230314141904.1210824-1-tvrtko.ursulin@linux.intel.com>
 <20230314141904.1210824-3-tvrtko.ursulin@linux.intel.com> <CACvgo52Bb3kBua8dh+eac6dhSwiJLMGAdGDAa+LQYoOwCLPLNA@mail.gmail.com>
 <77587046-aede-f625-6a35-55bf9c5f1179@linux.intel.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687272534; x=1689864534;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=P/BJYkX6bywThpMtgw8TodK1xxjg+6M9424vm6AiX+Y=;
        b=lgOaNfjNi640O9ZZHKv/WLheDYiuIbH18qLmGDyCLONcthMEFX+H5LSmG9gOVzksDc
         CQLFSTiuRlk1VWwhUbieZipxET0Zc/GAVPhzolyepEoZygQotuQZVRD4nYvzGaZn3PMC
         WXvs926H2+4CKi5nARSFzigY4G/qCPjPOyomRJuWmIzfmVoL5hLT6xD++D+33HDh3YMr
         1cqM3g2fkpfHrsN2JbWw5fstY/OCkyK5XGks3hfOCC7dlfBe7YuijuzHYaingCIMGyhO
         7A7hUXQGBFqCTSLv4y8EyFKzwPGWCcONQVgOV5kPQTLtSvEcUnhORCwwAO4m6perxe7W
         w98g==
In-Reply-To: <77587046-aede-f625-6a35-55bf9c5f1179@linux.intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, Rob Clark <robdclark@chromium.org>, Brian Welty <brian.welty@intel.com>, Kenny.Ho@amd.com, Tvrtko Ursulin <tvrtko.ursulin@intel.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, =?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu@chromium.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, Zefan Li <lizefan.x@bytedance.com>, Dave Airlie <airlied@redhat.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, "T . J . Mercier" <tjmercier@google.com>

Hi Tvrtko

Sorry for the delay, real life and other obligations got in the way.

On Thu, 8 Jun 2023 at 15:26, Tvrtko Ursulin
<tvrtko.ursulin@linux.intel.com> wrote:
> On 21/04/2023 13:13, Emil Velikov wrote:

> Are you okay if I just paste your very fine explanation verbatim, with
> credits?
>

Yes, feel free to use as much of if as you see reasonable.

> > I also had a brief look at 01/10, although I cannot find many
> > references for the pid <> tguid mappings. Be that on the kernel side
> > or userspace - do you have any links that I can educate myself?
>
> TGID or thread group leader. For single threaded userspace TGID equals
> to PID, while for multi-threaded first thread TGID equals PID/TID, while
> additional threads PID/TID does not equal TGID. Clear, as mud? :) My
> POSIX book is misplaced somewhere having not consulted it years... :)
>

Ack. /me looks into actually buying one, perhaps

Thanks
Emil
