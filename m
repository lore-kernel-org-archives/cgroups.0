From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 0/4] Support user xattrs in cgroupfs
Date: Mon, 16 Mar 2020 15:55:39 -0400
Message-ID: <20200316195539.GD1967398@mtj.thefacebook.com>
References: <20200312200317.31736-1-dxu@dxuuu.xyz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2N1eGqL++dHn9tEiH6VJwCetZrqpDOiEdM+2W5iU3ms=;
        b=S1NjRsNCn4oalrekycXgaV8BfxJ15lcoIiCBx9/Yf6rGN1LibEg0IfvlT3gouVDP0z
         p9d8BlEDD5ATlq0TpVZSZTG+y+0z6LSP9y6RR38YOS/eFO3lufuQxn/rIji5Hvf+JjKe
         xURhABe83mZjtF4FMCX2k/+XFH6b+l0SnyTKSsydshKZSvSIYIPqijYHLzOCGAGErYi7
         8UskBwoO+A9HmKiIy7xds87DZdHKeIvZEu+quMa9MOOIu/38vYnP9jNap+S3cgMtTTJO
         mym2Mbo+ZgDMi0BKb0PMTCbNMy8NAcTQKw5uZqmV6Dw+HQ8+jGNvZba2HyeISfJVQf8I
         S1NQ==
Content-Disposition: inline
In-Reply-To: <20200312200317.31736-1-dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Applied to cgroup/for-5.7.

Thanks.

-- 
tejun
