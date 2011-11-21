From: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Subject: Re: [patch] mm: memcg: shorten preempt-disabled section around
 event checks
Date: Mon, 21 Nov 2011 08:46:07 -0500
Message-ID: <1321883167.20742.4.camel@frodo>
References: <20111121110954.GE1771@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111121110954.GE1771-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Yong Zhang <yong.zhang0-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Luis Henriques <henrix-CCGZq9okbVlg9hUCZPvPmw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 2011-11-21 at 12:09 +0100, Johannes Weiner wrote:
> -rt ran into a problem with the soft limit spinlock inside the
> non-preemptible section, because that is sleeping inside an atomic
> context.  But I think it makes sense for vanilla, too, to keep the
> non-preemptible section as short as possible.  Also, -3 lines.
> 

Johannes,

Thanks for this patch. It is very much appreciated by us -rt folks :)

-- Steve


--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
