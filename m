From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC v4 2/8] cgroup: gpu: Add a cgroup controller for allocator
 attribution of GPU memory
Date: Mon, 4 Apr 2022 07:41:56 -1000
Message-ID: <Ykst5K/cI+DUVc94@slm.duckdns.org>
References: <20220328035951.1817417-1-tjmercier@google.com>
 <20220328035951.1817417-3-tjmercier@google.com>
 <YkM6/57mVxoNfSvm@slm.duckdns.org>
 <CABdmKX2Gxg35k7QiL2Vn4zWhmQ4UnM-Z8cnOXR0fwBWyJnZ+Ng@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-media-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cN+cryxrTnBG0VJoafZ3s+TyTmI2BuJ8Y3SjnOF9NwE=;
        b=q3aN/qFotQnWnl+DjEG8MO6ne2oneqFucG+YMqB8k3tZY4ziHRZjt9uG5kk2ucPSyJ
         B3t4mekt0LtHaY6B2DxdS9ITSE1r5EeeAd/rhW1xKoa1wo3vU4K2S8P61apUpP5h4bNm
         Ie0A7GhmrIV13SapWYC+pBHHxcMfzG1xl5pi5A5mA6QQacPLxq32GEg+r615aQjVj0cM
         ScAvsigcU1WuLyjMICOCbYf7dvvMMcfNL5CZ9k+EEuJADXpZ4eKJcbWnBjSBr+bT6AiL
         7lCs1XU5CcdliX4j+yjAr9C7RGzTsxJzZ3oMolqcxQoEMANHXQ/CG9u/lINvdUreaUZ7
         6UmQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <CABdmKX2Gxg35k7QiL2Vn4zWhmQ4UnM-Z8cnOXR0fwBWyJnZ+Ng@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "T.J. Mercier" <tjmercier@google.com>
Cc: David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <brauner@kernel.org>, Hridya Valsaraju <hridya@google.com>, Suren Baghdasaryan <surenb@google.com>, Sumit Semwal <sumit.semwal@linaro.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Benjamin Gaignard <benjamin.gaignard@linaro.org>, Liam Mark <lmark@codeaurora.org>, Laura

Hello,

On Wed, Mar 30, 2022 at 01:56:09PM -0700, T.J. Mercier wrote:
> The use case we have for accounting the total (separate from the
> individual devices) is to include the value as part of bugreports, for
> understanding the system-wide amount of dmabuf allocations. I'm not
> aware of an existing need to limit the total. Admittedly this is just
> the sum over the devices, but we currently maintain out of tree code
> to do this sort of thing today. [1]

So, drop this part?

Thanks.

-- 
tejun
