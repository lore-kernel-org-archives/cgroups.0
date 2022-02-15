From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC v2 6/6] android: binder: Add a buffer flag to relinquish
 ownership of fds
Date: Tue, 15 Feb 2022 08:01:33 +0100
Message-ID: <YgtPzXUmSOVyplnm@kroah.com>
References: <20220211161831.3493782-1-tjmercier@google.com>
 <20220211161831.3493782-7-tjmercier@google.com>
 <Ygdfe3XSvN8iFuUc@kroah.com>
 <CABdmKX1eKZZ9809uxnzT_Bm+mdNuK2AObLRxyBpdDF3yE76Hrg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644908501;
        bh=wpzzdawXPScQHsJKBVOQr1uSYppSynJn4bs/yhbdSyA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sDmBWC3bBYfh7HeEsWgCqhfPOjCVWGl90AwNQquw/s37apawMvykr5dLCSbz5VT27
         a5wp3rnQFH3/laPLOG74o03tMDNPPnSjnHPzjnFiNl3JfoADYuF4Ae3fNI0UhZkloP
         Bj+1hg9P55uKX3tSh0BSWmUJrdwJHc5XuXmorEUI=
Content-Disposition: inline
In-Reply-To: <CABdmKX1eKZZ9809uxnzT_Bm+mdNuK2AObLRxyBpdDF3yE76Hrg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "T.J. Mercier" <tjmercier@google.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Jonathan Corbet <corbet@lwn.net>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <brauner@kernel.org>, Hridya Valsaraju <hridya@google.com>, Suren Baghdasaryan <surenb@google.com>, Sumit Semwal <sumit.semwal@linaro.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Benjamin Gaignard <benjamin.gaignard@linaro.org>, Liam Mark <lmark@codeaurora.org>, Laura Abbott <labbott@redhat.com>, Brian Starkey <Bri>

On Mon, Feb 14, 2022 at 02:25:47PM -0800, T.J. Mercier wrote:
> On Fri, Feb 11, 2022 at 11:19 PM Greg Kroah-Hartman
> > > --- a/include/uapi/linux/android/binder.h
> > > +++ b/include/uapi/linux/android/binder.h
> > > @@ -137,6 +137,7 @@ struct binder_buffer_object {
> > >
> > >  enum {
> > >       BINDER_BUFFER_FLAG_HAS_PARENT = 0x01,
> > > +     BINDER_BUFFER_FLAG_SENDER_NO_NEED = 0x02,
> > >  };
> > >
> > >  /* struct binder_fd_array_object - object describing an array of fds in a buffer
> > > --
> > > 2.35.1.265.g69c8d7142f-goog
> > >
> >
> > How does userspace know that binder supports this new flag?
> 
> Sorry, I don't completely follow even after Todd's comment. Doesn't
> the presence of BINDER_BUFFER_FLAG_SENDER_NO_NEED in the header do
> this?

There is no "header" when running a new kernel on an old userspace,
right?  How about the other way around, old kernel, new userspace?

> So wouldn't userspace need to be compiled against the wrong
> kernel headers for there to be a problem? In that case the allocation
> would still succeed, but there would be no charge transfer and
> unfortunately no error code.

No error code is not good.  People upgrade their kernels all the time,
and do not do a "rebuild the world" when doing so.

> > And where is the userspace test for this new feature?
> 
> I tested this on a Pixel after modifying the gralloc implementation to
> mark allocated buffers as not used by the sender. This required
> setting the BINDER_BUFFER_FLAG_SENDER_NO_NEED in libhwbinder. That
> code can be found here:
> https://android-review.googlesource.com/c/platform/system/libhwbinder/+/1910752/1/Parcel.cpp
> https://android-review.googlesource.com/c/platform/system/libhidl/+/1910611/
> 
> Then by inspecting gpu.memory.current files in sysfs I was able to see
> the memory attributed to processes other than the graphics allocator
> service. Before this change, several megabytes of memory were
> attributed to the graphics allocator service but those buffers are
> actually used by other processes like surfaceflinger, the camera, etc.
> After the change, the gpu.memory.current amount for the graphics
> allocator service was 0 and the charges showed up in the
> gpu.memory.current files for those other processes like this:
> 
> PID: 764 Process Name: zygote64
> system 8192
> system-uncached 23191552
> 
> PID: 529 Process Name: /system/bin/surfaceflinger
> system-uncached 109535232
> system 92196864
> 
> PID: 530 Process Name:
> /vendor/bin/hw/android.hardware.graphics.allocator@4.0-service
> system-uncached 0
> system 0
> sensor_direct_heap 0
> 
> PID: 806 Process Name:
> /apex/com.google.pixel.camera.hal/bin/hw/android.hardware.camera.provider@2.7-service-google
> system 1196032
> 
> PID: 4608 Process Name: com.google.android.GoogleCamera
> system 2408448
> system-uncached 38887424
> sensor_direct_heap 0
> 
> PID: 32102 Process Name: com.google.android.googlequicksearchbox:search
> system-uncached 91279360
> system 20480
> 
> PID: 2758 Process Name: com.google.android.youtube
> system-uncached 1662976
> system 8192
> 
> PID: 2517 Process Name: com.google.android.apps.nexuslauncher
> system-uncached 115662848
> system 122880
> 
> PID: 2066 Process Name: com.android.systemui
> system 86016
> system-uncached 37957632
> 
> >  Isn't there a binder test framework somewhere?
> 
> Android has the Vendor Test Suite where automated tests could be added
> for this. Is that what you're thinking of?

tools/testing/selftests/ is a good start.  VTS is the worst-case as no
one can really run that on their own, but it is better than nothing.
Having no test at all for this is not ok.

thanks,

greg k-h
