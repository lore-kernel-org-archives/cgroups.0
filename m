From: Christoph Lameter <cl@linux.com>
Subject: Re: [patch 2/2] fs: buffer: move allocation failure loop into the
 allocator
Date: Thu, 5 Dec 2013 18:50:50 +0000
Message-ID: <00000142c4192155-e27322df-ba1a-4af8-98c3-f2b15dd70d13-000000@email.amazonses.com>
References: <1381265890-11333-1-git-send-email-hannes@cmpxchg.org> <1381265890-11333-2-git-send-email-hannes@cmpxchg.org> <20131203165910.54d6b4724a1f3e329af52ac6@linux-foundation.org> <20131204015218.GA19709@lge.com> <20131203180717.94c013d1.akpm@linux-foundation.org>
 <00000142be2f1de0-764bb035-adbc-4367-b2b4-bf05498510a6-000000@email.amazonses.com> <CAAmzW4PwLhMd61ksOktdg=rkj0xHsSGt2Wm_za2Adjh4+tss-g@mail.gmail.com> <00000142be753b07-aa0e2354-6704-41f8-8e11-3c856a186af5-000000@email.amazonses.com>
 <20131205084441.GA5561@lge.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20131205084441.GA5561@lge.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, azurIt <azurit@pobox.sk>, Linux Memory Management List <linux-mm@kvack.org>, cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christian Casteyde <casteyde.christian@free.fr>, Pekka Enberg <penberg@kernel.org>

On Thu, 5 Dec 2013, Joonsoo Kim wrote:

> I could try. But my trial would not figure this out, since my machine has
> just 4 cores which normally cannot produce heavy contention.

I think that is fine for starters. Once we know what to look for we can
find machines to test specific scenarios.

> Anyway, could you tell me where I can find your synthetic benchmarks for slab?

https://lkml.org/lkml/2009/10/13/459

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
