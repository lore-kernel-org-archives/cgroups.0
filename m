From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC v4 4/8] dmabuf: heaps: export system_heap buffers with GPU
 cgroup charging
Date: Tue, 29 Mar 2022 06:50:34 -1000
Message-ID: <YkM42vdq3mdIP9Zl@slm.duckdns.org>
References: <20220328035951.1817417-1-tjmercier@google.com>
 <20220328035951.1817417-5-tjmercier@google.com>
 <YkHH/0Use7F30UUE@phenom.ffwll.local>
 <CABdmKX01p6g_iHsB6dd4Wwh=8iLdYiUqdY6_yyA5ax2YNHt6tQ@mail.gmail.com>
 <YkLGbL5Z3HVCyVkK@phenom.ffwll.local>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oo4DwVPmc4Xc8mHsSOZJPPM1+kxb1H+BME8RduWXyEc=;
        b=fon/v7xEg/MG9yKo0ZhFyVDd8Pi8tu6+Ushj4CQ5i5ZK7JvGdhYA+9e/SNRbZmP9Sv
         pCKmTk3lb6hjAAWbXCrUihV4aR6Osupca5LKufEEjFzjS5dKaHLe0jNplTFUZ36iHnVk
         sTubKidTh4TFkPcklY8dTxB8YzPtwQKC9XMO0UBR3PrCLB/DdkbgqeffVh5WeCzY1Kz3
         JiapQ7p+VMjbsVZb1XgQylMCEerXzU91lVY69si8AUutSOzJsBTatSYV6g7QbeGrvQUa
         oPrdqMZejb1WJMC3kUMFa0DQeBm3jfo1vJfKQPQsi7YcylRvBDYfhLYmZlW2miVTOKKE
         o0Mg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <YkLGbL5Z3HVCyVkK@phenom.ffwll.local>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Vetter <daniel@ffwll.ch>
Cc: "T.J. Mercier" <tjmercier@google.com>, David Airlie <airlied@linux.ie>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <brauner@kernel.org>, Hridya Valsaraju <hridya@google.com>, Suren Baghdasaryan <surenb@google.com>, Sumit Semwal <sumit.semwal@linaro.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Benjamin Gaignard <benjamin.gaignard@linaro.org>, Liam Mark <lmark@codeaurora.org>

On Tue, Mar 29, 2022 at 10:42:20AM +0200, Daniel Vetter wrote:
> Hm I just realized ... are the names in the groups abi? If yes then I
> think we need to fix this before we merge anything.

Yes.

Thanks.

-- 
tejun
