From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v3 00/28] kmem limitation for memcg
Date: Fri, 25 May 2012 09:34:43 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1205250933170.22597@router.home>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <20120525133441.GB30527@tiehlicka.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1337956488; bh=DA0CHtUTU1g+0lnNzBolW8xUEX1pkpmf/NIi/zxAmQ8=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=OCfSe8fD7wR77FDzk7iIbtfoLSooH6Ucg3VycPlOVJXWO38+FbHWXyrZj2HzKdDeao6E5BSJ6D2xIhdcgPGH622xzyJ6nlrmmUI8+gQ/0hbRIKUxm57xkUcA0M2Fk/YAXrg454xlhStm79K+ttqgwNSB0VKVqfaMlWlGQ3Vt2s0=
In-Reply-To: <20120525133441.GB30527@tiehlicka.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>, Suleiman Souhlal <suleiman@google.com>, Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org, David Rientjes <rientjes@google.com>

On Fri, 25 May 2012, Michal Hocko wrote:

> On Fri 25-05-12 17:03:20, Glauber Costa wrote:
> > I believe some of the early patches here are already in some trees around.
> > I don't know who should pick this, so if everyone agrees with what's in here,
> > please just ack them and tell me which tree I should aim for (-mm? Hocko's?)
> > and I'll rebase it.
>
> memcg-devel tree is only to make development easier. Everything that
> applies on top of this tree should be applicable to both -mm and
> linux-next.
> So the patches should go via traditional Andrew's channel.

It would be best to merge these with my patchset to extract common code
from the allocators. The modifications of individual slab allocators would
then be not necessary anymore and it would save us a lot of work.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
