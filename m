From: Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH nf-next v3] netfilter: xtables: lightweight process control
 group matching
Date: Fri, 27 Dec 2013 11:13:15 +0800
Message-ID: <52BCF04B.3070908@huawei.com>
References: <cover.1387815795.git.dborkman@redhat.com> <7d845623366ba0d435d5c82bf318455871929e90.1387815795.git.dborkman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-owner@vger.kernel.org>
In-Reply-To: <7d845623366ba0d435d5c82bf318455871929e90.1387815795.git.dborkman@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Daniel Borkmann <dborkman@redhat.com>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org

On 2013/12/24 1:41, Daniel Borkmann wrote:
> It would be useful e.g. in a server or desktop environment to have
> a facility in the notion of fine-grained "per application" or "per
> application group" firewall policies. Probably, users in the mobile,
> embedded area (e.g. Android based) with different security policy
> requirements for application groups could have great benefit from
> that as well. For example, with a little bit of configuration effort,
> an admin could whitelist well-known applications, and thus block
> otherwise unwanted "hard-to-track" applications like [1] from a
> user's machine. Blocking is just one example, but it is not limited
> to that, meaning we can have much different scenarios/policies that
> netfilter allows us than just blocking, e.g. fine grained settings
> where applications are allowed to connect/send traffic to, application
> traffic marking/conntracking, application-specific packet mangling,
> and so on.
> 
> Implementation of PID-based matching would not be appropriate
> as they frequently change, and child tracking would make that
> even more complex and ugly. Cgroups would be a perfect candidate
> for accomplishing that as they associate a set of tasks with a
> set of parameters for one or more subsystems, in our case the
> netfilter subsystem, which, of course, can be combined with other
> cgroup subsystems into something more complex if needed.
> 
> As mentioned, to overcome this constraint, such processes could
> be placed into one or multiple cgroups where different fine-grained
> rules can be defined depending on the application scenario, while
> e.g. everything else that is not part of that could be dropped (or
> vice versa), thus making life harder for unwanted processes to
> communicate to the outside world. So, we make use of cgroups here
> to track jobs and limit their resources in terms of iptables
> policies; in other words, limiting, tracking, etc what they are
> allowed to communicate.
> 
> In our case we're working on outgoing traffic based on which local
> socket that originated from. Also, one doesn't even need to have
> an a-prio knowledge of the application internals regarding their
> particular use of ports or protocols. Matching is *extremly*
> lightweight as we just test for the sk_classid marker of sockets,
> originating from net_cls. net_cls and netfilter do not contradict
> each other; in fact, each construct can live as standalone or they
> can be used in combination with each other, which is perfectly fine,
> plus it serves Tejun's requirement to not introduce a new cgroups
> subsystem. Through this, we result in a very minimal and efficient
> module, and don't add anything except netfilter code.
> 

I'd suggest splitting cls_cgroup code into 2 parts. The first part
is to manage cgroupfs and classid, and should be put into net/core/
and add a new config like NET_CGROUP_CLASSID for it. The second part
is specific cls_cgroup code.

