From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] memcg: first step towards hierarchical controller
Date: Tue, 26 Jun 2012 16:19:26 +0200
Message-ID: <1340720366.21991.84.camel@twins>
References: <1340717428-9009-1-git-send-email-glommer@parallels.com>
	 <20120626141127.GA27816@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20120626141127.GA27816@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Glauber Costa <glommer@parallels.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>, Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Tejun Heo <tj@kernel.org>

On Tue, 2012-06-26 at 16:11 +0200, Johannes Weiner wrote:
>=20
> Should the warning be emitted for any memcg, not just the parent?  If
> somebody takes notice of the changed semantics, it's better to print
> the warning on the first try to disable hierarchies instead of holding
> back until they walk up the tree and try to change it in the root.
> Still forbid disabling at lower levels, just be more eager to inform
> the people trying it.=20

*blink* You mean you can mix-and-match use_hierarchy over the hierarchy?
Can I have some of those drugs? It must be strong and powerful stuff
that.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
