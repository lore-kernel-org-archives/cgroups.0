From: Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v0 3/4] cgroup: net_cls: Pass in task to
 sock_update_classid()
Date: Wed, 17 Oct 2012 18:15:13 +0200
Message-ID: <1350490513.26103.650.camel@edumazet-glaptop>
References: <1350479078-29361-1-git-send-email-wagi@monom.org>
	 <1350479078-29361-4-git-send-email-wagi@monom.org>
	 <1350481041.26103.454.camel@edumazet-glaptop>  <507ED4C0.7070408@monom.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        bh=NjKuHZosaYF2UqiZhu1rE0Q7iJ9wpuyiCoadVYM3dlo=;
        b=xT9PYJ3DjV7CMDxB9FzAYKtlvU3wW6n2Ilpn/AukXmBpFGf3YsADCayxfTdsYJWNVv
         AQMSvmWZ3BtwRc7xqGWLrrCvUKb6C8VcoxVX0cdbHkqw4S6ahuYT6GjeLyZT/5rAFq42
         TaeT8f3LWQBBLfz1yI1/znk6EIpEdg/qYU/rSTVYxysreVFKBQK79naoPMe99mFrLqu6
         WYV2WPoUVE24vd+1BvnP3hKpGyWUHgHyooM9s6+Jd4tQCDunu1xN3X8ot14TIGMIK4qb
         lBHGBkKtlj5rqCfQYyv55A2OUbS0t8jP52+d2NQYMZQw4NiydCor1Tb2I/ORhngCrQRW
         HGUA==
In-Reply-To: <507ED4C0.7070408-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, Stanislav Kinsbursky <skinsbursky-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Wed, 2012-10-17 at 17:54 +0200, Daniel Wagner wrote:

> I still have not figured all details on the patch submission procedure. 
> Sorry about that. The time to send patches for net-next will be annonced 
> by David, is this correct?
> 

Exactly. David sent a mail yesterday :

On Mon, 2012-10-15 at 23:19 -0400, David Miller wrote:
> Please stop sending feature patches and cleanups.
> 
> I'll be sure to let the list know when net-next is
> ready for submissions again, thanks.
> 
> Thank you.
> -- 


