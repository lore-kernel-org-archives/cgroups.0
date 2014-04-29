From: Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Protection against container fork bombs [WAS: Re: memcg with kmem
 limit doesn't recover after disk i/o causes limit to be hit]
Date: Tue, 29 Apr 2014 09:59:30 -0700
Message-ID: <CAO_Rewa20dneL8e3T4UPnu2Dkv28KTgFJR9_YSmRBKp-_yqewg@mail.gmail.com>
References: <20140420142830.GC22077@alpha.arachsys.com> <20140422143943.20609800@oracle.com>
 <20140422200531.GA19334@alpha.arachsys.com> <535758A0.5000500@yuhu.biz>
 <20140423084942.560ae837@oracle.com> <20140428180025.GC25689@ubuntumail>
 <20140429072515.GB15058@dhcp22.suse.cz> <20140429130353.GA27354@ubuntumail>
 <20140429154345.GH15058@dhcp22.suse.cz> <CAO_RewYZDGLBAKit4CudTbqVk+zfDRX8kP0W6Zz90xJh7abM9Q@mail.gmail.com>
 <20140429165114.GE6129@localhost.localdomain>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=9r3eNaVSS7HKxT2Ga3cLbSvNnd/UzgNzNTGFljhNT4w=;
        b=VSgZnReyxvkB3/yp8Be5VWzt5ZnNBi7Nv3ar51OWUh0fNlpyJ5WY/yZ8xqLSrzlicS
         j0GPXwFc+QkQSMV/Wru4UESrwu4NgPIqfow88CmsMPuhu2XbM1b/4Z6N7E+BD9+r4r8L
         riY53nRSeBOY8kItbXBfL6srvifuQz+r3cr0yhsjdOk3vRALKmt3PVsKWbKLKSZhiHJq
         GoPBsXCtbnXE6ekg0eOkZlxthWucBeW99w1WPXsknCLmgUgRH6vJo6s1lBeoT+XE06wQ
         Q6cgqgsIDkv7HCDHkGfNXe/+wLtskoCSRfP6cID+1kJYZHsHWqP/Jv/0vN6nZhdJMitT
         MW/A==
In-Reply-To: <20140429165114.GE6129-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Richard Davies <richard-li8END47hbdWk0Htik3J/w@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Marian Marinov <mm-NV7Lj0SOnH0@public.gmane.org>, Max Kellermann <mk-xMchvyqCc6DQT0dZR+AlfA@public.gmane.org>, Tim Hockin <thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Daniel Walsh <dwalsh-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, William Dauchy <wdauchy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Here's the reason it doesn't work for us: It doesn't work.  It was
something like 2 YEARS since we first wanted this, and it STILL does
not work.  You're postponing a pretty simple request indefinitely in
favor of a much more complex feature, which still doesn't really give
me what I want.  What I want is an API that works like rlimit but
per-cgroup, rather than per-UID.

On Tue, Apr 29, 2014 at 9:51 AM, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Tue, Apr 29, 2014 at 09:06:22AM -0700, Tim Hockin wrote:
>> Why the insistence that we manage something that REALLY IS a
>> first-class concept (hey, it has it's own RLIMIT) as a side effect of
>> something that doesn't quite capture what we want to achieve?
>
> It's not a side effect, the kmem task stack control was partly
> motivated to solve forkbomb issues in containers.
>
> Also in general if we can reuse existing features and code to solve
> a problem without disturbing side issues, we just do it.
>
> Now if kmem doesn't solve the issue for you for any reason, or it does
> but it brings other problems that aren't fixable in kmem itself, we can
> certainly reconsider this cgroup subsystem. But I haven't yet seen
> argument of this kind yet.
>
>>
>> Is there some specific technical reason why you think this is a bad
>> idea?
>> I would think, especially in a more unified hierarchy world,
>> that more cgroup controllers with smaller sets of responsibility would
>> make for more manageable code (within limits, obviously).
>
> Because it's core code and it adds complications and overhead in the
> fork/exit path. We just don't add new core code just for the sake of
> slightly prettier interfaces.
