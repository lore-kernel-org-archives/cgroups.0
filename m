From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: 3.10.16 cgroup_mutex deadlock
Date: Mon, 25 Nov 2013 09:20:42 +0800
Message-ID: <5292A5EA.1030501@huawei.com>
References: <20131111220626.GA7509@sbohrermbp13-local.rgmadvisors.com> <52820030.6000806@huawei.com> <20131112143147.GB6049@dhcp22.suse.cz> <20131112155530.GA2860@sbohrermbp13-local.rgmadvisors.com> <20131112165504.GF6049@dhcp22.suse.cz> <20131114225649.GA16725@sbohrermbp13-local.rgmadvisors.com> <20131115062458.GA9755@mtj.dyndns.org> <20131115075401.GB9755@mtj.dyndns.org> <alpine.LNX.2.00.1311171746160.15789@eggly.anvils> <CAJ75kXZYjKwV_XiEB493jNyGRqS395JZyY-S9xQBQJLyaCSOEQ@mail.gmail.com> <20131122221839.GD8981@mtj.dyndns.org> <CAJ75kXabrnxqdtb5SXqm_pYTrSih9yvP38DApF+_P+YZCepTMw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ75kXabrnxqdtb5SXqm_pYTrSih9yvP38DApF+_P+YZCepTMw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: William Dauchy <wdauchy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>

On 2013/11/23 6:54, William Dauchy wrote:
> Hi Tejun,
> 
> On Fri, Nov 22, 2013 at 11:18 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> Just applied to cgroup/for-3.13-fixes w/ stable cc'd.  Will push to
>> Linus next week.
> 
> Thank your for your quick reply. Do you also have a backport for
> v3.10.x already available?
> 

I'll do this after the patch hits mainline, if Tejun doesn't plan to.
