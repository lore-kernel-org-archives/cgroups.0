From: Li Zefan <lizefan@huawei.com>
Subject: Re: 3.10.16 cgroup_mutex deadlock
Date: Tue, 3 Dec 2013 09:37:52 +0800
Message-ID: <529D35F0.60108@huawei.com>
References: <20131111220626.GA7509@sbohrermbp13-local.rgmadvisors.com> <52820030.6000806@huawei.com> <20131112143147.GB6049@dhcp22.suse.cz> <20131112155530.GA2860@sbohrermbp13-local.rgmadvisors.com> <20131112165504.GF6049@dhcp22.suse.cz> <20131114225649.GA16725@sbohrermbp13-local.rgmadvisors.com> <20131115062458.GA9755@mtj.dyndns.org> <20131115075401.GB9755@mtj.dyndns.org> <alpine.LNX.2.00.1311171746160.15789@eggly.anvils> <CAJ75kXZYjKwV_XiEB493jNyGRqS395JZyY-S9xQBQJLyaCSOEQ@mail.gmail.com> <20131122221839.GD8981@mtj.dyndns.org> <CAJ75kXabrnxqdtb5SXqm_pYTrSih9yvP38DApF+_P+YZCepTMw@mail.gmail.com> <5292A5EA.1030501@huawei.com> <CAJ75kXYKx67VaGYRs1nwataE2ra216qTB9Yks=MRGFN-c_b3uA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJ75kXYKx67VaGYRs1nwataE2ra216qTB9Yks=MRGFN-c_b3uA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: William Dauchy <wdauchy@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>, Shawn Bohrer <shawn.bohrer@gmail.com>, Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Markus Blank-Burian <burian@muenster.de>

On 2013/12/2 18:31, William Dauchy wrote:
> Hi Li,
> 
> On Mon, Nov 25, 2013 at 2:20 AM, Li Zefan <lizefan@huawei.com> wrote:
>> I'll do this after the patch hits mainline, if Tejun doesn't plan to.
> 
> Do you have some news about it?
> 

Tejun has already done the backport. :)

It has been included in 3.10.22, which will be released in a couple of days.

http://article.gmane.org/gmane.linux.kernel.stable/71292
