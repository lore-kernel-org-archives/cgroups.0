From: Paolo Abeni <pabeni@redhat.com>
Subject: Re: Re: [PATCH net-next v5 2/3] sock: Always take memcg pressure
 into consideration
Date: Mon, 05 Jun 2023 10:27:47 +0200
Message-ID: <727b1fb64d04deb8b2a9ae1fec4b51dafa1ff2b5.camel@redhat.com>
References: <20230602081135.75424-1-wuyun.abel@bytedance.com>
	 <20230602081135.75424-3-wuyun.abel@bytedance.com>
	 <20230602204159.vo7fmuvh3y2pdfi5@google.com>
	 <CAF=yD-LFQRreWq1RMkvLw9Nj3NQpJwbDSCfECUhh-aVchR-jsg@mail.gmail.com>
	 <6f67c3ca-5e73-d7ac-f32a-42a21d3ea576@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev+bounces-7912-gl-netdev-2=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685953673;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4k9ejeJipUmGqnerdW7qBglT2xl37GJzyfeka156tNU=;
	b=N3j9uRW9PDOuxWpMCDlzm6RTNykzq3BsFtKeEs+XPF3w4eYVpxVX1hQQ/6k711lBrklxFe
	9fuOFVBgabHzvLcp+Zfyw6t2zE8R8xk9yhXYEWVn4Kcxfyc/SwN2Q4GeE87TNHGMFU6yLs
	oTQiABBNhrGtT++sVmrkbiJd6l2azr0=
In-Reply-To: <6f67c3ca-5e73-d7ac-f32a-42a21d3ea576@bytedance.com>
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Abel Wu <wuyun.abel@bytedance.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>, Shakeel Butt <shakeelb@google.com>
Cc: "David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Muchun Song <muchun.song@linux.dev>, Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 2023-06-05 at 11:44 +0800, Abel Wu wrote:
> On 6/4/23 6:36 PM, Willem de Bruijn wrote:
> > On Fri, Jun 2, 2023 at 10:42=E2=80=AFPM Shakeel Butt <shakeelb@google.c=
om> wrote:
> > >=20
> > > On Fri, Jun 02, 2023 at 04:11:34PM +0800, Abel Wu wrote:
> > > > The sk_under_memory_pressure() is called to check whether there is
> > > > memory pressure related to this socket. But now it ignores the net-
> > > > memcg's pressure if the proto of the socket doesn't care about the
> > > > global pressure, which may put burden on its memcg compaction or
> > > > reclaim path (also remember that socket memory is un-reclaimable).
> > > >=20
> > > > So always check the memcg's vm status to alleviate memstalls when
> > > > it's in pressure.
> > > >=20
> > >=20
> > > This is interesting. UDP is the only protocol which supports memory
> > > accounting (i.e. udp_memory_allocated) but it does not define
> > > memory_pressure. In addition, it does have sysctl_udp_mem. So
> > > effectively UDP supports a hard limit and ignores memcg pressure at t=
he
> > > moment. This patch will change its behavior to consider memcg pressur=
e
> > > as well. I don't have any objection but let's get opinion of UDP
> > > maintainer.

Thanks for the head-up, I did not notice the side effect on UDP.

>=20
> > So this commit only affects the only other protocol-independent
> > caller, __sk_mem_reduce_allocated, to possibly call
> > sk_leave_memory_pressure if now under the global limit.
> >=20
> > What is the expected behavioral change in practice of this commit?
>=20
> Be more conservative on sockmem alloc if under memcg pressure, to
> avoid worse memstall/latency.

I guess the above is for TCP sockets only, right? Or at least not for
UDP sockets?

If so, I think we should avoid change of behaviour for UDP - e.g.
keeping the initial 'if (!sk->sk_prot->memory_pressure)' in
sk_under_memory_pressure(), with some comments about the rationale for
future memory. That should preserve the whole patchset effect for other
protocols, right?

If instead you are also interested into UDP sockets under pressure, how
that is going to work? UDP sockets can reclaim memory only at send and
close time. A memcg under pressure could starve some sockets forever if
the the ones keeping the memory busy are left untouched.

Cheers,

Paolo


