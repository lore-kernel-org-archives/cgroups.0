From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v2 02/13] memcg: Kernel memory accounting infrastructure.
Date: Thu, 15 Mar 2012 15:21:23 +0400
Message-ID: <4F61D0B3.8000300@parallels.com>
References: <1331325556-16447-1-git-send-email-ssouhlal@FreeBSD.org>  <1331325556-16447-3-git-send-email-ssouhlal@FreeBSD.org>  <4F5C5E54.2020408@parallels.com>  <20120313152446.28b0d696.kamezawa.hiroyu@jp.fujitsu.com>  <4F5F236A.1070609@parallels.com>  <20120314091526.3c079693.kamezawa.hiroyu@jp.fujitsu.com>  <4F608F25.3010700@parallels.com> <4F613C5B.8030304@jp.fujitsu.com>  <4F61CD63.4090007@parallels.com> <1331810014.18960.172.camel@twins>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1331810014.18960.172.camel@twins>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Peter Zijlstra <peterz@infradead.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Suleiman Souhlal <ssouhlal@FreeBSD.org>, cgroups@vger.kernel.org, suleiman@google.com, penberg@kernel.org, cl@linux.com, yinghan@google.com, hughd@google.com, gthelen@google.com, dan.magenheimer@oracle.com, hannes@cmpxchg.org, mgorman@suse.de, James.Bottomley@HansenPartnership.com, linux-mm@kvack.org, devel@openvz.org, linux-kernel@vger.kernel.org

On 03/15/2012 03:13 PM, Peter Zijlstra wrote:
> On Thu, 2012-03-15 at 15:07 +0400, Glauber Costa wrote:
>> But since I never heard of any machine with
>> 9223372036854775807 bytes of memory, that is true even for the root memcg
>
> What, you don't have more than 8 exabyte of memory in your laptop !?
> Surely you're due for an upgrade then.

Yeah, I requested it already, but I was told it could take a while

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
