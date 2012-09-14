From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC] cgroup TODOs
Date: Fri, 14 Sep 2012 13:15:02 +0200
Message-ID: <1347621302.7172.22.camel@twins>
References: <20120913205827.GO7677@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120913205827.GO7677@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@suse.cz>, Glauber Costa <glommer@parallels.com>, Paul Turner <pjt@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>, "Serge E. Hallyn" <serue@us.ibm.com>, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, Neil Horman <nhorman@tuxdriver.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

On Thu, 2012-09-13 at 13:58 -0700, Tejun Heo wrote:
>   The cpu ones handle nesting correctly - parent's accounting includes
>   children's, parent's configuration affects children's unless
>   explicitly overridden, and children's limits nest inside parent's. 

The implementation has some issues with fixed point math limitations on
deep hierarchies/large cpu count, but yes.

Doing soft-float/bignum just isn't going to be popular I guess ;-)

People also don't seem to understand that each extra cgroup carries a
cost and that nested cgroups are more expensive still, even if the
intermediate levels are mostly empty (libvirt is a good example of how
not to do things).

Anyway, I guess what I'm saying is that we need to work on the awareness
of cost associated with all this cgroup nonsense, people seem to think
its all good and free -- or not think at all, which, while depressing,
seem the more likely option.
