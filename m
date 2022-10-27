From: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [RFC 02/17] drm: Track clients per owning process
Date: Thu, 27 Oct 2022 15:35:37 +0100
Message-ID: <c88d0c33-8616-faa4-b33e-5de36d7b73fd@linux.intel.com>
References: <20221019173254.3361334-1-tvrtko.ursulin@linux.intel.com>
 <20221019173254.3361334-3-tvrtko.ursulin@linux.intel.com>
 <77499370-bb0e-7f7e-ac1b-ad14f47578d9@amd.com>
 <391a77ea-1120-eb23-31f9-e7a14d84b10e@linux.intel.com>
 <04182f67-2c98-add4-be60-539ffe2e9d6a@amd.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666881497; x=1698417497;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1txbTAtjE56EX9D4ddBx/JjLRLCNwcs8zGSv/ynl+u4=;
  b=Z0oF4hbrZwAq5+hx02dkpbrthV7UKM4gMl5+E3jwgHIY+Y/XZ8FAGakU
   tQLObLFuIi0D787Vk1Ywvr77ST+PxkSMIAKs2MbKm57+YxXms5R/LFkcd
   mXmUpSMO3XDsL3xt4S1IL0R6ASnu1ViJsCCVrORqQcf+sSd6vTRiYcf6o
   gpEP8GT5nTnHk6dlfr66TG6walcx17sX694/fdRAQOJfKlsUexpKQdWOc
   eYmlaaGBWt6DGMpXx/TNetakOI4p362VY8QHoDb5pZtGmGbLHB502BdOb
   M0VXzs1g8mCVPLkr1x38ZD1YonhnPwkkDBM456PgOqrFy1YyjabxGPfAh
   w==;
Content-Language: en-US
In-Reply-To: <04182f67-2c98-add4-be60-539ffe2e9d6a-5C7GfCeVMHo@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?UTF-8?Q?St=c3=a9phane_Marchesin?= <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


On 20/10/2022 12:33, Christian König wrote:
> Am 20.10.22 um 09:34 schrieb Tvrtko Ursulin:
>>
>> On 20/10/2022 07:40, Christian König wrote:
>>> Am 19.10.22 um 19:32 schrieb Tvrtko Ursulin:
>>>> From: Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>>
>>>> To enable propagation of settings from the cgroup drm controller to 
>>>> drm we
>>>> need to start tracking which processes own which drm clients.
>>>>
>>>> Implement that by tracking the struct pid pointer of the owning 
>>>> process in
>>>> a new XArray, pointing to a structure containing a list of associated
>>>> struct drm_file pointers.
>>>>
>>>> Clients are added and removed under the filelist mutex and RCU list
>>>> operations are used below it to allow for lockless lookup.
>>>
>>> That won't work easily like this. The problem is that file_priv->pid 
>>> is usually not accurate these days:
>>>
>>>  From the debugfs clients file:
>>>
>>>        systemd-logind   773   0   y    y     0          0
>>>                  Xorg  1639 128   n    n  1000          0
>>>                  Xorg  1639 128   n    n  1000          0
>>>                  Xorg  1639 128   n    n  1000          0
>>>               firefox  2945 128   n    n  1000          0
>>>                  Xorg  1639 128   n    n  1000          0
>>>                  Xorg  1639 128   n    n  1000          0
>>>                  Xorg  1639 128   n    n  1000          0
>>>                  Xorg  1639 128   n    n  1000          0
>>>                chrome 35940 128   n    n  1000          0
>>>                chrome 35940   0   n    y  1000          1
>>>                chrome 35940   0   n    y  1000          2
>>>                  Xorg  1639 128   n    n  1000          0
>>>                  Xorg  1639 128   n    n  1000          0
>>>                  Xorg  1639 128   n    n  1000          0
>>>
>>> This is with glxgears and a bunch other OpenGL applications running.
>>>
>>> The problem is that for most applications the X/Wayland server is now 
>>> opening the render node. The only exceptions in this case are apps 
>>> using DRI2 (VA-API?).
>>>
>>> I always wanted to fix this and actually track who is using the file 
>>> descriptor instead of who opened it, but never had the time to do this.
>>
>> There's a patch later in the series which allows client records to be 
>> migrated to a new PID, and then i915 patch to do that when fd is used 
>> for context create. That approach I think worked well enough in the 
>> past. So maybe it could be done in the DRM core at some suitable entry 
>> point.
> 
> Yeah, that makes some sense. I think you should wire that inside 
> drm_ioctl(), as far as I know more or less all uses of a file descriptor 
> would go through that function.
> 
> And maybe make that a stand alone patch, cause that can go upstream as a 
> bug fix independently if you ask me.

I've put it on my todo list to try and come up with something standalone 
for this problem. Will see if I manage to send it separately or perhaps 
will start the next cgroup controller RFC with those patches.

>>> I think you need to fix this problem first. And BTW: and unsigned 
>>> long doesn't work as PID either with containers.
>>
>> This I am not familiar with so would like to hear more if you could 
>> point me in the right direction at least.
> 
> Uff, I'm the wrong person to ask stuff like that. I just can say from 
> experience because I've ran into that trap as well.
> 
>>
>> My assumption was that struct pid *, which is what I store in unsigned 
>> long, would be unique in a system where there is a single kernel 
>> running, so as long as lifetimes are correct (released from tracking 
>> here when fd is closed, which is implicit on process exit) would work. 
>> You are suggesting that is not so?
> 
> I think you should have the pointer to struct pid directly here since 
> that is a reference counted structure IIRC. But don't ask me what the 
> semantics is how to get or put a reference.

Yeah I think I have all that. I track struct pid, with a reference, in 
drm client, and release it when file descriptor is closed (indirectly 
via the DRM close hook). All I need, I think, is for that mapping to 
answer me "which drm_file objects" are in use by this struct pid 
pointer. I don't see a problem with lifetimes or scope yet.

Regards,

Tvrtko
