From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC v3 00/12] DRM scheduling cgroup controller
Date: Thu, 26 Jan 2023 07:04:08 -1000
Message-ID: <Y9KyiCPYj2Mzym3Z@slm.duckdns.org>
References: <20230112165609.1083270-1-tvrtko.ursulin@linux.intel.com>
 <20230123154239.GA24348@blackbody.suse.cz>
 <371f3ce5-3468-b91d-d688-7e89499ff347@linux.intel.com>
 <20230126130050.GA22442@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date:sender
 :from:to:cc:subject:date:message-id:reply-to;
 bh=2N5z7vm8wkipXchVo2DX0B/FIOfj1plPYH1BFui3jhE=;
 b=mT9+Y3uCrH/JgDR2rhlOog9/pF0Z2rxmXzu5MO7j8fBMR2bN/n7cXByNjpiUUFc1W1
 RaH0re/D97GeOb/sT4rwsrokz5YzDD9hsZ7BFTiV5qiXH4ar/yWa44IV3MUhMWaKO9XB
 zZZnOEPSzPTEK24UoQVOtdr/6MgDHTK6wQFKG1pwV/ZDiyBiQlUxjLoYsJ8Xw69DKkid
 ZjEq7NBwnlX5WnA9fSdQVXmdjrqXmab4/ksW01BSZWaczVBkAZTTeitU/kChCxObBz3T
 BSdl3jxXAtOoL4WoLqPjve1xQ+aPDBbn1ePQFmrJAFbI8mo37z/GXSdb4FtKAOHiUFc3
 lXYg==
Content-Disposition: inline
In-Reply-To: <20230126130050.GA22442@blackbody.suse.cz>
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
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Rob Clark <robdclark@chromium.org>, Kenny.Ho@amd.com, Dave Airlie <airlied@redhat.com>, =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu@chromium.org>, Daniel Vetter <daniel.vetter@ffwll.ch>, Intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, "T . J . Mercier" <tjmercier@google.com>

Hello,

On Thu, Jan 26, 2023 at 02:00:50PM +0100, Michal Koutn=FD wrote:
> On Wed, Jan 25, 2023 at 06:11:35PM +0000, Tvrtko Ursulin <tvrtko.ursulin@=
linux.intel.com> wrote:
> > I don't immediately see how you envisage the half-userspace implementat=
ion
> > would look like in terms of what functionality/new APIs would be provid=
ed by
> > the kernel?
>=20
> Output:
> 	drm.stat (with consumed time(s))
>=20
> Input:
> 	drm.throttle (alternatives)
> 	- a) writing 0,1 (in rough analogy to your proposed
> 	     notifications)
> 	- b) writing duration (in loose analogy to memory.reclaim)
> 	     - for how long GPU work should be backed off
>=20
> An userspace agent sitting between these two and it'd do the measurement
> and calculation depending on given policies (weighting, throttling) and
> apply respective controls.
>=20
> (In resemblance of e.g. https://denji.github.io/cpulimit/)

Yeah, things like this can be done from userspace but if we're gonna build
the infrastructure to allow that in gpu drivers and so on, I don't see why
we wouldn't add a generic in-kernel control layer if we can implement a
proper weight based control. We can of course also expose .max style
interface to allow userspace to do whatever they wanna do with it.

> > Problem there is to find a suitable point to charge at. If for a moment=
 we
> > limit the discussion to i915, out of the box we could having charging
> > happening at several thousand times per second to effectively never. Th=
is is
> > to illustrate the GPU context execution dynamics which range from many =
small
> > packets of work to multi-minute, or longer. For the latter to be accoun=
ted
> > for we'd still need some periodic scanning, which would then perhaps go=
 per
> > driver. For the former we'd have thousands of needless updates per seco=
nd.
> >=20
> > Hence my thinking was to pay both the cost of accounting and collecting=
 the
> > usage data once per actionable event, where the latter is controlled by=
 some
> > reasonable scanning period/frequency.
> >=20
> > In addition to that, a few DRM drivers already support GPU usage queryi=
ng
> > via fdinfo, so that being externally triggered, it is next to trivial to
> > wire all those DRM drivers into such common DRM cgroup controller frame=
work.
> > All that every driver needs to implement on top is the "over budget"
> > callback.
>=20
> I'd also like show comparison with CPU accounting and controller.
> There is tick-based (~sampling) measurement of various components of CPU
> time (task_group_account_field()). But the actual schedulling (weights)
> or throttling is based on precise accounting (update_curr()).
>=20
> So, if the goal is to have precise and guaranteed limits, it shouldn't
> (cannot) be based on sampling. OTOH, if it must be sampling based due to
> variability of the device landscape, it could be advisory mechanism with
> the userspace component.

As for the specific control mechanism, yeah, charge based interface would be
more conventional and my suspicion is that transposing the current
implementation that way likely isn't too difficult. It just pushes "am I
over the limit?" decisions to the specific drivers with the core layer
telling them how much under/over budget they are. I'm curious what other gpu
driver folks think about the current RFC tho. Is at least AMD on board with
the approach?

Thanks.

--=20
tejun
