From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v6 5/6] net: ipv4, ipv6: run cgroup eBPF egress programs
Date: Mon, 19 Sep 2016 22:39:45 +0200
Message-ID: <20160919203945.GB888@salvia>
References: <1474303441-3745-1-git-send-email-daniel@zonque.org>
 <1474303441-3745-6-git-send-email-daniel@zonque.org>
 <20160919191910.GA984@salvia>
 <20160919201322.GA84770@ast-mbp.thefacebook.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160919201322.GA84770@ast-mbp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Daniel Mack <daniel@zonque.org>, htejun@fb.com, daniel@iogearbox.net, ast@fb.com, davem@davemloft.net, kafai@fb.com, fw@strlen.de, harald@redhat.com, netdev@vger.kernel.org, sargun@sargun.me, cgroups@vger.kernel.org

On Mon, Sep 19, 2016 at 01:13:27PM -0700, Alexei Starovoitov wrote:
> On Mon, Sep 19, 2016 at 09:19:10PM +0200, Pablo Neira Ayuso wrote:
[...]
> > 2) This will turn the stack into a nightmare to debug I predict. If
> >    any process with CAP_NET_ADMIN can potentially attach bpf blobs
> >    via these hooks, we will have to include in the network stack
> 
> a process without CAP_NET_ADMIN can attach bpf blobs to
> system calls via seccomp. bpf is already used for security and policing.

That is a local mechanism, it applies to parent process and child
processes, just like SO_ATTACH_FILTER.

The usecase that we're discussing here enforces a global policy.
