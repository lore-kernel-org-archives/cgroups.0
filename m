From: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
Subject: Re: [PATCH] memcg: first step towards hierarchical controller
Date: Tue, 26 Jun 2012 16:41:09 +0200
Message-ID: <1340721669.21991.85.camel@twins>
References: <1340717428-9009-1-git-send-email-glommer@parallels.com>
	 <20120626141127.GA27816@cmpxchg.org> <1340720366.21991.84.camel@twins>
	 <20120626143818.GB27816@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120626143818.GB27816-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Tue, 2012-06-26 at 16:38 +0200, Johannes Weiner wrote:
> But you can't disable the hierarchy if you have a hierarchy-enabled
> parent, which we try to make the new default. 

Ah ok.. so still crazy, but slightly less insane ;-)
