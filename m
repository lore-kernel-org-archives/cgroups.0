From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH net-next] net: Add l3mdev cgroup
Date: Mon, 4 Jan 2016 12:58:36 -0500
Message-ID: <20160104175836.GA11668@mtj.duckdns.org>
References: <1451925136-13327-1-git-send-email-dsa@cumulusnetworks.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=yGKMJTjOx2tng1zCXslqUh+x7XSKT9xIpeTg86L9PmM=;
        b=x+YYrGS/WH5qLQR1KRil4ESDDRgf6MxoaZv9uqPNTFjYc9eFJgHvFD9CiO6UMjPKAe
         mqGKu5hukSA27kphB1jLvsHPd8cszilMpiYRAD0nkiUtpPb5poUUegu1Luv18+vi0xC5
         kqYg5hQAQjxYvvfNLmC6+ZOFqTczw1X+5CTzXdX1bJcKF3FrJaNmWS2eqXtYNd9t/5rj
         AT679PR8czycUEBUaR0KMQvweIplIGTQYpeewJ+Q/7cbF0Wg1yL9faiJHEVnW0N2m+np
         10EOUaUuGi5nCC/BB7fDsFGLmI/07UvWdwexnzHPZdc+yb6kg2yUeXEA9OSfI7ig0van
         GL4Q==
Content-Disposition: inline
In-Reply-To: <1451925136-13327-1-git-send-email-dsa-qUQiAmfTcIp+XZJcv9eMoEEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Ahern <dsa-qUQiAmfTcIp+XZJcv9eMoEEOCMrvLtNR@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shm-qUQiAmfTcIp+XZJcv9eMoEEOCMrvLtNR@public.gmane.org, roopa-qUQiAmfTcIp+XZJcv9eMoEEOCMrvLtNR@public.gmane.org

Hello, David.

On Mon, Jan 04, 2016 at 08:32:16AM -0800, David Ahern wrote:
> Add cgroup to assoicate tasks with L3 networking domains. AF_INET{6}
> sockets opened by tasks associated with an l3mdev cgroup are bound to
> the associated master device when the socket is created. This allows a
> user to run a command (and its children) within an L3 networking context.
> 
> The master-device for an l3mdev cgroup must be an L3 master device
> (e.g., VRF), and it must be set before attaching tasks to the cgroup. Once
> set the master-device can not change. Nested l3mdev cgroups are not
> supported. The root (aka default) l3mdev cgroup can not be bound to a
> master device.
> 
> Example:
>     ip link add vrf-red type vrf table vrf-red
>     ip link set dev vrf-red up
>     ip link set dev eth1 master vrf-red
> 
>     cgcreate -g l3mdev:vrf-red
>     cgset -r l3mdev.master-device=vrf-red vrf-red
>     cgexec -g l3mdev:vrf-red bash

Please don't create any new controller whose sole purpose is
identifying group membership.  Please take a look at how libxt_cgroup
handles identification w/o creating a new controller.

 http://lkml.kernel.org/g/1449527935-27056-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

Thanks.

-- 
tejun
