From: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH] cpu/hotplug: wait for cpuset_hotplug_work to
 finish on cpu online
Date: Tue, 08 Dec 2020 21:40:57 -0500
Message-ID: <87k0tritvq.fsf@oracle.com>
References: <20201203171431.256675-1-aklimov@redhat.com>
 <20201207083827.GD3040@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=vhPAwGbX5UKJfIemCq3LE77ldW/MS6Z/BCzHi9otysg=;
 b=T4qPBYnl6CDw7MhxbLNUcQjfUzICtHe7Qj9GkVpSQmPaYMc0vvfQl536HZLiYJTvoNJ9
 jVA851tnFUxV62TxuNng9POPjnJibMO3kJeLdLP1o1Fk6m2M/EpmZYaxGU+9aRc27Co5
 bVG0eIucX9pBiqAYyJBL3xcODZJgNK3QhdPLWXGwucydXvAMr25NL+Zvl/dCOW0NmPkn
 nQ3IS9QIgBUoraAEHf7P56v8UAdAsGwRTD+nHgSQetz1MF7CyaV55tU9Wu1hv+2lRvOA
 EdWQ9Gpd5doM08dD2BbYWdVB8UJuefPMG/FwZoN+G+ZNF3Vbbqd00W667q8W20J4gMsj Nw== 
In-Reply-To: <20201207083827.GD3040-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Alexey Klimov <aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yury.norov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, jobaker-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, audralmitchel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, qais.yousef-5wv7dgnIgG8@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, klimov.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> writes:
>> The nature of this bug is also described here (with different consequences):
>> https://lore.kernel.org/lkml/20200211141554.24181-1-qais.yousef-5wv7dgnIgG8@public.gmane.org/
>
> Yeah, pesky deadlocks.. someone was going to try again.

I dug up the synchronous patch

    https://lore.kernel.org/lkml/1579878449-10164-1-git-send-email-prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org/

but surprisingly wasn't able to reproduce the lockdep splat from

    https://lore.kernel.org/lkml/F0388D99-84D7-453B-9B6B-EEFF0E7BE4CC-J5quhbR+WMc@public.gmane.org/

even though I could hit it a few weeks ago.  I'm going to try to mess
with it later, but don't let me hold this up.
