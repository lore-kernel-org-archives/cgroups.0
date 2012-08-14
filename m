From: Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH v2 06/11] memcg: kmem controller infrastructure
Date: Tue, 14 Aug 2012 11:58:10 -0700
Message-ID: <xr93ipcl9u7x.fsf@gthelen.mtv.corp.google.com>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com>
	<1344517279-30646-7-git-send-email-glommer@parallels.com>
	<50254475.4000201@jp.fujitsu.com> <5028BA9E.7000302@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        bh=v4hRGWfYkyhaXgQoMmn3Pt6nMr5nNLY1LbpndlQKYyA=;
        b=n7hp2GC40Bel1lFZrKmCJomaHA5ST9g8HYRWm+ZojVmD8d9BO8mmcnWSkQxoXK8wyC
         ve6TGu0cxH2fKt8uk+HJvNshbNR2GFORKrqwZVCpYZWOPpG6EpktXoh6QJeMlK8fa2/0
         0xVZgNfy1D+ujE22NKgpFt1G98u+qCDh1Ya6uyKIOrPWS0yQo3l5HJNjaIPl91MQ5l9H
         VSEkHmSpoQq6JwxQle40ZtPsIM3ye0aaODxpHDE0mh160BpHwdhaNgnQIRKkcW0svPmR
         vuJ/lIimq9bX+2c6bmXQSI4S1AEcEk04T+4IxGRWM2PgL+bnSBIzqK0duXRFoOm269+s
         j71A==
In-Reply-To: <5028BA9E.7000302@parallels.com> (Glauber Costa's message of
	"Mon, 13 Aug 2012 12:28:14 +0400")
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>

On Mon, Aug 13 2012, Glauber Costa wrote:

>>> > +	WARN_ON(mem_cgroup_is_root(memcg));
>>> > +	size = (1 << order) << PAGE_SHIFT;
>>> > +	memcg_uncharge_kmem(memcg, size);
>>> > +	mem_cgroup_put(memcg);
>> Why do we need ref-counting here ? kmem res_counter cannot work as
>> reference ?
> This is of course the pair of the mem_cgroup_get() you commented on
> earlier. If we need one, we need the other. If we don't need one, we
> don't need the other =)
>
> The guarantee we're trying to give here is that the memcg structure will
> stay around while there are dangling charges to kmem, that we decided
> not to move (remember: moving it for the stack is simple, for the slab
> is very complicated and ill-defined, and I believe it is better to treat
> all kmem equally here)

By keeping memcg structures hanging around until the last referring kmem
page is uncharged do such zombie memcg each consume a css_id and thus
put pressure on the 64k css_id space?  I imagine in pathological cases
this would prevent creation of new cgroups until these zombies are
dereferenced.

Is there any way to see how much kmem such zombie memcg are consuming?
I think we could find these with
for_each_mem_cgroup_tree(root_mem_cgroup).  Basically, I'm wanting to
know where kernel memory has been allocated.  For live memcg, an admin
can cat memory.kmem.usage_in_bytes.  But for zombie memcg, I'm not sure
how to get this info.  It looks like the root_mem_cgroup
memory.kmem.usage_in_bytes is not hierarchically charged.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
