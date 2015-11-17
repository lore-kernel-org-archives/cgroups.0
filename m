From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/5] kernfs: implement kernfs_walk_and_get()
Date: Tue, 17 Nov 2015 16:22:26 -0500
Message-ID: <20151117212226.GG22864@mtj.duckdns.org>
References: <1447789240-29394-1-git-send-email-tj@kernel.org>
 <1447789240-29394-3-git-send-email-tj@kernel.org>
 <20151117.162040.1412296298973879057.davem@davemloft.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=nZLjp/eRx2MzQzGYLmL/+nYeq6moEEXjoWg2UyTcfnI=;
        b=MNDy2i8dRa8o7UGCFdNSXdBiN4g5E/lVpwKQbkuKP4aB3hQl+IhRx66Hz1QknNNFb4
         4zQUNTJ/Ccv9Sl9J1gGuoR/wL7+roqIcX+odzpCcTcAGJZPnPgBvLYqGzV/fRmMWjDWE
         qN7HVj1/kMt+kTYgMpYoOFzOeyx7V0jvIrw8qDe4FCi1CgOd857jFA3Lvm+bedpmcIQp
         QQbfp3s29Y14Im1zo+cfj15/yURwTjZXAG/2rySnSZ/yjTljO3zIznbHTFi7eiXGtp2/
         hN9K7D5KmeV99V+YokoTh1knp2wW5mAtAE4w+KjEI4pyLFIbajp7UFKyawHRO3F5PADs
         Zckg==
Content-Disposition: inline
In-Reply-To: <20151117.162040.1412296298973879057.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu, lizefan@huawei.com, hannes@cmpxchg.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, daniel@iogearbox.net, daniel.wagner@bmw-carit.de, nhorman@tuxdriver.com, gregkh@linuxfoundation.org

On Tue, Nov 17, 2015 at 04:20:40PM -0500, David Miller wrote:
> From: Tejun Heo <tj@kernel.org>
> Date: Tue, 17 Nov 2015 14:40:37 -0500
> 
> > +	static char path_buf[PATH_MAX];	/* protected by kernfs_mutex */
> > +	int len = strlen(path);
>  ...
> > +	if (len >= PATH_MAX)
> > +		return NULL;
> > +
> > +	memcpy(path_buf, path, len + 1);
> 
> 	static char path_buf[PATH_MAX];	/* protected by kernfs_mutex */
> 	int len = strlcpy(path_buf, path, PATH_MAX);
>  ...
> 	if (len >= PATH_MAX)
> 		return NULL;

That's a lot better.  Will update.

Thanks.

-- 
tejun
