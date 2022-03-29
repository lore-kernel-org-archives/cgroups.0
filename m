From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC v4 2/8] cgroup: gpu: Add a cgroup controller for allocator
 attribution of GPU memory
Date: Tue, 29 Mar 2022 06:59:43 -1000
Message-ID: <YkM6/57mVxoNfSvm@slm.duckdns.org>
References: <20220328035951.1817417-1-tjmercier@google.com>
 <20220328035951.1817417-3-tjmercier@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=67yHXoFmcX0ZazheDKYQVpHoB656ZGpg7LX2oma8XGY=;
        b=l1oIEc6kFQcKGLgIxGfSwqNZBvaZGfVzYIpmLE5Rh6nGhFdWOqxOLcEiD5UGOeShLo
         a3iUDj7MTnw1ZVoumywlaRlOqrOguzQaaUg8sl/W8xYELNabR0FkepIhxq53qWfWRHqT
         ocM2HSkoX6c1ycU+gtCJdRWBI5LQV8B2NcIE2eGHLknFjpgkEJzAV6QEilvZPsFmftqT
         gEf10uCzq4cyr50t7r+MHukvbyXMswobdfj+UiEjLCGz8uU2kyzlTjXvCPVu1iLyYPLF
         hpLrTonQaPEFCwIiW4cB09XczJYAql+ov2htCytwylqN1iQbCWxBZsm43uimxjTneIJO
         mdzg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220328035951.1817417-3-tjmercier@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "T.J. Mercier" <tjmercier@google.com>
Cc: David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <brauner@kernel.org>, Hridya Valsaraju <hridya@google.com>, Suren Baghdasaryan <surenb@google.com>, Sumit Semwal <sumit.semwal@linaro.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Benjamin Gaignard <benjamin.gaignard@linaro.org>, Liam Mark <lmark@codeaurora.org>, Laura

Hello,

On Mon, Mar 28, 2022 at 03:59:41AM +0000, T.J. Mercier wrote:
> The API/UAPI can be extended to set per-device/total allocation limits
> in the future.

This total thing kinda bothers me. Can you please provide some concrete
examples of how this and per-device limits would be used?

Thanks.

-- 
tejun
