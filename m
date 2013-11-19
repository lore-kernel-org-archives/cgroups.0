From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: 3.10.16 cgroup_mutex deadlock
Date: Tue, 19 Nov 2013 10:55:18 +0800
Message-ID: <528AD316.10001@huawei.com>
References: <20131111220626.GA7509@sbohrermbp13-local.rgmadvisors.com> <52820030.6000806@huawei.com> <20131112143147.GB6049@dhcp22.suse.cz> <20131112155530.GA2860@sbohrermbp13-local.rgmadvisors.com> <20131112165504.GF6049@dhcp22.suse.cz> <20131114225649.GA16725@sbohrermbp13-local.rgmadvisors.com> <20131115062458.GA9755@mtj.dyndns.org> <20131115075401.GB9755@mtj.dyndns.org> <alpine.LNX.2.00.1311171746160.15789@eggly.anvils> <20131118201025.GA2747@sbohrermbp13-local.rgmadvisors.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131118201025.GA2747-/vebjAlq/uFE7V8Yqttd03bhEEblAqRIDbRjUBewulXQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>

> Thanks Tejun and Hugh.  Sorry for my late entry in getting around to
> testing this fix. On the surface it sounds correct however I'd like to
> test this on top of 3.10.* since that is what we'll likely be running.
> I've tried to apply Hugh's patch above on top of 3.10.19 but it
> appears there are a number of conflicts.  Looking over the changes and
> my understanding of the problem I believe on 3.10 only the
> cgroup_free_fn needs to be run in a separate workqueue.  Below is the
> patch I've applied on top of 3.10.19, which I'm about to start
> testing.  If it looks like I botched the backport in any way please
> let me know so I can test a propper fix on top of 3.10.19.
> 

You didn't move css free_work to the dedicate wq as Tejun's patch does.
css free_work won't acquire cgroup_mutex, but when destroying a lot of
cgroups, we can have a lot of css free_work in the workqueue, so I'd
suggest you also use cgroup_destroy_wq for it.

