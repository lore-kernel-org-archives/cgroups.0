From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v3 13/28] slub: create duplicate cache
Date: Wed, 30 May 2012 10:37:49 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1205301036220.28968@router.home>
References: <alpine.DEB.2.00.1205291101580.6723@router.home> <4FC501E9.60607@parallels.com> <alpine.DEB.2.00.1205291222360.8495@router.home> <4FC506E6.8030108@parallels.com> <alpine.DEB.2.00.1205291424130.8495@router.home> <4FC52612.5060006@parallels.com>
 <alpine.DEB.2.00.1205291454030.2504@router.home> <4FC52CC6.7020109@parallels.com> <alpine.DEB.2.00.1205291514090.2504@router.home> <4FC530C0.30509@parallels.com> <20120530012955.GA4854@google.com> <4FC5D228.2070100@parallels.com>
 <CAOS58YPqOBgmXQia5wM1FKKj5zD2K6gbC3EyQyppFnVSM2i-gQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1338392274; bh=CL9Q7LB6S9Ia3YZPsBpTU8ALKlrAWHuHH97L03QB0+0=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=DbINdVRuH+pb3vU3SdeqEo/cHH83jUzivaiWb2cuBAXvYOx7offUuEQQd8LXqDB/IZoKFvcnAPne1Kymd8IPKmNxNwPEojDlq0dPG/Tc9ui10xvi8NfvdXwhLLJ67AeErWyFX5Vy9BFJhCq+Mi7tKeICfoXgYy2dvBlkIks9//I=
In-Reply-To: <CAOS58YPqOBgmXQia5wM1FKKj5zD2K6gbC3EyQyppFnVSM2i-gQ@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>, Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@cs.helsinki.fi>

On Wed, 30 May 2012, Tejun Heo wrote:

> Yeah, I prefer your per-cg cache approach but do hope that it stays as
> far from actual allocator code as possible. Christoph, would it be
> acceptable if the cg logic is better separated?

Certainly anything that would allow this to be separated out would be
appreciated. I do not anticipate to ever run cgroup in my environment and
that is due to the additional latency created in key OS paths. Memory we
have enough. The increased cache footprint is killing performance.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
