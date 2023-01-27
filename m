From: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [RFC 10/12] cgroup/drm: Introduce weight based drm cgroup control
Date: Fri, 27 Jan 2023 13:31:54 +0000
Message-ID: <a96e6b5c-b538-f7e7-d603-cabb29137de7@linux.intel.com>
References: <20230112165609.1083270-1-tvrtko.ursulin@linux.intel.com>
 <20230112165609.1083270-11-tvrtko.ursulin@linux.intel.com>
 <20230127130134.GA15846@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674826320; x=1706362320;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7mC15fOVSE6NegzxHk/BX7UWkKB1AkE7p5o74pyZvt0=;
  b=FQuWs8hjrBVGcHF4IWhbLkPxigoAJ+8TMm+tL72Kw5mBIlLc8FtqUxj4
   y0H9jw3H9709it7RHmVedqxV9OYZ791r5l1PEVPP9AZmygWJH0xpyhkDM
   uyv8UvptWrsYwsR05TGEbQAith9JmLUHHovB5ZESjuBIravMUaH57sbIv
   8kM1tTcNFZSwoRNsPsOofO8pRwPnjlNK3KpcWILu2Rci+cTUDCeyFK37y
   UO/xJ8cUjyIx+ApHq8D6CJZJrEVXl/xcXELFppdczC5OyKxIhVOYQgyt8
   azQl7EcmGoNi0Kz5wLJ4U/8CHcJHsJkegGkc1FWoHvZjcDHvT9fJ9rHMK
   g==;
Content-Language: en-US
In-Reply-To: <20230127130134.GA15846-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?UTF-8?Q?St=c3=a9phane_Marchesin?= <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


On 27/01/2023 13:01, Michal Koutn=C3=BD wrote:
> On Thu, Jan 12, 2023 at 04:56:07PM +0000, Tvrtko Ursulin <tvrtko.ursulin-=
VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
>> +static int drmcs_can_attach(struct cgroup_taskset *tset)
>> +{
>> +	int ret;
>> +
>> +	/*
>> +	 * As processes are getting moved between groups we need to ensure
>> +	 * both that the old group does not see a sudden downward jump in the
>> +	 * GPU utilisation, and that the new group does not see a sudden jump
>> +	 * up with all the GPU time clients belonging to the migrated process
>> +	 * have accumulated.
>> +	 *
>> +	 * To achieve that we suspend the scanner until the migration is
>> +	 * completed where the resume at the end ensures both groups start
>> +	 * observing GPU utilisation from a reset state.
>> +	 */
>> +
>> +	ret =3D mutex_lock_interruptible(&drmcg_mutex);
>> +	if (ret)
>> +		return ret;
>> +	start_suspend_scanning();
>> +	mutex_unlock(&drmcg_mutex);
>> +
>> +	finish_suspend_scanning();
>=20
> Here's scanning suspension, communicated via
>=20
> 	root_drmcs.scanning_suspended =3D true;
> 	root_drmcs.suspended_period_us =3D root_drmcs.period_us;
> 	root_drmcs.period_us =3D 0;
>=20
> but I don't see those used in scan_worker() and the scanning traversal
> can apparently run concurrently with a task migration.

I think you missed the finish_suspend_scanning() part:

	if (root_drmcs.suspended_period_us)
		cancel_delayed_work_sync(&root_drmcs.scan_work);

So if scanning was in progress migration will wait until it finishes.=20
And re-start only when migration is done (drmcs_attach), or it failed=20
(drmcs_cancel_attach).

Not claiming I did not miss something because I was totally new with=20
cgroup internals when I started working on this. So it is definitely=20
useful to have more eyes looking.

>> [...]
>> +static bool
>> +__start_scanning(struct drm_cgroup_state *root, unsigned int period_us)
>> [...]
>> +	css_for_each_descendant_post(node, &root->css) {
>> [...]
>> +		active =3D drmcs_get_active_time_us(drmcs);
>> +		if (period_us && active > drmcs->prev_active_us)
>> +			drmcs->active_us +=3D active - drmcs->prev_active_us;
>> +		drmcs->prev_active_us =3D active;
>=20
> drmcs_get_active_time_us() could count a task's contribution here,
> the task would migrate to a different drmcs,
> and it'd be counted 2nd time.

Lets see.. __start_scanning() can be called from the worker, so max one=20
instance at a time, no issue.

Then from resume scanning, so it is guaranteed worker is not running and=20
can't restart since mutex guards the re-start.

Finally from drmcs_write_period_us() - yes there __start_scanning() can=20
race with it being invoked by the worker - oops! However.. this is just=20
a debugging aid as the cover letter explains. This file is not intended=20
to be present in the final version, rather as per earlier discussion=20
with Tejun the idea is to only have boot time option to control the=20
functionality (enable/disable or period).

I will nevertheless try to fix this race up for the next posting to=20
avoid further confusion!

Regards,

Tvrtko
