From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/5] sock, cgroup: add sock->sk_cgroup
Date: Tue, 17 Nov 2015 16:31:26 -0500
Message-ID: <20151117213126.GH22864@mtj.duckdns.org>
References: <1447789240-29394-1-git-send-email-tj@kernel.org>
 <1447789240-29394-5-git-send-email-tj@kernel.org>
 <20151117.162554.314531574043190960.davem@davemloft.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=86HiA4COxKvaEIdvHZHxc45g8Bi9j8/9sYoHztEd8Ls=;
        b=NUVV1QbST5n5nE7PRS8m9iwIEaeKPQp/I3yBrwWVIzeeWkbncrPfwvUeppEus/T42O
         m6jib9beV2Er5AhcqSsi3Q2rzOQEU4Ajq7BjVxBJxf6+56PaMXekAzc71NCT8Ra9zSth
         pQw8pibsQAn7pZDd+flXV0oyCHNu5YjkDMgKNMSzVvkNPkirM0uKrzBm05GuQOrn37tR
         mW0bXxgyhVNyNDK4d3Y3HfEMn+/4kWWAvl2QAHpMCcEMdLbbpOhFyCGgE00ZCtR6N2g+
         30HUWwDryj/dDFk6eCAGwHwo84XZpxiYgMUGeuKd5DqoijAI8Ehk53QVPt3I+vG3Nu/B
         wyog==
Content-Disposition: inline
In-Reply-To: <20151117.162554.314531574043190960.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: pablo-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org, kaber-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org, kadlec-K40Dz/62t/MgiyqX0sVFJYdd74u8MsAO@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, coreteam-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org

Hello, David.

On Tue, Nov 17, 2015 at 04:25:54PM -0500, David Miller wrote:
> > In preparation, this patch adds sock->sk_cgroup which points to the
> > associated cgroup.  A sock is associated on creation and stays
> > associated to the same cgroup until freed; unfortunately, this ends up
> > adding another cgroup field to struct sock on top of sk_cgrp_prioidx
> > and sk_classid.  I tried to think of a way to somehow overload the
> > existing fields but couldn't come up with a reasonable one.
> 
> sk->sk_cgrp_prioidx is simply sk->sk_cgroup->id, is it not?

Unfortunately, sk->sk_cgrp_prioidx is an arbitrary value which can be
configured through "net_cls.classid".  :(

> We really need to consolidate this before we stuff even more members
> into the socket for control group support, sorry.

Yeah, it is messy.  I'll see if I can come up with a non-crazy way to
combine the other two fields with ->sk_cgroup.

Thanks.

-- 
tejun
