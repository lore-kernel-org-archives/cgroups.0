From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] mm: memcontrol: memory+swap accounting for cgroup-v2
Date: Tue, 19 Dec 2017 10:25:12 -0800
Message-ID: <CALvZod7pbp0fFUPRnC68qdzkCEUg2YTavq6C6OLxqooCU5VeyQ@mail.gmail.com>
References: <20171219000131.149170-1-shakeelb@google.com> <20171219124908.GS2787@dhcp22.suse.cz>
 <CALvZod5jU9vPoJaf44TVT0_HQpEESiELJU5MD_DDRbcOkPNQbg@mail.gmail.com>
 <20171219152444.GP3919388@devbig577.frc2.facebook.com> <CALvZod5sWWBX69QovOeLBSx9vij7=5cmoSocdTUvh2Uq8=noyQ@mail.gmail.com>
 <20171219173354.GQ3919388@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=TgU4la4R+wGXyQ42kCnAIZNWZ3v+5UVW6cl9VCnE2D4=;
        b=gtE0B0rtSd4sZOR0V0guBYS5HEGqgoqgw0yAnxHkeUDX9S285giLuNR6ja7eFUyom/
         ug7VfSYc3K8G62phA+fXZ2Z6qPfACmdVAiMAV+CPxzZTqNMWc18NfIi8Sqoldlf0jlbp
         cD69v9+Tpya8XD5Y5uo0flQVdsScLyhM/ykXfrfGuSLwA3fBIzkry0wsjH4tgDb6g9pw
         w89dwDiHBS7yzs77uUqAenptNBMXqhRcp4g8lRUHLPB/ii3kvE+Gz+e6tQ5SYEab2rM1
         6x7c3WP+Yh0T3fI3DR98OIOXxdTvYzTm4ZB0Pmf8Uu3LcduVMzSuvwLLaAF7L/UD2FG2
         iekg==
In-Reply-To: <20171219173354.GQ3919388-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Dec 19, 2017 at 9:33 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>
> On Tue, Dec 19, 2017 at 09:23:29AM -0800, Shakeel Butt wrote:
>> To provide consistent memory usage history using the current
>> cgroup-v2's 'swap' interface, an additional metric expressing the
>> intersection of memory and swap has to be exposed. Basically memsw is
>> the union of memory and swap. So, if that additional metric can be
>
> Exposing anonymous pages with swap backing sounds pretty trivial.
>
>> used to find the union. However for consistent memory limit
>> enforcement, I don't think there is an easy way to use current 'swap'
>> interface.
>
> Can you please go into details on why this is important?  I get that
> you can't do it as easily w/o memsw but I don't understand why this is
> a critical feature.  Why is that?
>

Making the runtime environment, an invariant is very critical to make
the management of a job easier whose instances run on different
clusters across the world. Some clusters might have different type of
swaps installed while some might not have one at all and the
availability of the swap can be dynamic (i.e. swap medium outage).

So, if users want to run multiple instances of a job across multiple
clusters, they should be able to specify the limits of their jobs
irrespective of the knowledge of cluster. The best case would be they
just submits their jobs without any config and the system figures out
the right limit and enforce that. And to figure out the right limit
and enforcing it, the consistent memory usage history and consistent
memory limit enforcement is very critical.

thanks,
Shakeel
