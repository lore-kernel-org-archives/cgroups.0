From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH V3 2/8] Make TestSetPageDirty and dirty page accounting
 in one func
Date: Sat, 5 Jan 2013 11:45:38 +0100
Message-ID: <20130105104538.GB24698@dhcp22.suse.cz>
References: <1356455919-14445-1-git-send-email-handai.szj@taobao.com>
 <1356456156-14535-1-git-send-email-handai.szj@taobao.com>
 <20130102090803.GB22160@dhcp22.suse.cz>
 <CAFj3OHUCQkqB2+ky9wxFpkNYcn2=6t9Qd7XFf3RBY0F4Wxyqcg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFj3OHUCQkqB2+ky9wxFpkNYcn2=6t9Qd7XFf3RBY0F4Wxyqcg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Sat 05-01-13 10:49:00, Sha Zhengju wrote:
[...]
> >> Here is some test numbers that before/after this patch:
> >> Test steps(Mem-4g, ext4):
> >> drop_cache; sync
> >> fio (ioengine=sync/write/buffered/bs=4k/size=1g/numjobs=2/group_reporting/thread)
> >
> > Could also add some rationale why you think this test is relevant?
> >
> 
> The test is aiming at finding the impact of performance due to lock
> contention by writing parallel
> to the same file. I'll add the reason next version too.

Please make sure to describe which locks are exercised during that test
and how much.

Thanks
[...]
-- 
Michal Hocko
SUSE Labs
