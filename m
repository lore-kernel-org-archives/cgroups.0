From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] memcg: Slow down swap allocation as the available
 space gets depleted
Date: Tue, 21 Apr 2020 11:20:47 -0400
Message-ID: <20200421152047.GA5462@mtj.thefacebook.com>
References: <20200417173615.GB43469@mtj.thefacebook.com>
 <CALvZod7-r0OrJ+-_uCy_p3BU3348ve2+YatiSdLvFaVqcqCs=w@mail.gmail.com>
 <20200417193539.GC43469@mtj.thefacebook.com>
 <CALvZod6LT25t9aAA1KHmf1U4-L8zSjUXQ4VQvX4cMT1A+R_g+w@mail.gmail.com>
 <20200417225941.GE43469@mtj.thefacebook.com>
 <CALvZod6M4OsM-t8m_KX9wCkEutdwUMgbP9682eHGQor9JvO_BQ@mail.gmail.com>
 <20200420164740.GF43469@mtj.thefacebook.com>
 <20200420170318.GV27314@dhcp22.suse.cz>
 <20200420170650.GA169746@mtj.thefacebook.com>
 <20200421110612.GD27314@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jwGeQzDdrOzdJlAD0ghWVZoxVjm5XtEA2WK3XkkvxyQ=;
        b=FXrADtfByQlNUBEu1vViyehbFKOhBU4dp73jUXSMQGEAoigcpdrozcO5N83yOhXOq7
         +ukk+fWtA9qV3xkAfsTaSRJ9oHuy247FfqCAQoc9ctvnDd5qagUr9M9GMJRKjbEypcuE
         y7tMsSMoVKMH0y8GXyRFyqKVVXLlvT5p+2bN225RNns1qJ4BaWr90ubNBeg0E8aZa1cP
         vdmlxNuhT6GxrpDAx8ygVkMC6JUmhFQjeD0e6jYj7GGdQZEIQFikaRxvASiVC9jWHSst
         KWoB96kLu/3CiDEYFNffV1ofM8GWKhn4Z7D8wyf0iLMsCXR5Np1H2q+J9zCgeSt2ZI82
         H3Eg==
Content-Disposition: inline
In-Reply-To: <20200421110612.GD27314-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Tue, Apr 21, 2020 at 01:06:12PM +0200, Michal Hocko wrote:
> I suspect that the problem is more related to the swap being handled as
> a separate resource. And it is still not clear to me why it is easier
> for you to tune swap.high than memory.high. You have said that you do
> not want to set up memory.high because it is harder to tune but I do
> not see why swap is easier in this regards. Maybe it is just that the
> swap is almost never used so a bad estimate is much easier to tolerate
> and you really do care about runaways?

Johannes responded a lot better. I'm just gonna add a bit here.

Swap is intertwined with memory but is a very different resource from
memory. You can't seriously equate primary and secondary storages. We never
want to underutilize memory but we never want to completely fill up
secondary storage. They're exactly the opposite in that sense. It's not that
protection schemes can't apply to swap but that such level of dynamic
control isn't required because simple upper limit is useful and easy enough.

Another backing point I want to raise is that the abrupt transition which
happens on swap depletion is a real problem that userspace has been trying
to work around. memory.low based protection and oomd is an obvious example
but not the only one. earlyoom[1] is an independent project which predates
all these things and kills when swap runs low to protect the system from
going down the gutter.

In this respect, both oomd and earlyoom basically do the same thing but
they're racing against the kernel filling up the space. Once the swap space
is gone, the programs themselves might not be able to make reasonable
forward progress. The only measure they can currently employ is polling more
frequently and killing ealier so that swap space never actually runs out,
but it's a silly and losing game as the underyling device gets faster and
faster.

Note that at least fedora is considering including either earlyoom or oomd
by default. The problem addressed by swap.high is real and immediate.

Thanks.

-- 
tejun

[1] https://github.com/rfjakob/earlyoom
