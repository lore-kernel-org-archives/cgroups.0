From: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
Subject: Re: [RFC PATCH 8/9] drm/gem: Associate GEM objects with drm cgroup
Date: Thu, 11 Feb 2021 16:34:47 +0100
Message-ID: <YCVOl8/87bqRSQei@phenom.ffwll.local>
References: <20210126214626.16260-1-brian.welty@intel.com>
 <20210126214626.16260-9-brian.welty@intel.com>
 <YCJp//kMC7YjVMXv@phenom.ffwll.local>
 <dffeb6a7-90f1-e17c-9695-44678e7a39cb@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ffwll.ch; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=YiO4YBxo5TAk5u+vjQ05MHs/C7RLL8aWvDBGX7r8+/I=;
 b=Ycak3/tZiINiOGiQPA//H9zGD3DQG+ZSCUZHbhuzVcPwJnjnH7T1RSl/2CDqsOOGHG
 9OREgwzKygBumrh3rCt+tvCgQ3IKBD60gliHM8OfZBfRAuOzxZL8iTwmI6B+PAd6GKMq
 4QyHjIevuicMj79oUYn6u1ALADWLaB3FhMOy0=
Content-Disposition: inline
In-Reply-To: <dffeb6a7-90f1-e17c-9695-44678e7a39cb-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Eero Tamminen <eero.t.tamminen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Joonas Lahtinen <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>

On Wed, Feb 10, 2021 at 02:00:57PM -0800, Brian Welty wrote:
> 
> On 2/9/2021 2:54 AM, Daniel Vetter wrote:
> > On Tue, Jan 26, 2021 at 01:46:25PM -0800, Brian Welty wrote:
> >> This patch adds tracking of which cgroup to make charges against for a
> >> given GEM object.  We associate the current task's cgroup with GEM objects
> >> as they are created.  First user of this is for charging DRM cgroup for
> >> device memory allocations.  The intended behavior is for device drivers to
> >> make the cgroup charging calls at the time that backing store is allocated
> >> or deallocated for the object.
> >>
> >> Exported functions are provided for charging memory allocations for a
> >> GEM object to DRM cgroup. To aid in debugging, we store how many bytes
> >> have been charged inside the GEM object.  Add helpers for setting and
> >> clearing the object's associated cgroup which will check that charges are
> >> not being leaked.
> >>
> >> For shared objects, this may make the charge against a cgroup that is
> >> potentially not the same cgroup as the process using the memory.  Based
> >> on the memory cgroup's discussion of "memory ownership", this seems
> >> acceptable [1].
> >>
> >> [1] https://www.kernel.org/doc/Documentation/cgroup-v2.txt, "Memory Ownership"
> >>
> >> Signed-off-by: Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> > Since for now we only have the generic gpu/xpu/bikeshed.memory bucket that
> > counts everything, why don't we also charge in these gem functions?
> 
> I'm not sure what you mean exactly.  You want to merge/move the charging logic
> proposed in patch #5 (drm_cgroup_try_charge in kernel/cgroup/drm.c) into
> drm_gem_object_charge_mem() ?
> 
> Or reading below, I think you are okay keeping the logic separated as is, but
> you want much of the code in kernel/cgroup/drm.c moved to drivers/gpu/cgroup ?
> Yes, I see that should allow to reduce number of exported functions.

Both. I mean we'd need to look at the code again when it's shuffled, but
I'd say:

- cgroup code and the charging for general gpu memory moves to
  drivers/gpu/cgroup, so dma-buf heaps can use it too.

- the charging for gem buffers moves into core gem code, so it happens for
  all gpu drivers and all gem buffer allocations.

- this might or might not mean a bunch less exported stuff from the
  cgroups files (since you don't need separate steps for linking a gem
  object to a cgroup from the actual charging), and probably no exports
  anymore for drivers (since they charge nothing). That will change
  when we add charging for specific memory pools I guess, but we add that
  when we add tha functionality.

> > Also, that would remove the need for all these functions exported to
> > drivers. Plus the cgroups setup could also move fully into drm core code,
> > since all drivers (*) support it
> > That way this would really be a fully
> > generic cgroups controller, and we could land it.
> 
> 
> Patch #2 proposed to have a few setup functions called during drm device
> registration.
> You are suggesting to have this more tightly integrated?

Yeah essentially if DRIVER_GEM is set drm core would simply set this all
up. Since with this we'd always account all gem buffers in cgroups, and it
would make basic cgroup support a non-optional part of drm drivers.

> Okay, can see what that looks like.  It's true most of the exported functions from
> kernel/cgroup/drm.c were taking a struct drm_device pointer, so seems it can be
> restructured as you suggest.  But I guess we will always need some logic in
> kernel/cgroup/drm.c to encapsulate the allocation of the 'struct cgroup_subsys_state'
> for this new controller.
> But I'm not sure I see how this makes the controller 'fully generic' as you describe.

All DRIVER_GEM would automatacially support it. And yes there'll still be
some encapsulation ofc.

> > The other things I'd do:
> > - drop gpu scheduling controller from the initial patch series. Yes we'll
> >   need it, but we also need vram limits and all these things for full
> >   featured controller. Having the minimal viable cgroup controller in
> >   upstream would unblock all these other things, and we could discuss them
> >   in separate patch series, instead of one big bikeshed that never reaches
> >   full consensus.
> > 
> > - the xpu thing is probably real, I just chatted with Android people for
> >   their gpu memory accounting needs, and cgroups sounds like a solution
> >   for them too. But unlike on desktop/server linux, on Android all shared
> >   buffers are allocated from dma-buf heaps, so outside of drm, and hence a
> >   cgroup controller that's tightly tied to drm isn't that useful. So I
> >   think we should move the controller/charge functions up one level into
> >   drivers/gpu/cgroups.
> 
> Hmm, so for this, you are asking for the cgroup logic to not directly use
> DRM data structures?  Okay, that's why you suggest drivers/gpu/cgroups and
> not drivers/gpu/drm/cgroups.  So this is your angle to make it 'fully
> generic' then.....

This is another flavour of "generic", maybe need to split them up:
- make it more generic by rolling it out for all DRIVER_GEM
- make it more generic by allowing non-drm code to charge gpu memory
  (android's dma-buf heaps will need that, maybe v4l eventually too)

> >   On the naming bikeshed I think gpu is perfectly fine, just explain in
> >   the docs that the G stands for "general" :-) Otherwise we might need to
> >   rename drivers/gpu to drivers/xpu too, and that's maybe one bikeshed too
> >   far. Plus, right now it really is the controller for gpu related memory,
> >   even if we extend it to Android (where it would also include
> >   video/camera allocatioons). Extending this cgroup controller to
> >   accelerators in general is maybe a bit too much.
> >  
> > - The other disambiguation is how we account dma-buf (well, buffer based)
> >   gpu allocations vs HMM gpu memory allocations, that might be worth
> >   clarifying in the docs.
> > 
> > - Finally to accelerate this further, I think it'd be good to pull out the
> >   cgroup spec for this more minimized series into patch 1, as a draft.
> >   That way we could get all stakeholders to ack on that ack, so hopefully
> >   we're building something that will work for everyone. That way we can
> >   hopefully untangle the controller design discussions from the
> >   implementation bikeshedding as much as possible.
> 
> Okay, thanks for all the inputs.
> I agree the 'cgroup spec' should be in first patch.  Can redo this way as well.
> 
> As much of the code here for the controller was Kenny's work...
> Kenny, any input on Daniel's suggestions?
> Otherwise, I can proceed to rework as suggested.

If you're worried about acknowledgement if you end up fully rewriting
code: Reference an old version from Kenny from archive and mention in the
commit log it's based on that work. There's no requirement that you can
only reuse patches from other people entirely unchanged, this kind of
collaborative patch development mode happens all the time.

Cheers, Daniel

> 
> Thanks,
> -Brian
> 
> 
> > 
> > Cheers, Daniel
> > 
> > *: vmwgfx is the only non-gem driver, but there's plans to move at least
> > vmwgfx internals (maybe not the uapi, we'll see) over to gem. Once that's
> > done it's truly all gpu memory.
> >> ---
> >>  drivers/gpu/drm/drm_gem.c | 89 +++++++++++++++++++++++++++++++++++++++
> >>  include/drm/drm_gem.h     | 17 ++++++++
> >>  2 files changed, 106 insertions(+)
> >>
> >> diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
> >> index c2ce78c4edc3..a12da41eaafe 100644
> >> --- a/drivers/gpu/drm/drm_gem.c
> >> +++ b/drivers/gpu/drm/drm_gem.c
> >> @@ -29,6 +29,7 @@
> >>  #include <linux/slab.h>
> >>  #include <linux/mm.h>
> >>  #include <linux/uaccess.h>
> >> +#include <linux/cgroup_drm.h>
> >>  #include <linux/fs.h>
> >>  #include <linux/file.h>
> >>  #include <linux/module.h>
> >> @@ -112,6 +113,89 @@ drm_gem_init(struct drm_device *dev)
> >>  	return drmm_add_action(dev, drm_gem_init_release, NULL);
> >>  }
> >>  
> >> +/**
> >> + * drm_gem_object_set_cgroup - associate GEM object with a cgroup
> >> + * @obj: GEM object which is being associated with a cgroup
> >> + * @task: task associated with process control group to use
> >> + *
> >> + * This will acquire a reference on cgroup and use for charging GEM
> >> + * memory allocations.
> >> + * This helper could be extended in future to migrate charges to another
> >> + * cgroup, print warning if this usage occurs.
> >> + */
> >> +void drm_gem_object_set_cgroup(struct drm_gem_object *obj,
> >> +			       struct task_struct *task)
> >> +{
> >> +	/* if object has existing cgroup, we migrate the charge... */
> >> +	if (obj->drmcg) {
> >> +		pr_warn("DRM: need to migrate cgroup charge of %lld\n",
> >> +			atomic64_read(&obj->drmcg_bytes_charged));
> >> +	}
> >> +	obj->drmcg = drmcg_get(task);
> >> +}
> >> +EXPORT_SYMBOL(drm_gem_object_set_cgroup);
> >> +
> >> +/**
> >> + * drm_gem_object_unset_cgroup - clear GEM object's associated cgroup
> >> + * @obj: GEM object
> >> + *
> >> + * This will release a reference on cgroup.
> >> + */
> >> +void drm_gem_object_unset_cgroup(struct drm_gem_object *obj)
> >> +{
> >> +	WARN_ON(atomic64_read(&obj->drmcg_bytes_charged));
> >> +	drmcg_put(obj->drmcg);
> >> +}
> >> +EXPORT_SYMBOL(drm_gem_object_unset_cgroup);
> >> +
> >> +/**
> >> + * drm_gem_object_charge_mem - try charging size bytes to DRM cgroup
> >> + * @obj: GEM object which is being charged
> >> + * @size: number of bytes to charge
> >> + *
> >> + * Try to charge @size bytes to GEM object's associated DRM cgroup.  This
> >> + * will fail if a successful charge would cause the current device memory
> >> + * usage to go above the cgroup's GPU memory maximum limit.
> >> + *
> >> + * Returns 0 on success.  Otherwise, an error code is returned.
> >> + */
> >> +int drm_gem_object_charge_mem(struct drm_gem_object *obj, u64 size)
> >> +{
> >> +	int ret;
> >> +
> >> +	ret = drm_cgroup_try_charge(obj->drmcg, obj->dev,
> >> +				    DRMCG_TYPE_MEM_CURRENT, size);
> >> +	if (!ret)
> >> +		atomic64_add(size, &obj->drmcg_bytes_charged);
> >> +	return ret;
> >> +}
> >> +EXPORT_SYMBOL(drm_gem_object_charge_mem);
> >> +
> >> +/**
> >> + * drm_gem_object_uncharge_mem - uncharge size bytes from DRM cgroup
> >> + * @obj: GEM object which is being uncharged
> >> + * @size: number of bytes to uncharge
> >> + *
> >> + * Uncharge @size bytes from the DRM cgroup associated with specified
> >> + * GEM object.
> >> + *
> >> + * Returns 0 on success.  Otherwise, an error code is returned.
> >> + */
> >> +void drm_gem_object_uncharge_mem(struct drm_gem_object *obj, u64 size)
> >> +{
> >> +	u64 charged = atomic64_read(&obj->drmcg_bytes_charged);
> >> +
> >> +	if (WARN_ON(!charged))
> >> +		return;
> >> +	if (WARN_ON(size > charged))
> >> +		size = charged;
> >> +
> >> +	atomic64_sub(size, &obj->drmcg_bytes_charged);
> >> +	drm_cgroup_uncharge(obj->drmcg, obj->dev, DRMCG_TYPE_MEM_CURRENT,
> >> +			    size);
> >> +}
> >> +EXPORT_SYMBOL(drm_gem_object_uncharge_mem);
> >> +
> >>  /**
> >>   * drm_gem_object_init - initialize an allocated shmem-backed GEM object
> >>   * @dev: drm_device the object should be initialized for
> >> @@ -156,6 +240,8 @@ void drm_gem_private_object_init(struct drm_device *dev,
> >>  	obj->dev = dev;
> >>  	obj->filp = NULL;
> >>  
> >> +	drm_gem_object_set_cgroup(obj, current);
> >> +
> >>  	kref_init(&obj->refcount);
> >>  	obj->handle_count = 0;
> >>  	obj->size = size;
> >> @@ -950,6 +1036,9 @@ drm_gem_object_release(struct drm_gem_object *obj)
> >>  
> >>  	dma_resv_fini(&obj->_resv);
> >>  	drm_gem_free_mmap_offset(obj);
> >> +
> >> +	/* Release reference on cgroup used with GEM object charging */
> >> +	drm_gem_object_unset_cgroup(obj);
> >>  }
> >>  EXPORT_SYMBOL(drm_gem_object_release);
> >>  
> >> diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
> >> index 240049566592..06ea10fc17bc 100644
> >> --- a/include/drm/drm_gem.h
> >> +++ b/include/drm/drm_gem.h
> >> @@ -37,6 +37,7 @@
> >>  #include <linux/kref.h>
> >>  #include <linux/dma-resv.h>
> >>  
> >> +#include <drm/drm_cgroup.h>
> >>  #include <drm/drm_vma_manager.h>
> >>  
> >>  struct dma_buf_map;
> >> @@ -222,6 +223,17 @@ struct drm_gem_object {
> >>  	 */
> >>  	struct file *filp;
> >>  
> >> +	/**
> >> +	 * @drmcg:
> >> +	 *
> >> +	 * cgroup used for charging GEM object page allocations against. This
> >> +	 * is set to the current cgroup during GEM object creation.
> >> +	 * Charging policy is up to the DRM driver to implement and should be
> >> +	 * charged when allocating backing store from device memory.
> >> +	 */
> >> +	struct drmcg *drmcg;
> >> +	atomic64_t drmcg_bytes_charged;
> >> +
> >>  	/**
> >>  	 * @vma_node:
> >>  	 *
> >> @@ -417,4 +429,9 @@ int drm_gem_fence_array_add_implicit(struct xarray *fence_array,
> >>  int drm_gem_dumb_map_offset(struct drm_file *file, struct drm_device *dev,
> >>  			    u32 handle, u64 *offset);
> >>  
> >> +void drm_gem_object_set_cgroup(struct drm_gem_object *obj,
> >> +			       struct task_struct *task);
> >> +void drm_gem_object_unset_cgroup(struct drm_gem_object *obj);
> >> +int drm_gem_object_charge_mem(struct drm_gem_object *obj, u64 size);
> >> +void drm_gem_object_uncharge_mem(struct drm_gem_object *obj, u64 size);
> >>  #endif /* __DRM_GEM_H__ */
> >> -- 
> >> 2.20.1
> >>
> > 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
