From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v6 5/6] net: ipv4, ipv6: run cgroup eBPF egress programs
Date: Tue, 20 Sep 2016 16:29:31 +0200
Message-ID: <20160920142931.GA31438@salvia>
References: <1474303441-3745-1-git-send-email-daniel@zonque.org>
 <1474303441-3745-6-git-send-email-daniel@zonque.org>
 <20160919191910.GA984@salvia>
 <ac88bb4c-ab7c-1f74-c7fd-79e523b50ae4@zonque.org>
 <20160919203533.GA888@salvia>
 <83afdc54-1bbe-3530-e5fd-b74fefe9a042@zonque.org>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <83afdc54-1bbe-3530-e5fd-b74fefe9a042@zonque.org>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Mack <daniel@zonque.org>
Cc: htejun@fb.com, daniel@iogearbox.net, ast@fb.com, davem@davemloft.net, kafai@fb.com, fw@strlen.de, harald@redhat.com, netdev@vger.kernel.org, sargun@sargun.me, cgroups@vger.kernel.org

On Mon, Sep 19, 2016 at 10:56:14PM +0200, Daniel Mack wrote:
[...]
> Why would we artificially limit the use-cases of this implementation if
> the way it stands, both filtering and introspection are possible?

Why should we place infrastructure in the kernel to filter packets so
late, and why at postrouting btw, when we can do this way earlier
before any packet is actually sent? No performance impact, no need for
skbuff allocation and *no cycles wasted to evaluate if every packet is
wanted or not*.
