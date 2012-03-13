From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Date: Tue, 13 Mar 2012 08:59:55 -0700
Message-ID: <20120313155955.GB7349@google.com>
References: <20120221211938.GE12236@google.com>
 <20120312221050.GG23255@google.com>
 <1331590938.18960.57.camel@twins>
 <20120312222817.GI23255@google.com>
 <20120313140345.GC29169@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=scKdTid9f9xEJMBSHDW4v0Hctd/Tm/bafltuHppJzWE=;
        b=XRIpQGm0dbCarsXwvPc4nkK8OUX4o9hzbKkhN3wLaHKJPPrjI1WDZsR/tWcfBwn7K9
         CePN3BhN+S94ljJxX4N+XnL1oqCkfkGxg/pJBeBG8G8jS68D2ydB9Wnde9+f51YZLK+5
         BJRE67KfTHn9d+szOQJvijnLSMS0dan3+E4DehmWAQ7S+AMx0XGAzjuwYIIFpNd+GRRR
         cMj0Pm9GtSxUICLq3fVFMfC5oXirtoQNHuJtS4fnvl9i2oV8CWc24Jb4FDmwcllRtZug
         UXmiRpbx2GOXUkvkT8xGxsx/rRo55J6udNtITpsJ5W4Y1DLUSQUPiGJA9OloAeB0vAmK
         kcpg==
Content-Disposition: inline
In-Reply-To: <20120313140345.GC29169-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Schmidt <mschmidt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hey, Vivek.

On Tue, Mar 13, 2012 at 10:03:45AM -0400, Vivek Goyal wrote:
> > With root being treated specially, probably as just being a equal
> > group as other groups, I'm not fully determined about that yet.
> 
> So what wrong with flattening the whole hierarchy and all groups being active
> in the path? It is not worse then second option?
> 
>              root
>        /   |  |  |  \
>       G1  G2  G3 G31 G32

It is worse because while there isn't much need for orthogonal
hierarchies, people often need to apply different limits at different
levels of the hierarchy for different controllers.  ie. it often
happens that the distinction between G31 and G32 matters for one
controller but not for others.  The problem with flattening like you
suggested above is that it isn't a hierarchy at all - membership isn't
recursive.

Imposing limits at single level is an additional restriction and may
cause some config complexity but it'll be at least explicit and can
co-exist with full hierarchy in meaningful way.

Thanks.

-- 
tejun
