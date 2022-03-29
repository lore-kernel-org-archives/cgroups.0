From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [RFC v4 5/8] dmabuf: Add gpu cgroup charge transfer function
Date: Tue, 29 Mar 2022 17:21:42 +0200
Message-ID: <20220329152142.GA15794@blackbody.suse.cz>
References: <20220328035951.1817417-1-tjmercier@google.com>
 <20220328035951.1817417-6-tjmercier@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1648567304; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n/czKHIPapnBxpdu79ODwmVGjcsUIWEmGzncRJ5TN4Q=;
        b=lbxalIk0hgBTc9ZrvdtVK14x3u1oqMDVbsoiIWRU/HZAKUtFdn9xuq+x4VdQSqRv2NIzra
        6u7dg24T8Ka4DRgQdxJkMClNHbD8rd8VMmEUcF8AeBfKYtvlHup2tBTYs1n4gYuW4kxpnl
        lnJuwJXKKePEEilmmgnC19er+O83O34=
Content-Disposition: inline
In-Reply-To: <20220328035951.1817417-6-tjmercier@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "T.J. Mercier" <tjmercier@google.com>
Cc: David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <brauner@kernel.org>, Hridya Valsaraju <hridya@google.com>, Suren Baghdasaryan <surenb@google.com>, Sumit Semwal <sumit.semwal@linaro.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Benjamin Gaignard <benjamin.gaignard@linaro.org>, Liam Mark <lmark@codeaurora.org>, Laura

Hi.

On Mon, Mar 28, 2022 at 03:59:44AM +0000, "T.J. Mercier" <tjmercier@google.com> wrote:
> From: Hridya Valsaraju <hridya@google.com>
> 
> The dma_buf_charge_transfer function provides a way for processes to

(s/dma_bug_charge_transfer/dma_bug_transfer_charge/)

> transfer charge of a buffer to a different process. This is essential
> for the cases where a central allocator process does allocations for
> various subsystems, hands over the fd to the client who requested the
> memory and drops all references to the allocated memory.

I understood from [1] some buffers are backed by regular RAM. How are
these charges going to be transferred (if so)?


Thanks,
Michal

[1]
https://lore.kernel.org/r/CABdmKX2NSAKMC6rReMYfo2SSVNxEXcS466hk3qF6YFt-j-+_NQ@mail.gmail.com
