From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] memcg: Slow down swap allocation as the available
 space gets depleted
Date: Mon, 20 Apr 2020 13:06:50 -0400
Message-ID: <20200420170650.GA169746@mtj.thefacebook.com>
References: <20200417162355.GA43469@mtj.thefacebook.com>
 <CALvZod4ftvXCu8SbQUXwTGVvx5K2+at9h30r28chZLXEB1JdfQ@mail.gmail.com>
 <20200417173615.GB43469@mtj.thefacebook.com>
 <CALvZod7-r0OrJ+-_uCy_p3BU3348ve2+YatiSdLvFaVqcqCs=w@mail.gmail.com>
 <20200417193539.GC43469@mtj.thefacebook.com>
 <CALvZod6LT25t9aAA1KHmf1U4-L8zSjUXQ4VQvX4cMT1A+R_g+w@mail.gmail.com>
 <20200417225941.GE43469@mtj.thefacebook.com>
 <CALvZod6M4OsM-t8m_KX9wCkEutdwUMgbP9682eHGQor9JvO_BQ@mail.gmail.com>
 <20200420164740.GF43469@mtj.thefacebook.com>
 <20200420170318.GV27314@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vTaZ4A2xTqoec4rGQUiY61oQkfvMOHet/Q+PpcugyL4=;
        b=p9afyDhuR3jY0COsZkjOIfXAXTeTXRlgReAqvf2PU8RvxkM+vIo1afbuo1bJLxOUAp
         /HNtVWe2r/q3jx7v2Ds2n/s7z8C4HJjn8SAda+rEZlSgfJeIq9oRfwNcAseIhO9fxU9Y
         /gZGtnAPJdbrkJFJE7T7KpyPS2viADjItryD+mfVzsKNg6A+D7F4O9Ux+Mk7g2sjn7bZ
         Vof9BFDh9p6dm5Phv0maPfBMmZvwBKHQsKTI+ore0hQngEtHOB3GFLdw+bZNROYTElXY
         3cyMefG2Qs2HJAzVWqVYHLIm3Su+ARxxalpQKmnwLXE/SonvG3lS3/WDxsIRGaQRdbVD
         yzww==
Content-Disposition: inline
In-Reply-To: <20200420170318.GV27314-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Mon, Apr 20, 2020 at 07:03:18PM +0200, Michal Hocko wrote:
> I have asked about the semantic of this know already and didn't really
> get any real answer. So how does swap.high fit into high limit semantic
> when it doesn't act as a limit. Considering that we cannot reclaim swap
> space I find this really hard to grasp.

memory.high slow down is for the case when memory reclaim can't be depended
upon for throttling, right? This is the same. Swap can't be reclaimed so the
backpressure is applied by slowing down the source, the same way memory.high
does.

It fits together with memory.low in that it prevents runaway anon allocation
when swap can't be allocated anymore. It's addressing the same problem that
memory.high slowdown does. It's just a different vector.

Thanks.

-- 
tejun
