From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v7 0/6] Proposal for a GPU cgroup controller
Date: Thu, 19 May 2022 21:47:25 -1000
Message-ID: <YodHjYlMx1XGtM2+@slm.duckdns.org>
References: <20220510235653.933868-1-tjmercier@google.com>
 <3365cd1d750e84fedc8e75d646a77ffd85619d35.camel@ndufresne.ca>
 <CABdmKX3ZV6-u-oLvW_wWavAMBfrsZ=C_rCgK_Uz4VjxcRvRFew@mail.gmail.com>
 <81026ef07c1ce20f8673b75b17bab79a2b39c548.camel@ndufresne.ca>
 <CABdmKX2LxZ6zZR=fhXfnuWCB2BR+gzDd1-t1DD2A2XP24wvuGQ@mail.gmail.com>
 <Yn6DpUsoSz1/15Kc@slm.duckdns.org>
 <CABdmKX1xvm87WMEDkMc9Aye46E4zv1-scenwgaRxHesrOCsaYg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-media-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=56ihVfI55g+5kWoCWi0j9KBKpP7u+QiASGOdishgsYU=;
        b=fI4qwgrFQO4hVvdc3SUyQ8Cdgd+sywkDfLxoX5FB2E66Rov05yQTZSVOzP7gpoXEQF
         0elvCO46fIFZh0PGVYSb0zBP9E8rthiYU1kAunjlGADxZHVDIzKAD9lkoRKg2HXJ1W5y
         hXlwhv/t9DEN5z9vOFJjkOJHZlgbiKv1kt3tICg8ZW4m3WO5jv6iWCSmP7K1aB7qLYm4
         VMIP2whsDbn6dmzkcOergoPPDPGfcjXLPaXh/y5sNGVVKXZAO8zLhLtKDQfFcopimuD1
         iFzKXGu0GYsL7i2AAdYko6ymJb3ROx8/6svDCApNBiO36LmQDMIJe2JZDgJ2TmbOdK9q
         Eg8A==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <CABdmKX1xvm87WMEDkMc9Aye46E4zv1-scenwgaRxHesrOCsaYg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "T.J. Mercier" <tjmercier@google.com>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <brauner@kernel.org>, Hridya Valsaraju <hridya@google.com>, Suren Baghdasaryan <surenb@google.com>, Sumit Semwal <sumit.semwal@linaro.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Benjamin Gaignard <benjamin.gaignard@collabora.com>, Liam Mark <lmark@codeaurora.org>, Laura Abbott <labbott@redhat.com>, Brian Starkey <Brian.Starkey@arm.com>, John

Hello,

On Tue, May 17, 2022 at 04:30:29PM -0700, T.J. Mercier wrote:
> Thanks for your suggestion. This almost works. "dmabuf" as a key could
> work, but I'd actually like to account for each heap. Since heaps can
> be dynamically added, I can't accommodate every potential heap name by
> hardcoding registrations in the misc controller.

On its own, that's a pretty weak reason to be adding a separate gpu
controller especially given that it doesn't really seem to be one with
proper abstractions for gpu resources. We don't want to keep adding random
keys to misc controller but can definitely add limited flexibility. What
kind of keys do you need?

Thanks.

-- 
tejun
