From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: PIDs Controller Limit
Date: Fri, 25 Sep 2015 11:39:12 -0400
Message-ID: <20150925153912.GG4449@mtj.duckdns.org>
References: <CAOviyajLPivBQLauYHWTW71PHyvF15X=Ocu8JDc-92s0k3XRwA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=kZl3kshCI5cTTH4GJMZvS/ydOHw9XysQJ5KJWpd81LA=;
        b=TTlUkDCK6BTf3ep8kNHWOtaXHdtZpwGXbvCpqHOUbDregk/opwjseYQNtFUc+BGIFy
         YHgqAGbt/7LjJJcIewjOme3yBcH06YxHbXQ4UUVLo2EnaFZvrWM67uWIY86pmJkaYhmn
         zshSlxgFnbgRg/I1pyUC+iaHng5l93+oLeUs2mcNuiBAE667TGD5nOAWKi1z+hRwPrzz
         E4WILRJdf41rzTa6q0IlXgLHQ/7GTIxnXfHy25PT25YjZonFW7pmFFs4V+gX3Wqxm6i2
         te0BEHI5VyROZ1t4VEP8sDpYU1PVweZdxVlfUqOPRchxOWVzWf7fnGjwudTc3RFYkMpG
         2GjA==
Content-Disposition: inline
In-Reply-To: <CAOviyajLPivBQLauYHWTW71PHyvF15X=Ocu8JDc-92s0k3XRwA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Aleksa.

On Thu, Sep 24, 2015 at 09:42:38AM +1000, Aleksa Sarai wrote:
> Does it make sense for the PIDs controller to allow a user to set a
> limit of 0? Since we don't cancel attaches, a limit of 0 doesn't
> affect anything (nothing stops attaches, and you need to have a
> process in the PIDs cgroup in order for fork()s to be affected by the
> limit). So I think that attempting to set pid.limit to 0 should return
> an -EINVAL.

I don't know.  Why does it matter?

Thanks.

-- 
tejun
