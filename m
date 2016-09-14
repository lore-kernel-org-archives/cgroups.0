From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH v5 0/6] Add eBPF hooks for cgroups
Date: Wed, 14 Sep 2016 13:36:55 +0200
Message-ID: <57D93657.6020806@iogearbox.net>
References: <1473696735-11269-1-git-send-email-daniel@zonque.org> <20160913115627.GA4898@salvia> <da300784-284c-0d1f-a82e-aa0a0f8ae116@zonque.org> <20160913172408.GC6138@salvia> <20160914044217.GA44742@ast-mbp.thefacebook.com> <20160914103038.GA910@salvia>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20160914103038.GA910@salvia>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Pablo Neira Ayuso <pablo@netfilter.org>, Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Daniel Mack <daniel@zonque.org>, htejun@fb.com, ast@fb.com, davem@davemloft.net, kafai@fb.com, fw@strlen.de, harald@redhat.com, netdev@vger.kernel.org, sargun@sargun.me, cgroups@vger.kernel.org

On 09/14/2016 12:30 PM, Pablo Neira Ayuso wrote:
> On Tue, Sep 13, 2016 at 09:42:19PM -0700, Alexei Starovoitov wrote:
> [...]
>> For us this cgroup+bpf is _not_ for filterting and _not_ for security.
>
> If your goal is monitoring, then convert these hooks not to allow to
> issue a verdict on the packet, so this becomes inoquous in the same
> fashion as the tracing infrastructure.
>
> [...]
>> I'd really love to have an alternative to bpf for such tasks,
>> but you seem to spend all the energy arguing against bpf whereas
>> nft still has a lot to be desired.
>
> Please Alexei, stop that FUD. Anyone that has spent just one day using
> the bpf tooling and infrastructure knows you have problems to
> resolve...

Not quite sure on the spreading of FUD, but sounds like we should all
get back to technical things to resolve. ;)
