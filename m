From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: IOPS based scheduler (Was: Re: [PATCH 18/21] blkcg: move
 blkio_group_conf->weight to cfq)
Date: Wed, 4 Apr 2012 14:22:38 -0400
Message-ID: <20120404182238.GI12676@redhat.com>
References: <4F7A2B21.5000907@tao.ma>
 <20120403153736.GI5913@redhat.com>
 <4F7B2708.6080504@tao.ma>
 <20120403164959.GJ5913@redhat.com>
 <4F7B32AE.7050900@tao.ma>
 <CANejiEU1qAsvogozY3MjZnpcrbYZO4CkRE8s73WGPc_R5LKV9g@mail.gmail.com>
 <20120404133705.GB12676@redhat.com>
 <4F7C7A91.8040707@tao.ma>
 <20120404165048.GF12676@redhat.com>
 <4F7C824D.2050308@tao.ma>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4F7C824D.2050308-d1IQDZat3X0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tao Ma <tm-d1IQDZat3X0@public.gmane.org>
Cc: Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

On Thu, Apr 05, 2012 at 01:18:05AM +0800, Tao Ma wrote:

[..]
> > I think a large chunk of that iops scheduler code will be borrowed from
> > CFQ code. All the cgroup logic, queue creation logic, group scheduling
> > logic etc. And that's the reason I was still exploring the possibility 
> > of having common code base.
> Yeah, actually I was thinking of abstracting a generic logic, but it
> seems a lot bit hard. Maybe we can try to unify the code later?

I think if we change the cfqq scheduling logic to something similar to
group scheduling logic, it will help a lot.

- Current virtual time based logic does not care whether you are operating
  in time mode or iops mode. Switching cfqq logic to similar logic will
  help moving to iops mode quickly.

- Keeping track of vtime will help that we will get rid of all the
  residual time logic. If some queue was preempted, and did not use full
  slice, we will automaticlally charge it less and give smaller vtime.

- Keeping both the scheduling logic will enable us the smoother
  integration of both cfqq and group logic once we support hierarchical
  cgroups.

- It will also enable easier integration of iops related logic.

So I am in favor of cleaning up CFQ code and change it to deal with both
time as well iops. Seriously, implmenting time or iops is not hard. It is
about rest of the logic like trees, groups which contributes towards bulk
of the code and I am really not convinced that iops scheduler is going to
be different enough that it needs new io scheduler.

Thanks
Vivek
