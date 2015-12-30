From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v4.4-rc7] sched: isolate task_struct bitfields according
 to synchronization domains
Date: Wed, 30 Dec 2015 12:43:48 -0800
Message-ID: <CA+55aFx5awBuuroUXt363w9WXn+TvqfoeKu6VYALu_BONQKb3w@mail.gmail.com>
References: <55FEC685.5010404@oracle.com>
	<20150921200141.GH13263@mtj.duckdns.org>
	<20151125144354.GB17308@twins.programming.kicks-ass.net>
	<20151125150207.GM11639@twins.programming.kicks-ass.net>
	<CAPAsAGwa9-7UBUnhysfek3kyWKMgaUJRwtDPEqas1rKwkeTtoA@mail.gmail.com>
	<20151125174449.GD17308@twins.programming.kicks-ass.net>
	<20151211162554.GS30240@mtj.duckdns.org>
	<20151215192245.GK6357@twins.programming.kicks-ass.net>
	<20151230092337.GD3873@htj.duckdns.org>
	<CA+55aFx0WxoUPrOPaq3HxM+YUQQ0DPV-c3f8kE1ec7agERb_Lg@mail.gmail.com>
	<20151230204140.GA17398@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=MMXR0l5JjSKza8pJvjD3sBUyxnXt40dGa9FGa5/92W0=;
        b=RZORFNk0BlJ1xYrCt9hUJkNWjL06ZJxOFOfN3oqR/lgA1UNU8KcOMrBGJBYHmUTOo+
         aNiFBqTKoYF231V4shvRrRrph4F/kDZ6AA+A9jIGyL0xzpetw79nciojZgULLE+8Qi44
         FkBy3KTfVVWdUjWoWJ/tmVLosYlPxNmED2kImGY9icJu0qjZa3SGEFTdx0C3j+WTwJm/
         AABXdkCYXE6+XJZ2jiYJmMQX0xzqJ7tuZVBQWXWU73qxTI7PbHKPX+zt6tYbBLPPI/fg
         ObxnlL4C+2x06gA3cR1AB4dy9I0emh9XhELVSD9gpllXRcByPJWbmUr/Jka9KpWZZQ0b
         J9gw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=MMXR0l5JjSKza8pJvjD3sBUyxnXt40dGa9FGa5/92W0=;
        b=PC4ycLFAlORt2Gs7zFi0um7mv3GTy5lx0H29oT5xpFy3WHLVb+sKK/MsTINJv2oLYr
         OcXbgXcPZHxWkypm2t0QL3Qdukw0PMgooZoCUOcB+LIYvKAFdQLmKGw4cF3CIshWOrkA
         SXDNUcBFx4AJwgxtwIzonjp75zAWOKhywZv+M=
In-Reply-To: <20151230204140.GA17398@htj.duckdns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Ingo Molnar <mingo@redhat.com>, Sasha Levin <sasha.levin@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, cgroups <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Vladimir Davydov <vdavydov@parallels.com>, kernel-team <kernel-team@fb.com>, Dmitry Vyukov <dvyukov@google.com>, Peter Zijlstra <peterz@infradead.org>

On Wed, Dec 30, 2015 at 12:41 PM, Tejun Heo <tj@kernel.org> wrote:
>
> Right, I was thinking alpha was doing rmw's for things smaller than
> 64bit.  That's 32bit, not 64.

Right. Alpha has trouble only with 8-bit and 16-bit fields. 32-bit
fields should be "atomic" on all architectures, modulo compiler bugs
(and we've had those).

                 Linus

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
