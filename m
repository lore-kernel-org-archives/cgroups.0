From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v3 13/28] slub: create duplicate cache
Date: Tue, 29 May 2012 14:26:02 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1205291424130.8495@router.home>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-14-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205290932530.4666@router.home> <4FC4F1A7.2010206@parallels.com> <alpine.DEB.2.00.1205291101580.6723@router.home>
 <4FC501E9.60607@parallels.com> <alpine.DEB.2.00.1205291222360.8495@router.home> <4FC506E6.8030108@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1338319566; bh=iqY36P3aPXCwmdKv9co36wF0FMe+lIjKNp37alooFNY=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=GDgiAK3Cv6x3P0fL0elpAfITzaxUlJ3jZuhBLEIT9Q7eZrDUEumelvjSUxL4Yb2+06n8BhuU1qQUbIQa54+hfac3VcWOY995JWpBt4o2hYXDdFGRRcymHyAda3RmFTCdRkjlsB95PkrOwvJhSY9jPiIln8kvia/ZRAviZfEVdZg=
In-Reply-To: <4FC506E6.8030108@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>, Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@cs.helsinki.fi>

On Tue, 29 May 2012, Glauber Costa wrote:

> But we really need a page to be filled with objects from the same cgroup, and
> the non-shared objects to be accounted to the right place.

No other subsystem has such a requirement. Even the NUMA nodes are mostly
suggestions and can be ignored by the allocators to use memory from other
pages.

> Otherwise, I don't think we can meet even the lighter of isolation guarantees.

The approach works just fine with NUMA and cpusets. Isolation is mostly
done on the per node boundaries and you already have per node statistics.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
