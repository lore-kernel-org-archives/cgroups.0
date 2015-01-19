From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -mm v2 3/7] cgroup: release css->id after css_free
Date: Mon, 19 Jan 2015 10:42:15 -0500
Message-ID: <20150119154215.GA10570@htj.dyndns.org>
References: <cover.1421664712.git.vdavydov@parallels.com>
 <4d7447a920522c1085ff96c08b2be71e0eb5d896.1421664712.git.vdavydov@parallels.com>
 <20150119143001.GH8140@htj.dyndns.org>
 <20150119151854.GA28598@esperanza>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=F26JhQvDoVU4R2md++KG4Bz5yQO1qnzCnc2rIhH0Aq4=;
        b=n4Dd+L4MGBP5gsGlhfF0mu9gwqbPiYH+k/eBa4C1pIDX+PvBOZcVrWZdeMQoYRsRh1
         6i+JhH1lK9pA2gCMVwMjUeL85pK17yRz+P89aUpIZ7ie4PChDXRUGWi9Ok4zEQGDfXSe
         0orHn9BQ23mDmu1sgtq3zsUbrgQzPxeRA3xRe5hbAZIJT+LwdwUQ8s4pD9gsE1i7QaVd
         awmP2Z4X/IEYcbRNBck7A9j2kkN4C48j650QqKnZo/ewCOkdnN8dGNXCP1WWkPFctSMF
         tyzpAw4DNJr15nO3BfjzCYM/kYvhblUmU5hF7/PwF9AIFrcYYQyEZWGiVxL4IR6RCulB
         zcsA==
Content-Disposition: inline
In-Reply-To: <20150119151854.GA28598@esperanza>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Jan 19, 2015 at 06:18:54PM +0300, Vladimir Davydov wrote:
> Could you please elaborate this? I mean, what problems do you think can
> arise if we release css->id a little bit (one grace period) later?
> 
> Of course, I can introduce yet another id per memcg, but I think we have
> css->id to avoid code duplication in controllers.

lol, my brainfart.  Never mind.  I thought you were moving it to
offline.  Please feel free to add my acked-by.

Thanks.

-- 
tejun
