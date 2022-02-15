From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC v2 6/6] android: binder: Add a buffer flag to relinquish
 ownership of fds
Date: Tue, 15 Feb 2022 08:30:43 +0100
Message-ID: <YgtWo+6UeAU4/CvT@kroah.com>
References: <20220211161831.3493782-1-tjmercier@google.com>
 <20220211161831.3493782-7-tjmercier@google.com>
 <Ygdfe3XSvN8iFuUc@kroah.com>
 <CABdmKX1eKZZ9809uxnzT_Bm+mdNuK2AObLRxyBpdDF3yE76Hrg@mail.gmail.com>
 <YgtPzXUmSOVyplnm@kroah.com>
 <CAJuCfpG0V2qZVVUPRmw3fZP-bQmp+w36nOUe9iHtgmuHb7PemQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644910246;
        bh=d7O0LjAMCqSVPzrmAjEUAUrhTljBtokM4lMRkzTZRn4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nI9BT8e7bH53D6xl7GN7ShLijc1GUvEbq4aQlISk6014ej3GYNqf5qP80x8gmm/C9
         0guWhIB8CG6B5zuHuf00vQIZDZHrwIIKCzcTJ9SwAxgKSiayqHfUjljXOt3LauL8UI
         VXdXc4rXKsY/KwXxCm704rsBDZEywjRr3as+lK1g=
Content-Disposition: inline
In-Reply-To: <CAJuCfpG0V2qZVVUPRmw3fZP-bQmp+w36nOUe9iHtgmuHb7PemQ@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: "T.J. Mercier" <tjmercier@google.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Jonathan Corbet <corbet@lwn.net>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <brauner@kernel.org>, Hridya Valsaraju <hridya@google.com>, Sumit Semwal <sumit.semwal@linaro.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Benjamin Gaignard <benjamin.gaignard@linaro.org>, Liam Mark <lmark@codeaurora.org>, Laura Abbott <labbott@redhat.com>, Brian Starkey <Bria>

On Mon, Feb 14, 2022 at 11:19:35PM -0800, Suren Baghdasaryan wrote:
> On Mon, Feb 14, 2022 at 11:01 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Feb 14, 2022 at 02:25:47PM -0800, T.J. Mercier wrote:
> > > On Fri, Feb 11, 2022 at 11:19 PM Greg Kroah-Hartman
> > > > > --- a/include/uapi/linux/android/binder.h
> > > > > +++ b/include/uapi/linux/android/binder.h
> > > > > @@ -137,6 +137,7 @@ struct binder_buffer_object {
> > > > >
> > > > >  enum {
> > > > >       BINDER_BUFFER_FLAG_HAS_PARENT = 0x01,
> > > > > +     BINDER_BUFFER_FLAG_SENDER_NO_NEED = 0x02,
> > > > >  };
> > > > >
> > > > >  /* struct binder_fd_array_object - object describing an array of fds in a buffer
> > > > > --
> > > > > 2.35.1.265.g69c8d7142f-goog
> > > > >
> > > >
> > > > How does userspace know that binder supports this new flag?
> > >
> > > Sorry, I don't completely follow even after Todd's comment. Doesn't
> > > the presence of BINDER_BUFFER_FLAG_SENDER_NO_NEED in the header do
> > > this?
> >
> > There is no "header" when running a new kernel on an old userspace,
> > right?  How about the other way around, old kernel, new userspace?
> 
> 1. new kernel + old userspace = kernel supports the feature but
> userspace does not use it. The old userspace won't even mount the new
> cgroup controller, accounting is not performed, charge is not
> transferred.
> 2. old kernel + new userspace = the new cgroup controller is not
> supported by the kernel, accounting is not performed, charge is not
> transferred.
> 3. old kernel + old userspace = same as #2
> 4. new kernel + new userspace = cgroup is mounted, feature is
> supported and used.
> Does that work or do we need a separate indication of whether binder
> driver supports the charge transfer feature?

Ok, if that's all working, this is fine, it just seemed odd to add a new
type like this.  Perhaps this can go into the changelog text...

thanks,

greg k-h
