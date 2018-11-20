From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 4/7] cgroup: cgroup v2 freezer
Date: Tue, 20 Nov 2018 08:48:59 -0800
Message-ID: <20181120164859.GY2509588@devbig004.ftw2.facebook.com>
References: <20181117003830.15344-1-guro@fb.com>
 <20181117003830.15344-5-guro@fb.com>
 <20181120162529.GU2509588@devbig004.ftw2.facebook.com>
 <20181120163304.GA21462@tower.DHCP.thefacebook.com>
 <20181120163604.GX2509588@devbig004.ftw2.facebook.com>
 <20181120164349.GB21462@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8CU25lHrO1FY40uNdnhUc0zkm2QTX3yunP2lI1VdBs8=;
        b=Z18SQVnDdQYOEqxh50XaL/a0dCPfQDq3LYrNEJEsQ4VgKNuNiHTSp/aWZEW+8y9xnZ
         wlJD9Ecum4v9RaJZeSKkaSYUUX0tjJOHh2sJqcYTwYg44yGi7i9jZ92miXUIx0vn4Mh+
         DEvl0K0xChGinDY8TUwnBeOohpWKrWobfcnCVt2d/pspLSxYxz42cLXD65RKKp7LL4VF
         EPc73qV1x/fTMOFGNsnkFwc4gM+QHgHbYeaRKaRwUv+Xk0Q9hyC5p9/hHdksrT5wZl6b
         HM3xGjrW3ooHf9r0ytPyicI3KAOGMILG+R+668HI2OM92/Ly+/MlVvnHJqKjjqdc9UC2
         BfCg==
Content-Disposition: inline
In-Reply-To: <20181120164349.GB21462@tower.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Roman Gushchin <guroan@gmail.com>, Oleg Nesterov <oleg@redhat.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

Hello,

On Tue, Nov 20, 2018 at 04:43:52PM +0000, Roman Gushchin wrote:
> > But that wouldn't udpate the cgroup's frozen state and generate
> > notifications, right?
> 
> Why? The task will be eventually trapped into cgroup_enter_frozen(),
> and from there cgroup_update_frozen() will be called.

Because the cgroup is no longer frozen?

> You are right, that notification will not be issued, because the cgroup
> is not changing its state (frozen->frozen). I'm not sure that it makes
> sense to change the cgroup state back and forth in this case. Are there
> any reasons I'm missing?

Imagine the task being trapped in nfs or wherever and not getting into
the freezer for an extended period of time.  That'd make the frozen
state reporting observably and obviously wrong when seen from userland
which can lead to other issues.

But, above all, because the cgroup is not frozen - it may have active
running tasks in it at that point.

Thanks.

-- 
tejun
